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
    val txFifo = master(Stream(UInt(8 bits)))
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
  val dAck = Reg(Bits(7 bits)) init (0)
  val dIrq = Reg(Bool) init (False)
  val dRData = Reg(Bits(32 bits)) init (0)
  val statusByte = dIrq ## dAck

}

object ResponseBuilderVerilog extends App {
  Config.spinal.generateVerilog(ResponseBuilder())
}
