package hwitlbase

import spinal.core._
import spinal.lib.slave

class NoMapPeriphral extends Component {
  val io = new Bundle {
    val sb = slave(SimpleBus(32, 32))
    val sel = in(Bool())
    val fired = out(Bool())
    val clear = in(Bool())
  }
  // generates the ready signal next cycle if valid and select are available
  val busCtrl = new SimpleBusSlaveController()
  busCtrl.io.valid := io.sb.SBvalid
  busCtrl.io.select := io.sel
  io.sb.SBready := busCtrl.io.ready

  val firedFlag = Reg(Bool()) init (False)

  // register logic
  io.sb.SBrdata := 0 // default value
  // if this peripheral is talked to, set fired flag
  when(io.sb.SBvalid & io.sel) {
    firedFlag := True
  }
  // also make clear possible
  when(io.clear) {
    firedFlag := False
  }
  io.fired := firedFlag
}
