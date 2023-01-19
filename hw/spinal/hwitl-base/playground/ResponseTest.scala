package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._

case class ResponseTest() extends Component {
  val io = new Bundle {
    val uart = master(new Uart())
    val resp = new Bundle {
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
  }
  val builder = new ResponseBuilder()
  val txFifo = new StreamFifo(dataType = Bits(8 bits), depth = 16)
  val uartCtrl = new UartCtrl()

  // wire builder
  io.resp.ctrl.busy := builder.io.ctrl.busy
  builder.io.ctrl.respType := io.resp.ctrl.respType
  builder.io.ctrl.enable := io.resp.ctrl.enable
  builder.io.ctrl.clear := io.resp.ctrl.clear
  builder.io.data.ack := io.resp.data.ack
  builder.io.data.irq := io.resp.data.irq
  builder.io.data.readData := io.resp.data.readData
  builder.io.txFifoEmpty := (txFifo.io.occupancy === 0)

  // wire uart
  uartCtrl.io.config.setClockDivider(115200 Hz)
  uartCtrl.io.config.frame.dataLength := 7 // 8 bits
  uartCtrl.io.config.frame.parity := UartParityType.NONE
  uartCtrl.io.config.frame.stop := UartStopType.ONE
  uartCtrl.io.writeBreak := False
  uartCtrl.io.uart <> io.uart

  // wire tx fifo
  txFifo.io.push << builder.io.txFifo
  uartCtrl.io.write << txFifo.io.pop

}
