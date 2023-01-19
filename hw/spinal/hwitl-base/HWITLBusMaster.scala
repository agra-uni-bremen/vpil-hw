package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

object AcknowledgeCode {
  // NOTE: 7 bits width for ack status
  def never = B"7'x00"
  def ok = B"7'x01"
  def not_mapped = B"7'x02"
  def command_not_supported = B"7'x03"
}

case class HWITLBusMaster() extends Component {
  val io = new Bundle {
    val sb = master(SimpleBus(32, 32))
    val ctrl = new Bundle {
      val enable = in(Bool())
      val write = in(Bool())
      val busy = out(Bool())
      val unmappedAccess = in(Bool())
    }
    val reg = new Bundle {
      val enable = new Bundle {
        val address = in(Bool())
        val writeData = in(Bool())
        val command = in(Bool())
        val readData = in(Bool())
      }
      val clear = in(Bool())
      val data = in(Bits(32 bits))
      val command = in(Bits(8 bits))
    }
    val response = new Bundle {
      val irq = out(Bool())
      val ack = out(Bits(7 bits))
      val payload = out(Bits(32 bits))
    }
  }
  val busCtrl = new SimpleBusMasterController()
  busCtrl.io.ctrl.enable := io.ctrl.enable
  io.ctrl.busy := busCtrl.io.ctrl.busy

  // //******** Datapath of HW in the Loop glue logic *********
  val command = Reg(Bits(8 bits)) init (0)
  val address = Reg(Bits(32 bits)) init (0)
  val writeData = Reg(Bits(32 bits)) init (0)
  val readData = Reg(Bits(32 bits)) init (0)
  val ackCode = Bits(7 bits)
  when(io.reg.clear) {
    List(command, address, writeData, readData).foreach(_ := 0)
  }
  when(io.reg.enable.command) {
    command := io.reg.command
  }
  when(io.reg.enable.address) {
    address := io.reg.data
  }
  when(io.reg.enable.writeData) {
    writeData := io.reg.data
  }
  when(io.reg.enable.readData) {
    readData := io.sb.SBrdata
  }

  ackCode := command.mux(
    CommandByte.reset -> AcknowledgeCode.ok,
    CommandByte.read -> AcknowledgeCode.ok,
    CommandByte.write -> AcknowledgeCode.ok,
    CommandByte.getIrq -> AcknowledgeCode.command_not_supported,
    CommandByte.exit -> AcknowledgeCode.ok,
    default -> AcknowledgeCode.command_not_supported
  )

  // ******** SimpleBus data path *********
  io.sb.SBaddress := U(address, 32 bits)
  io.sb.SBwdata := writeData
  io.sb.SBsize := 4
  io.sb.SBwrite := io.ctrl.write
  io.sb.SBvalid := busCtrl.io.bus.valid
  busCtrl.io.bus.ready := io.sb.SBready

  // irqs currently not supported
  io.response.irq := False
  // if the read/write access was to unmapped region, change acknowledge code
  io.response.ack := !io.ctrl.unmappedAccess ? ackCode | B(AcknowledgeCode.not_mapped, 7 bits)
  // if payload is needed, its gonna be data read from the bus
  io.response.payload := readData

}

object HWITLBusMasterVerilog extends App {
  Config.spinal.generateVerilog(HWITLBusMaster()).printPruned
}
