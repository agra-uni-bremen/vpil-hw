package hwitlbase

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.fsm._

case class SerialParallelConverter(inDataSize: Int, outDataSize: Int) extends Component {
  assert(
    assertion = inDataSize < outDataSize, // while '<=' would formally work, having same size input and output makes this just a buffer
    message = "inDataSize must be smaller than outDataSize"
  )
  assert(
    assertion = (outDataSize % inDataSize == 0), 
    message = "data sizes must be integer-divisible"
  )  
  val io = new Bundle {
    val shiftEnable = in(Bool())
    val clear = in(Bool())
    val outputEnable = in(Bool())
    val inData = in(Bits(inDataSize bits))
    val outData = out(Bits(outDataSize bits))
  }
  val shiftReg = Vec(Reg(Bits(inDataSize bits)) init(0), outDataSize/inDataSize)
  // apply shift to register, discards LSB
  when(io.shiftEnable) {
    shiftReg(0) := io.inData
    for(idx <- 1 to (outDataSize/inDataSize)-1) {
      shiftReg(idx) := shiftReg(idx-1)
    }
  }
  // clear shift register to all zeroes
  when(io.clear) {
    shiftReg.foreach(_ := 0)
  }
  // enable output to content of shift register, otherwise all zeroes
  io.outData := io.outputEnable ? shiftReg.asBits | 0
}


object SerialParallelConverterTop {
  def main(args: Array[String]) {
    Config.spinal.generateVerilog(new SerialParallelConverter(32,32)).printPruned()
  }
}
