package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.IMasterSlave
import spinal.lib.bus.misc._

class SimpleBusDecoder(busMaster : SimpleBus, decodings: Seq[(SimpleBus, (Bool, AddressMapping))]) extends Component {
  val io = new Bundle {
    val input = slave(SimpleBus(32, 32))
    val outputs = Vec(master(SimpleBus(32, 32)), decodings.size)
    val unmapped = new Bundle {
        val fired = out(Bool())
        val clear = in(Bool())
    }
  }
  val noDecode = new NoMapPeripheral()
  
  busMaster <> io.input
  println(decodings.zip(io.outputs).map(<>, busIF => (busIF._1._1, busIF._2)))
  println(decodings.foreach(busSlaves => busSlaves._1.SBReady))
  // io.outputs.map(outBus => outBus <> 
  // }
  // (decodings.map(_._1, io.outputs).zipped.map(_ <> _))

  val decodeLogic = new Area { 
    val slaveSel = UInt(log2Up(decodings.length+1) bits)
    val intconSBready = Bool
    val intconSBrdata = Bits(32 bits)
    


    slaveSel := 0
    when(io.input.SBvalid) {

    }
  }

//   busMaster.io.sb <> gpio_led.io.sb
//   busMaster.io.sb <> gpio_bank0.io.sb
//   busMaster.io.sb <> gpio_bank1.io.sb
//   busMaster.io.sb <> uart_peripheral.io.sb
//   busMaster.io.sb <> no_map.io.sb

//   busMaster.io.sb.SBrdata.removeAssignments()
//   busMaster.io.sb.SBready.removeAssignments()

//   // ******** Memory mappings *********
//   val addressMapping = new Area {
//     val intconSBready = Bool
//     val intconSBrdata = Bits(32 bits)
//     val addr = busMaster.io.sb.SBaddress
//     val datasel = UInt(4 bits) // 2^4 = 16 address-range-selectors, nice magic numbers
//     gpio_led.io.sel := False
//     gpio_bank0.io.sel := False
//     gpio_bank1.io.sel := False
//     uart_peripheral.io.sel := False
//     no_map.io.sel := False
//     datasel := 0

//     val hit = Vec(gpio_led.io.sel, gpio_bank0.io.sel, gpio_bank1.io.sel, uart_peripheral.io.sel).sContains(True)

//     when(busMaster.io.sb.SBvalid) {
//       when(isInRange(addr, U"h50000000", U"h5000000f")) {
//         gpio_led.io.sel := True
//         datasel := 2
//       }
//       when(isInRange(addr, U"h50001000", U"h5000100f")) {
//         gpio_bank0.io.sel := True
//         datasel := 3
//       }
//       when(isInRange(addr, U"h50002000", U"h5000200f")) {
//         gpio_bank1.io.sel := True
//         datasel := 4
//       }
//       when(isInRange(addr, U"h50003000", U"h5000300f")) {
//         uart_peripheral.io.sel := True
//         datasel := 5
//       }
//       when(!hit){
//         no_map.io.sel := True
//         datasel := 1
//       }
//     }

//     // mux bus slave signals for ready and data back towards cpu
//     intconSBready := datasel.mux(
//       1 -> no_map.io.sb.SBready,
//       2 -> gpio_led.io.sb.SBready,
//       3 -> gpio_bank0.io.sb.SBready,
//       4 -> gpio_bank1.io.sb.SBready,
//       5 -> uart_peripheral.io.sb.SBready,
//       default -> False
//     )
//     intconSBrdata := datasel.mux[Bits](
//       1 -> no_map.io.sb.SBrdata,
//       2 -> gpio_led.io.sb.SBrdata,
//       3 -> gpio_bank0.io.sb.SBrdata,
//       4 -> gpio_bank1.io.sb.SBrdata,
//       5 -> uart_peripheral.io.sb.SBrdata,
//       default -> 0
//     )
//   }
//   busMaster.io.sb.SBrdata := addressMapping.intconSBrdata
//   busMaster.io.sb.SBready := addressMapping.intconSBready
}


// used for unmapped decodings, generates 
class NoMapPeripheral extends Component {
  val io = new Bundle {
    val sb    = slave(SimpleBus(32, 32))
    val sel   = in(Bool())
    val fired = out(Bool())
    val clear = in(Bool())
  }
  // generates the ready signal next cycle if valid and select are available
  val busCtrl = new SimpleBusSlaveController()
  busCtrl.io.valid  := io.sb.SBvalid
  busCtrl.io.select := io.sel
  io.sb.SBready     := busCtrl.io.ready

  val firedFlag = Reg(Bool()) init (False)

  // register logic
  io.sb.SBrdata := 0 // default value
  // if this peripheral is talked to, set fired flag
  when(io.sb.SBvalid & io.sel) {
    firedFlag := True
  }
  // also make clear possible
  when(io.clear) {
    firedFlag := False
  }
  io.fired := firedFlag
}
