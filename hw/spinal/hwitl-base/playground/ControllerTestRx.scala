package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._

case class ControllerTestRx() extends Component {
  val io = new Bundle {
    val uart = master(new Uart())
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

  val tic = new TranslatorInterfaceController()
  val uartCtrl = new UartCtrl()
  val rxFifo = new StreamFifo(dataType = Bits(8 bits), depth = 16)

  // wiring
  tic.io.resp.busy := io.resp.busy
  io.resp.respType := tic.io.resp.respType
  io.resp.enable := tic.io.resp.enable
  io.resp.clear := tic.io.resp.clear
  tic.io.timeout.pending := io.timeout.pending
  io.timeout.clear := tic.io.timeout.clear
  io.bus.write := tic.io.bus.write
  io.bus.enable := tic.io.bus.enable
  tic.io.bus.busy := io.bus.busy
  io.reg.enable.address   := tic.io.reg.enable.address
  io.reg.enable.writeData := tic.io.reg.enable.writeData
  io.reg.enable.command   := tic.io.reg.enable.command
  io.reg.enable.readData  := tic.io.reg.enable.readData
  io.reg.clear := tic.io.reg.clear
  io.shiftReg.enable := tic.io.shiftReg.enable
  io.shiftReg.clear := tic.io.shiftReg.clear
  tic.io.rx.fifoEmpty := (rxFifo.io.occupancy === 0)

  // wire uart
  uartCtrl.io.config.setClockDivider(115200 Hz)
  uartCtrl.io.config.frame.dataLength := 7 // 8 bits
  uartCtrl.io.config.frame.parity := UartParityType.NONE
  uartCtrl.io.config.frame.stop := UartStopType.ONE
  uartCtrl.io.writeBreak := False
  uartCtrl.io.uart <> io.uart
  uartCtrl.io.write.payload := 0
  uartCtrl.io.write.valid := False

  rxFifo.io.push << uartCtrl.io.read
  rxFifo.io.pop >> tic.io.rx.fifo
}
