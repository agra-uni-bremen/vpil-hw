package hwitlbase

import spinal.core._
import spinal.core.sim._
import scala.math._

object HWITLTopLevelSim extends App {
  Config.sim.compile(HWITLTopLevel(HWITLConfig(),simulation=true)).doSim { dut =>
    def encodeUart(byteToSend: Long, uartPin: Bool, baudRate: Long) = {
      val baudPeriod = floor(993.6e9 / baudRate).toInt
      // start bit
      uartPin #= false
      sleep(baudPeriod)
      // data bits
      // send lsb first if (0 to 7)
      for (bitIdx <- 0 to 7) {
        // shift current bit to LSB, mask off, convert to boolean through comparison
        uartPin #= ((byteToSend >> bitIdx) & 1) != 0
        sleep(baudPeriod)
      }
      // stop bit
      uartPin #= true
      sleep(baudPeriod)
    }
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    def applyTestcase(cmdByte: BigInt, addrBytes: BigInt, wdataBytes: BigInt) = {
      val baudRate = 115200L
      val rxdPin = dut.io.uartCMD.rxd
      printf("[Testcase] cmd: %02X\taddr: %08X\twdata: %08X\n", cmdByte, addrBytes, wdataBytes)
      val cmdArray: Array[Byte] = SimBigIntPimper(cmdByte).toBytes(8)
      val addrArray: Array[Byte] = SimBigIntPimper(addrBytes).toBytes(32, endian = BIG)
      val wdataArray: Array[Byte] = SimBigIntPimper(wdataBytes).toBytes(32, endian = BIG)
      print("[Testcase] addr(toBytes):")
      addrArray.foreach(printf(" %02X\t", _))
      print("wdata(toBytes):")
      wdataArray.foreach(printf(" %02X\t", _))
      print("\n")
      cmdArray(0) match {
        case 0x00 => {
          println("[CMD] CLEAR")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[RX] send command %02x\n", cmdArray(0))
        }
        case 0x01 => {
          println("[CMD] READ")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[RX] send command %02x\n", cmdArray(0))
          for (idx <- 0 to 3) {
            printf("[RX] addr(%d) send %02x\n", idx, addrArray(idx))
            encodeUart(addrArray(idx), rxdPin, baudRate)
          }
        }
        case 0x02 => {
          println("[CMD] WRITE")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[RX] send command %02x\n", cmdArray(0))
          for (idx <- 0 to 3) {
            printf("[RX] addr(%d) send %02x\n", idx, addrArray(idx))
            encodeUart(addrArray(idx), rxdPin, baudRate)
          }
          for (idx <- 0 to 3) {
            printf("[RX] wdata(%d) send %02x\n", idx, wdataArray(idx))
            encodeUart(wdataArray(idx), rxdPin, baudRate)
          }
        }
        case _ => {
          println("[CMD] UNDEFINED")
        }
      }
    }
    val txdDecodeThread = fork {
      sleep(1)
      val mBaudrate = 115200
      val myBaudPeriod = floor(993.6e9 / mBaudrate).toInt
      printf("[UART] for baudrate: %d, baudperiod: %d\n", mBaudrate, myBaudPeriod)
      // Wait until the design sets the uartPin to true (wait for the reset effect).
      waitUntil(dut.io.uartCMD.txd.toBoolean == true)
      while (true) {
        waitUntil(dut.io.uartCMD.txd.toBoolean == false)
        sleep(myBaudPeriod / 2)
        assert(dut.io.uartCMD.txd.toBoolean == false)
        sleep(myBaudPeriod)
        var buffer = 0
        for (bitId <- 0 to 7) {
          if (dut.io.uartCMD.txd.toBoolean)
            buffer |= 1 << bitId
          sleep(myBaudPeriod)
        }
        assert(dut.io.uartCMD.txd.toBoolean == true)
        printf("[TX] %02X\n", buffer)
      }
    }

    // default 1
    List(dut.io.uartCMD.rxd).foreach(_ #= true)

    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 83.3333 ns)

    doResetCycle()

    println("***** TEST ***** clear")
    applyTestcase(0x00l, 0x0l, 0x0l) // clear
    
    println("***** TEST ***** read LED register")
    applyTestcase(0x01l, 0x50000000l, 0x00000000l) // read 0x50000000 (GPIO LED register)
    dut.clockDomain.waitRisingEdge(6500)
    
    println("***** TEST ***** write LED register")
    applyTestcase(0x02l, 0x50000000l, 0x8BADF00Dl) // write at 0x50000000 with 0x8BADF00D (GPIO LED register)
    dut.clockDomain.waitRisingEdge(6500)
    
    println("***** TEST ***** read LED register from previously")
    applyTestcase(0x01l, 0x50000000l, 0x00000000l) // read 0x50000000 (GPIO LED register)
    dut.clockDomain.waitRisingEdge(6500)
    
    println("***** TEST ***** read GPIO direction register")
    applyTestcase(0x01l, 0x50001000l, 0x00000000l) // read 0x50001000 (GPIO bank 1 direction register)
    dut.clockDomain.waitRisingEdge(6500)

    println("***** TEST ***** read GPIO2 direction register")
    applyTestcase(0x01l, 0x50002000l, 0x00000000l) // read 0x50002000 (GPIO bank 2 direction register)
    dut.clockDomain.waitRisingEdge(6500)

    println("***** TEST ***** unmapped read")
    applyTestcase(0x01l, 0x00006000l, 0x00000000l) // read 0x6000 (unmapped read)
    dut.clockDomain.waitRisingEdge(6500)
    
    println("***** TEST ***** unmapped write")
    applyTestcase(0x02l, 0x00006000l, 0x00000000l) // write 0x6000 (unmapped write)
    dut.clockDomain.waitRisingEdge(6500)

    println("***** CUSTOM TEST (can fail or be wrong, dependent on HW configuration) *****")
    applyTestcase(0x02l, 0x50004000l, 24l)
    dut.clockDomain.waitRisingEdge(6500)
    applyTestcase(0x02l, 0x50004004l, 777l)
    dut.clockDomain.waitRisingEdge(6500)
    applyTestcase(0x02l, 0x50004010l, 0x00000001l)
    dut.clockDomain.waitRisingEdge(6500)
    applyTestcase(0x01l, 0x5000400cl, 0x00000000l)
    dut.clockDomain.waitRisingEdge(6500)
    applyTestcase(0x01l, 0x50004008l, 0x00000000l)
    dut.clockDomain.waitRisingEdge(6500)
    
    simSuccess()
  }
}
