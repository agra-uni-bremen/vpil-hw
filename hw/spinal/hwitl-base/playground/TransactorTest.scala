package hwitlbase

import spinal.core._
import hwitlbase.UtilityFunctions._

case class TransactorTest() extends Component {
  val io = new Bundle {
    val addr = in(UInt(32 bits))
    val wdata = in(Bits(32 bits))
    val rdata = out(Bits(32 bits))
    val write = in(Bool())
    val ready = out(Bool())
    val valid = in(Bool())
    val nomapFired = out(Bool())
    val nomapClear = in(Bool())
  }

  val busCtrl = new SimpleBusMasterController()
  busCtrl.io.ctrl.enable := io.valid

  val gpio_led = new GPIOLED()
  gpio_led.io.sb.SBaddress := io.addr
  gpio_led.io.sb.SBvalid := busCtrl.io.bus.valid
  gpio_led.io.sb.SBwdata := io.wdata
  gpio_led.io.sb.SBsize := U(4)
  gpio_led.io.sb.SBwrite := io.write

  val no_map = new NoMapPeriphral()
  no_map.io.sb.SBaddress := io.addr
  no_map.io.sb.SBvalid := busCtrl.io.bus.valid
  no_map.io.sb.SBwdata := io.wdata
  no_map.io.sb.SBsize := U(4)
  no_map.io.sb.SBwrite := io.write
  io.nomapFired := no_map.io.fired
  no_map.io.clear := io.nomapClear

  val addressMapping = new Area {
    val intconSBready = Bool
    val intconSBrdata = Bits(32 bits)
    val addr = io.addr
    val oldAddr = RegNextWhen(io.addr, busCtrl.io.bus.valid)
    val lastValid = RegNext(busCtrl.io.bus.valid)
    val datasel = UInt(4 bits) // 2^4 = 16 address-range-selectors, nice magic numbers
    gpio_led.io.sel := False
    no_map.io.sel := False
    datasel := 0

    // when(isInRange(addr, U"h00001000", U"h0000100F") | isInRange(oldAddr, U"h00001000", U"h0000100F")){
    //     gpio_led.io.sel := True
    //     datasel := 2
    // }.otherwise{
    //     no_map.io.sel := True
    //     datasel := 1
    // }

    when(busCtrl.io.bus.valid) {
      when(isInRange(addr, U"h00001000", U"h0000100F")) {
        gpio_led.io.sel := True
        datasel := 2
      }.otherwise {
        no_map.io.sel := True
        datasel := 1
      }
    }

    // mux bus slave signals for ready and data back towards cpu
    intconSBready := datasel.mux(
      1 -> no_map.io.sb.SBready,
      2 -> gpio_led.io.sb.SBready,
      default -> False
    )
    intconSBrdata := datasel.mux[Bits](
      1 -> no_map.io.sb.SBrdata,
      2 -> gpio_led.io.sb.SBrdata,
      default -> 0
    )
  }
  io.rdata := addressMapping.intconSBrdata // RegNextWhen(addressMapping.intconSBrdata, intconSBready && )
  io.ready := addressMapping.intconSBready
  busCtrl.io.bus.ready := addressMapping.intconSBready
}
