package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

object CommandByte {
  def reset = B"8'x00"
  def read = B"8'x01"
  def write = B"8'x02"
  def getIrq = B"8'x03"
  def exit = B"8'x04"
}

object Request extends SpinalEnum {
  val none, read, write, clear, unsupported = newElement()
}

// Transaction Interface Controller (TIC)
case class TranslatorInterfaceController() extends Component {
  val io = new Bundle {
    val rx = new Bundle {
      val fifo = slave(Stream(Bits(8 bits)))
      val fifoEmpty = in(Bool())
    }
    val resp = master(ResponseControlIF())
    val timeout = new Bundle {
      val pending = in(Bool())
      val clear = out(Bool())
    }
    val bus = new Bundle {
      val write = out(Bool())
      val enable = out(Bool())
      val busy = in(Bool())
    }
    val reg = new Bundle {
      val enable = new Bundle {
        val address = out(Bool())
        val writeData = out(Bool())
        val command = out(Bool())
        val readData = out(Bool())
      }
      val clear = out(Bool())
    }
    val shiftReg = new Bundle {
      val enable = out(Bool())
      val clear = out(Bool())
    }
  }

  val tic = new StateMachine {
    // val addressCounter = Counter(0 to 3)
    // val wdataCounter = Counter(0 to 3)
    // we can probably use one counter at a time anyway => reuse = less area
    val wordCounter = Counter(0 to 4)
    val commandFlag = Reg(Request()) init(Request.none)

    io.rx.fifo.ready := False
    io.resp.respType := ResponseType.noPayload
    io.resp.enable := False
    io.resp.clear := False
    io.bus.enable := False
    io.bus.write := (commandFlag === Request.write)
    io.timeout.clear := False
    io.reg.enable.address := False
    io.reg.enable.writeData := False
    io.reg.enable.command := False
    io.reg.enable.readData := False
    io.reg.clear := False
    io.shiftReg.enable := False
    io.shiftReg.clear := False

    val idle : State = new State with EntryPoint {
      whenIsActive {
        wordCounter.clear()
        commandFlag := Request.none
        io.reg.clear := True
        io.timeout.clear := True
        when(io.rx.fifo.valid) {
          goto(command)
        }
      }
    }

    val command : State = new State {
      whenIsActive {
        // when(io.rx.fifo.valid) {
        // }
        io.reg.enable.command := True
        io.rx.fifo.ready := True
        switch(io.rx.fifo.payload){
          is(CommandByte.reset) { 
            commandFlag := Request.clear
            goto(clear) 
          }
          is(CommandByte.read) {
            commandFlag := Request.read
            goto(shiftAddressBytes)
          }
          is(CommandByte.write) { 
            commandFlag := Request.write
            goto(shiftAddressBytes)
          }
          // NOTE: no implemented yet exit, get interrupt, send unsupported ack byte
          default {
            commandFlag := Request.unsupported
            goto(startResponse)
          }
        }
      }
    }

    val shiftAddressBytes : State = new State {
      whenIsActive {
        io.shiftReg.enable := io.rx.fifo.valid
        io.rx.fifo.ready := True
        when(io.rx.fifo.valid && !wordCounter.willOverflowIfInc) {
          wordCounter.increment()
        }.elsewhen(wordCounter.willOverflowIfInc) { 
          goto(writeAddressWord)
        }.elsewhen(io.timeout.pending) {
          goto(clear)
        }
      }
    }

    val writeAddressWord : State = new State {
      whenIsActive {
        io.reg.enable.address := True
        wordCounter.clear()
        switch(commandFlag) {
          is(Request.read) {
            goto(startTransaction)
          }
          is(Request.write) {
            goto(shiftWriteDataBytes)
          }
          // this shouldnt happen at this point
          // but for robustness less recover to idle which clears registers
          default { 
            goto(idle)
          }
        }
      }
    }

    // this is very similar to shiftAddressDataBytes just the next state 
    // from here is writeWriteDataWord (which is only different by nextState and enable signal too)
    // NOTE: could optimize this here, but for robustness and less nextState logic keep it this way
    val shiftWriteDataBytes : State = new State {
      whenIsActive {
        io.shiftReg.enable := io.rx.fifo.valid
        io.rx.fifo.ready := True
        when(io.rx.fifo.valid && !wordCounter.willOverflowIfInc) {
          wordCounter.increment()
        }.elsewhen(wordCounter.willOverflowIfInc) { 
          goto(writeWriteDataWord)
        }.elsewhen(io.timeout.pending) {
          goto(clear)
        }
      }
    }

    val writeWriteDataWord : State = new State {
      whenIsActive {
        io.reg.enable.writeData := True
        wordCounter.clear()
        goto(startTransaction)
      }
    }

    val startTransaction : State = new State {
      whenIsActive {
        io.bus.enable := True
        when(io.bus.busy){
          goto(waitTransaction)
        }
      }
    }
    
    val waitTransaction : State = new State {
      whenIsActive {
        io.reg.enable.readData := !(io.bus.write)
        when(!io.bus.busy) {
          goto(startResponse)
        }.elsewhen(io.timeout.pending) {
          goto(clear)
        }
      }
    }

    val clear : State = new State {
      whenIsActive {
        io.reg.clear := True
        io.resp.clear := True
        io.shiftReg.clear := True
        io.timeout.clear := True
        commandFlag := Request.none
        wordCounter.clear()
        goto(idle)
      }
    }

    val startResponse : State = new State {
      whenIsActive {
        io.resp.enable := True
        when(io.resp.busy) {
          goto(waitResponse)
        }
      }
    }

    val waitResponse : State = new State {
      whenIsActive {
        when(!io.resp.busy) {
          goto(idle)
        }.elsewhen(io.timeout.pending) {
          goto(clear)
        }
      }
    }
  }
}

object TranslatorInterfaceControllerVerilog extends App {
  Config.spinal.generateVerilog(TranslatorInterfaceController()).printPruned
}
