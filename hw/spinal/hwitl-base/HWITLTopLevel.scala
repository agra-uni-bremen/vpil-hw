package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.bus.misc._
import spinal.lib.com.uart._

import hwitlbase.UtilityFunctions._
import scala.collection.mutable.ArrayBuffer

/** Default configuration parameters for the HWitL system
  */
case class HWITLConfig(
    uartBaudRate: Long = 115200,
    uartTxFifoSize: Int = 16,
    uartRxFifoSize: Int = 16,
    timeoutDelay: TimeNumber = 2 ms
) {}

// Hardware definition
case class HWITLTopLevel(config: HWITLConfig, simulation: Boolean = false) extends Component {
  val io = new Bundle {
    val uartCMD = master(new Uart())
    val leds = out(Bits(8 bits))
    val gpio0 = inout(Analog(Vec.fill(8)(Bool)))
    val gpio1 = inout(Analog(Vec.fill(8)(Bool)))
    val uart0 = master(new Uart())
  }

  // ******** HW in the Loop elements *********
  val uartCtrl = new UartCtrl()
  val rxFifo = new StreamFifo(dataType = Bits(8 bits), depth = config.uartRxFifoSize)
  val txFifo = new StreamFifo(dataType = Bits(8 bits), depth = config.uartTxFifoSize)
  val serParConv = new SerialParallelConverter(8, 32)
  val timeout = Timeout(config.timeoutDelay)
  val builder = new ResponseBuilder()
  val tic = new TranslatorInterfaceController()
  val busMaster = new HWITLBusMaster()

  // ******** wiring and configuring blocks *********
  uartCtrl.io.config.setClockDivider(config.uartBaudRate Hz)
  uartCtrl.io.config.frame.dataLength := 7 // 8 bits
  uartCtrl.io.config.frame.parity := UartParityType.NONE
  uartCtrl.io.config.frame.stop := UartStopType.ONE
  uartCtrl.io.writeBreak := False
  uartCtrl.io.uart <> io.uartCMD

  // uart receives into rx fifo
  rxFifo.io.push << uartCtrl.io.read
  // uart transmits from tx fifo
  uartCtrl.io.write << txFifo.io.pop
  // rx fifo is consumed through TIC, but payload goes to busMaster and serial parallel converter
  rxFifo.io.pop >> tic.io.rx.fifo
  // response builder produces bytes for tx fifo
  txFifo.io.push << builder.io.txFifo

  // connect bus master with response builder passing data
  // and TIC control lines to response builder
  builder.io.data.irq := busMaster.io.response.irq
  builder.io.data.ack := busMaster.io.response.ack
  builder.io.data.readData := busMaster.io.response.payload
  builder.io.ctrl <> tic.io.resp
  builder.io.txFifoEmpty := (txFifo.io.occupancy === 0)

  // TIC to busmaster
  busMaster.io.reg.enable.address := tic.io.reg.enable.address
  busMaster.io.reg.enable.writeData := tic.io.reg.enable.writeData
  busMaster.io.reg.enable.command := tic.io.reg.enable.command
  busMaster.io.reg.enable.readData := tic.io.reg.enable.readData
  busMaster.io.reg.clear := tic.io.reg.clear
  busMaster.io.reg.command := rxFifo.io.pop.payload
  busMaster.io.reg.data := serParConv.io.outData
  busMaster.io.ctrl.enable := tic.io.bus.enable
  tic.io.bus.busy := busMaster.io.ctrl.busy
  busMaster.io.ctrl.write := tic.io.bus.write

  // serial parallel conversion
  serParConv.io.shiftEnable := tic.io.shiftReg.enable
  serParConv.io.clear := tic.io.shiftReg.clear
  serParConv.io.inData := rxFifo.io.pop.payload
  serParConv.io.outputEnable := True // always show data, as we have register enables

  // TIC and timeout
  tic.io.timeout.pending := timeout
  when(tic.io.timeout.clear) {
    timeout.clear()
  }

  // ******** Peripherals *********
  val busMappings = new ArrayBuffer[(SimpleBus,(Bool, MaskMapping))]

  val gpio_led = new GPIOLED() // onboard LEDs
  busMappings += gpio_led.io.sb -> (gpio_led.io.sel, MaskMapping(0x50000000l,0xFFFFFFF0l))
  io.leds := gpio_led.io.leds

  val gpio_bank0 = new SBGPIOBank() // GPIO for IO switches
  busMappings += gpio_bank0.io.sb -> (gpio_bank0.io.sel, MaskMapping(0x50001000l,0xFFFFFFF0l))
  
  val gpio_bank1 = new SBGPIOBank() // GPIO for LEDs, etc.
  busMappings += gpio_bank1.io.sb -> (gpio_bank1.io.sel, MaskMapping(0x50002000l,0xFFFFFFF0l))
  
  val uart_peripheral = new SBUart() // uart 9600 baud
  busMappings += uart_peripheral.io.sb -> (uart_peripheral.io.sel, MaskMapping(0x50003000l,0xFFFFFFF0l))
  uart_peripheral.io.uart <> io.uart0

  // val gcd_periph = new SBGCDCtrl()
  // busMappings += gcd_periph.io.sb -> (gcd_periph.io.sel, MaskMapping(0x50004000l, 0xFFFFFF00l))

  // ******** Master-Peripheral Bus Interconnect *********
  val busDecoder = SimpleBusDecoder(
      master = busMaster.io.sb,
      decodings = busMappings.toSeq
  )
  busDecoder.io.unmapped.clear := tic.io.reg.clear
  busMaster.io.ctrl.unmappedAccess := busDecoder.io.unmapped.fired
  tic.io.bus.unmapped := busDecoder.io.unmapped.fired

  // create IO bank ice40 SBIO interconnect + simulation stubs if needed
  if(!simulation) {
    createSBIOConnection(gpio_bank0.io.gpio, io.gpio0)
    createSBIOConnection(gpio_bank1.io.gpio, io.gpio1)
  } else {
    createSBIOConnectionStubs(gpio_bank0.io.gpio, io.gpio0)
    createSBIOConnectionStubs(gpio_bank1.io.gpio, io.gpio1)
  }
}

object HWITLTopLevelVerilog extends App {
  Config.spinal.generateVerilog(new HWITLTopLevel(HWITLConfig())).printPruned
}
