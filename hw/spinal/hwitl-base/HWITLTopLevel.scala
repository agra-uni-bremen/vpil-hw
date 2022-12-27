package hwitlbase

import spinal.core._

/**
 * Configuration class for HWITL config
 * @param 
 * 
 */
case class HWITLConfig(
    uartBaudRate : Long = 9600,
    uartTxFifoSize : Int = 16,
    uartRxFifoSize : Int = 16
){

}

// Hardware definition
case class HWITLTopLevel() extends Component {
  val io = new Bundle {
  }

}

object HWITLTopLevelVerilog extends App {
  Config.spinal.generateVerilog(HWITLTopLevel())
}
