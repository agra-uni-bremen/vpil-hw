package hwitlbase

import spinal.core._
import spinal.lib.fsm._
import spinal.lib.IMasterSlave
import spinal.lib._

object ResponseType extends SpinalEnum {
  val noPayload, payload = newElement()
}

case class ResponseBuilder() extends Component {
  val io = new Bundle {
    val txFifo = master(Stream(Bits(8 bits)))
    val txFifoEmpty = in(Bool())
    val ctrl = new Bundle {
      val respType = in(ResponseType())
      val enable = in(Bool())
      val busy = out(Bool())
      val clear = in(Bool())
    }
    val data = new Bundle {
      val ack = in(Bits(7 bits))
      val irq = in(Bool())
      val readData = in(Bits(32 bits))
    }
  }
  // val dAck = Reg(Bits(7 bits)) init (0)
  // val dIrq = Reg(Bool) init (False)
  // val dRData = Reg(Bits(32 bits)) init (0)
  // val statusByte = dIrq ## dAck

  val rbFSM = new StateMachine {
    val byteCounter = Counter(0 to 5)
    val busyFlag = Reg(Bool()) init (False)
    io.ctrl.busy := busyFlag
    io.txFifo.valid := False
    val idle: State = new State with EntryPoint {
      whenIsActive {
        byteCounter.clear()
        when(io.ctrl.enable) {
          goto(txStatus)
        }
      }
      onExit {
        byteCounter.clear()
        busyFlag := True
      }
    }
    val txStatus: State = new State {
      whenIsActive {
        io.txFifo.valid := True
        // when a byte is consumed by the tx fifo, increment the counter for bytes
        when(io.txFifo.ready) {
          byteCounter.increment()
        }
        // handle different response types for either 1 or 5 byte response
        when(io.ctrl.respType === ResponseType.noPayload) {
          when(byteCounter === 1) {
            io.txFifo.valid := False
            goto(waitTx)
          }
        }.elsewhen(io.ctrl.respType === ResponseType.payload) {
          when(byteCounter === 1) {
            goto(txPayload)
          }
        }
      }
    }
    val txPayload: State = new State {
      whenIsActive {
        io.txFifo.valid := True
        // when a byte is consumed by the tx fifo, increment the counter for bytes
        when(io.txFifo.ready) {
          byteCounter.increment()
        }
        // when all bytes are sent, go back to and wait for the fifo content to be sent
        when(byteCounter === 5) {
          io.txFifo.valid := False
          goto(waitTx)
        }
      }
    }
    val waitTx: State = new State {
      whenIsActive {
        // if the tx fifo is empty we're ready to handle another request
        when(io.txFifoEmpty) {
          busyFlag := False
          goto(idle)
        }
      }
    }
  }
  val payloadByte = rbFSM.byteCounter.value.mux(
    0 -> B(io.data.irq ## io.data.ack, 8 bits),
    1 -> io.data.readData(31 downto 24),
    2 -> io.data.readData(23 downto 16),
    3 -> io.data.readData(15 downto 8),
    4 -> io.data.readData(7 downto 0),
    default -> B(0, 8 bits)
  )
  io.txFifo.payload := payloadByte
}

object ResponseBuilderVerilog extends App {
  Config.spinal.generateVerilog(ResponseBuilder()).printPruned
}
