package hwitlbase

import spinal.core._
import spinal.core.sim._
import scala.math._

object ControllerTestRxSim extends App {
  Config.sim.compile(ControllerTestRx()).doSim { dut =>
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    def applyTestcase() = {

    }
    // val txdDecodeThread = fork {
    //     sleep(1)
    //     val mBaudrate = 115200
    //     val myBaudPeriod = floor(1e9 / mBaudrate).toInt
    //     printf("[UART] for baudrate: %d, baudperiod: %d\n", mBaudrate, myBaudPeriod)
    //     // Wait until the design sets the uartPin to true (wait for the reset effect).
    //     waitUntil(dut.io.uart.txd.toBoolean == true)
    //     while (true) {
    //     waitUntil(dut.io.uart.txd.toBoolean == false)
    //     sleep(myBaudPeriod / 2)
    //     assert(dut.io.uart.txd.toBoolean == false)
    //     sleep(myBaudPeriod)
    //     var buffer = 0
    //     for (bitId <- 0 to 7) {
    //         if (dut.io.uart.txd.toBoolean)
    //         buffer |= 1 << bitId
    //         sleep(myBaudPeriod)
    //     }
    //     assert(dut.io.uart.txd.toBoolean == true)
    //     printf("[TX] %02X\n",buffer)
    //     }
    // }
    // dut.io.uart.rxd #= true
    // List().foreach(_ #= false)
    // List().foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(82)
    dut.clockDomain.waitRisingEdge()
    
    doResetCycle

    simSuccess()
  }
}
