package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.com.uart._

import hwitlbase.UtilityFunctions._

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
  val gpio_led = new GPIOLED() // onboard LEDs
  val gpio_bank0 = new SBGPIOBank() // IO switches
  val gpio_bank1 = new SBGPIOBank() // LEDs
  val uart_peripheral = new SBUart() // uart 9600 baud
  val no_map = new NoMapPeriphral()

  // ******** Master-Peripheral Bus Interconnect *********
  busMaster.io.ctrl.unmappedAccess := no_map.io.fired
  no_map.io.clear := tic.io.reg.clear

  io.leds := gpio_led.io.leds

  uart_peripheral.io.uart <> io.uart0

  busMaster.io.sb <> gpio_led.io.sb
  busMaster.io.sb <> gpio_bank0.io.sb
  busMaster.io.sb <> gpio_bank1.io.sb
  busMaster.io.sb <> uart_peripheral.io.sb
  busMaster.io.sb <> no_map.io.sb

  busMaster.io.sb.SBrdata.removeAssignments()
  busMaster.io.sb.SBready.removeAssignments()

  // ******** Memory mappings *********
  val addressMapping = new Area {
    val intconSBready = Bool
    val intconSBrdata = Bits(32 bits)
    val addr = busMaster.io.sb.SBaddress
    val oldAddr = RegNextWhen(busMaster.io.sb.SBaddress, busMaster.io.sb.SBvalid)
    val lastValid = RegNext(busMaster.io.sb.SBvalid)
    val datasel = UInt(4 bits) // 2^4 = 16 address-range-selectors, nice magic numbers
    gpio_led.io.sel := False
    gpio_bank0.io.sel := False
    gpio_bank1.io.sel := False
    uart_peripheral.io.sel := False
    no_map.io.sel := False
    datasel := 0

    val hit = Vec(gpio_led.io.sel, gpio_bank0.io.sel, gpio_bank1.io.sel, uart_peripheral.io.sel).sContains(True)

    when(busMaster.io.sb.SBvalid) {
      when(isInRange(addr, U"h50000000", U"h5000000f")) {
        gpio_led.io.sel := True
        datasel := 2
      }
      when(isInRange(addr, U"h50001000", U"h5000100f")) {
        gpio_bank0.io.sel := True
        datasel := 3
      }
      when(isInRange(addr, U"h50002000", U"h5000200f")) {
        gpio_bank0.io.sel := True
        datasel := 3
      }
      when(isInRange(addr, U"h50003000", U"h5000300f")) {
        gpio_bank1.io.sel := True
        datasel := 4
      }
      when(isInRange(addr, U"h50004000", U"h500040ff")) {
        uart_peripheral.io.sel := True
        datasel := 5
      }
      when(!hit){
        no_map.io.sel := True
        datasel := 1
      }
    }

    // mux bus slave signals for ready and data back towards cpu
    intconSBready := datasel.mux(
      1 -> no_map.io.sb.SBready,
      2 -> gpio_led.io.sb.SBready,
      3 -> gpio_bank0.io.sb.SBready,
      4 -> gpio_bank1.io.sb.SBready,
      5 -> uart_peripheral.io.sb.SBready,
      default -> False
    )
    intconSBrdata := datasel.mux[Bits](
      1 -> no_map.io.sb.SBrdata,
      2 -> gpio_led.io.sb.SBrdata,
      3 -> gpio_bank0.io.sb.SBrdata,
      4 -> gpio_bank1.io.sb.SBrdata,
      5 -> uart_peripheral.io.sb.SBrdata,
      default -> 0
    )
  }
  busMaster.io.sb.SBrdata := addressMapping.intconSBrdata
  busMaster.io.sb.SBready := addressMapping.intconSBready

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
