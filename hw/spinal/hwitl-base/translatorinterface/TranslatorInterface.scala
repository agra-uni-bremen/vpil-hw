package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

case class TranslatorInterface() extends Component {
  val io = new Bundle {

  }
  val tic = new TranslatorInterfaceController()

  //******** Datapath of HW in the Loop glue logic *********
  val hwitlDatapath = new Area {
    val command = Reg(Bits(8 bits)) init(0)
    val address = Reg(Bits(32 bits)) init(0)
    val writeData = Reg(Bits(32 bits)) init(0)
    val readData = Reg(Bits(32 bits)) init(0)
    when(tic.io.reg.clear) {
      List(command, address, writeData, readData).foreach(_ := 0)
    }
    when(tic.io.reg.enable.command) {
      command := rxFifo.io.pop.payload
    }
    when(tic.io.reg.enable.address) {
      address := serParConv.io.outData
    }
    when(tic.io.reg.enable.writeData) {
      writeData := serParConv.io.outData
    }
    when(tic.io.reg.enable.readData) {
      readData := io.sb.readData
    }
  }
}