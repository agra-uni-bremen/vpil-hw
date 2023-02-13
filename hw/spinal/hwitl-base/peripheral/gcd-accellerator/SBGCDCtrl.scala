package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.slave

class SBGCDCtrl() extends Component {
  val io = new Bundle {
    val sb = slave(SimpleBus(32, 32))
    val sel = in(Bool())
  }
  val gcdCtrl = new GCDTop()
  val busCtrl = new SimpleBusSlaveController()

  val regA = Reg(UInt(32 bits)) init(0)
  val regB = Reg(UInt(32 bits)) init(0)
  val regResBuf = RegNextWhen(gcdCtrl.io.res, gcdCtrl.io.ready)
  val regValid = RegNext(False) init(False) // for single cycle valid assertions
  val regReadyBuf = RegNextWhen(gcdCtrl.io.ready, gcdCtrl.io.ready)
  val sbDataOutputReg = Reg(Bits(32 bits)) init(0)

  val mmioRegLogic = new Area {    
    val read = io.sb.SBvalid && io.sel && !io.sb.SBwrite
    val write = io.sb.SBvalid && io.sel && io.sb.SBwrite
    sbDataOutputReg := 0
    val addr = io.sb.SBaddress
    // address mapping logic
    when(write) {
      when(addr === 0) {
        regA := io.sb.SBwdata.asUInt
      }.elsewhen(addr === 4) {
        regB := io.sb.SBwdata.asUInt
      }.elsewhen(addr === 8) {
        // result is RO
      }.elsewhen(addr === 12) {
        // ready is RO
      }.elsewhen(addr === 16) {
        regValid := (io.sb.SBwdata === B(1, 32 bits))
      }
    }.elsewhen(read) {
      when(addr === 0) {
        sbDataOutputReg := regA.asBits
      }.elsewhen(addr === 4) {
        sbDataOutputReg := regB.asBits
      }.elsewhen(addr === 8) {
        sbDataOutputReg := regResBuf.asBits
        // clear res and ready on read
        regResBuf := 0
        regReadyBuf := False
      }.elsewhen(addr === 12) {
        sbDataOutputReg := B(regReadyBuf, 32 bits)
      }.elsewhen(addr === 16) {
        // valid is WO
      }
    }
  }

  gcdCtrl.io.valid := regValid
  gcdCtrl.io.a := regA
  gcdCtrl.io.b := regB
  busCtrl.io.valid := io.sb.SBvalid
  busCtrl.io.select := io.sel
  io.sb.SBready := busCtrl.io.ready
  io.sb.SBrdata := sbDataOutputReg
}
