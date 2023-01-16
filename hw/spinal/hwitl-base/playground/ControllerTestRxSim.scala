package hwitlbase

import spinal.core._
import spinal.core.sim._
import scala.math._

object ControllerTestRxSim extends App {
  Config.sim.compile(ControllerTestRx()).doSim { dut =>
    def encodeUart(byteToSend : Long, uartPin : Bool, baudRate : Long) = {
      val baudPeriod = floor(1e9 / baudRate).toInt
      // start bit
      uartPin #= false
      sleep(baudPeriod)
      // data bits
      // send lsb first if (0 to 7)
      for(bitIdx <- 0 to 7) {
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
    def applyTestcase(cmdByte : BigInt, addrBytes : BigInt, wdataBytes : BigInt) = {
      val baudRate = 115200l
      val rxdPin = dut.io.uart.rxd
      val cmdArray : Array[Byte] = SimBigIntPimper(cmdByte).toBytes(8)
      val addrArray : Array[Byte] = SimBigIntPimper(addrBytes).toBytes(32)
      val wdataArray : Array[Byte] = SimBigIntPimper(wdataBytes).toBytes(32)

      cmdArray(0) match {
        case 0x00 => {
          println("CLEAR")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[rxd] send command %#02x\n", cmdArray(0))
        }
        case 0x01 => {
          println("READ")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[rxd] send command %#02x\n", cmdArray(0))
          for(idx <- 0 to 3) {
            printf("[rxd] addr(%d) send %#02x\n", idx, addrArray(idx))
            encodeUart(addrArray(idx), rxdPin, baudRate)
          }
        }
        case 0x02 => {
          println("WRITE")
          encodeUart(cmdArray(0), rxdPin, baudRate)
          printf("[rxd] send command %#02x\n", cmdArray(0))
          for(idx <- 0 to 3) {
            printf("[rxd] addr(%d) send %#02x\n", idx, addrArray(idx))
            encodeUart(addrArray(idx), rxdPin, baudRate)
          }
          for(idx <- 0 to 3) {
            printf("[rxd] wdata(%d) send %#02x\n", idx, addrArray(idx))
            encodeUart(wdataArray(idx), rxdPin, baudRate)
          }
        }
        case _ => {
          println("UNDEFINED")
        }
      }
    }
    // default 1
    List(dut.io.uart.rxd).foreach(_ #= true)
    // default 0
    List(dut.io.resp.busy, dut.io.bus.busy, dut.io.timeout.pending).foreach(_ #= false)
    // List().foreach(_ #= false)
    // List().foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(82)
    dut.clockDomain.waitRisingEdge()
    
    doResetCycle

    encodeUart(0x00l, dut.io.uart.rxd, 112500)

    applyTestcase(0x01l, BigInt(0xaabbccddl), 0x00l)
    waitUntil(dut.io.bus.enable.toBoolean)
    dut.io.bus.busy #= true
    dut.clockDomain.waitRisingEdge(2)
    dut.io.bus.busy #= false
    dut.clockDomain.waitRisingEdge(2)
    waitUntil(dut.io.resp.enable.toBoolean)
    dut.io.resp.busy #= true
    dut.clockDomain.waitRisingEdge(2)
    dut.io.resp.busy #= false
    dut.clockDomain.waitRisingEdge(2)

    applyTestcase(0x02l, BigInt(0xaabbccddl), 0x00l)
    waitUntil(dut.io.bus.enable.toBoolean)
    dut.io.bus.busy #= true
    dut.clockDomain.waitRisingEdge(2)
    dut.io.bus.busy #= false
    dut.clockDomain.waitRisingEdge(2)
    waitUntil(dut.io.resp.enable.toBoolean)
    dut.io.resp.busy #= true
    dut.clockDomain.waitRisingEdge(2)
    dut.io.resp.busy #= false
    dut.clockDomain.waitRisingEdge(2)
    
    applyTestcase(0x00l, BigInt(0xaabbccddl), 0x00l)

    simSuccess()
  }
}
