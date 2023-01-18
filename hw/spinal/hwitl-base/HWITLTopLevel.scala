package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._

/**
 * Default configuration parameters for the HWitL system
 */
case class HWITLConfig(
    uartBaudRate : Long = 115200,
    uartTxFifoSize : Int = 16,
    uartRxFifoSize : Int = 16,
    timeoutDelay : TimeNumber = 2 ms
){}

// Hardware definition
case class HWITLTopLevel(config : HWITLConfig) extends Component {
  val io = new Bundle {
    val uart = master(new Uart())
  }

  //******** HW in the Loop elements *********
  val uartCtrl = new UartCtrl()
  val rxFifo = new StreamFifo(dataType = Bits(8 bits), depth = config.uartRxFifoSize)
  val txFifo = new StreamFifo(dataType = Bits(8 bits), depth = config.uartTxFifoSize)
  val serParConv = new SerialParallelConverter(8,32)
  val timeout = Timeout(config.timeoutDelay)
  val builder = new ResponseBuilder()
  val tic = new TranslatorInterface() // acts as simplebus master


  //******** Peripherals *********
  val no_map = new NoMapPeriphral()

  //******** Memory mappings *********
}

object HWITLTopLevelVerilog extends App {
  Config.spinal.generateVerilog(new HWITLTopLevel(HWITLConfig()))
}
