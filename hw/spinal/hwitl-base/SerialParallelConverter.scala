package hwitlbase

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.fsm._

case class SerialParallelConverter(inDataSize: Long, outDataSize: Long) extends Component {
  // assert indatatype size has to be integer-divisible by outdatatype

  val io = new Bundle {
    val shiftEnable = in(Bool())
    val clear = in(Bool())
    val inData = in(Bits(inDataSize bits))
    val outData = out(Bits(outDataSize bits))
  }

}
