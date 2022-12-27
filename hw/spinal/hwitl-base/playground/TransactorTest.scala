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
    }

    val busCtrl = new SimpleBusController()
    busCtrl.io.enable := io.valid

    val gpio_led = new GPIOLED()
    gpio_led.io.sb.SBaddress := io.addr
    gpio_led.io.sb.SBvalid := busCtrl.io.sbValid
    gpio_led.io.sb.SBwdata := io.wdata
    gpio_led.io.sb.SBsize := U(4)
    gpio_led.io.sb.SBwrite := io.write

    val addressMapping = new Area{
        val intconSBready = Bool
        val intconSBrdata = Bits(32 bits)
        val addr = io.addr
        val oldAddr = RegNextWhen(io.addr,busCtrl.io.sbValid)
        val lastValid = RegNext(busCtrl.io.sbValid)
        val datasel = UInt(4 bits) // 2^4 = 16 address-range-selectors, nice magic numbers
        gpio_led.io.sel := False
        datasel := 0
        // LED
        when(isInRange(addr, U"h00001000", U"h0000010F") | isInRange(oldAddr, U"h00001000", U"h0000010F")){
            gpio_led.io.sel := True
            datasel := 1
        }
        // mux bus slave signals for ready and data back towards cpu
        intconSBready := datasel.mux(
        0 -> False,
        1 -> gpio_led.io.sb.SBready,
        default -> False
        )
        intconSBrdata := datasel.mux[Bits](
        0 -> 0,
        1 -> gpio_led.io.sb.SBrdata,
        default -> 0
        )
    }
    io.rdata := addressMapping.intconSBrdata
    io.ready := addressMapping.intconSBready
    busCtrl.io.sbReady := addressMapping.intconSBready
}