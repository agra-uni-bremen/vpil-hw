package hwitlbase

import spinal.core._
import spinal.core.sim._
import scala.math._

object ResponseTestSim extends App {
  Config.sim.compile(ResponseTest()).doSim { dut =>
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    def applyTestcase(irq : Boolean, ack : BigInt, readData : BigInt, withPayload : Boolean) = {
        dut.clockDomain.waitFallingEdge()
        dut.io.resp.data.ack #= ack
        dut.io.resp.data.irq #= irq
        dut.io.resp.data.readData #= readData
        if(!withPayload) {
            dut.io.resp.ctrl.respType #=  ResponseType.noPayload
        } else {
            dut.io.resp.ctrl.respType #=  ResponseType.payload
        }
        dut.io.resp.ctrl.enable #= true
        dut.clockDomain.waitFallingEdge()
        dut.io.resp.ctrl.enable #= false
        dut.clockDomain.waitFallingEdge()
        waitUntil(dut.io.resp.ctrl.busy.toBoolean == false)
        dut.clockDomain.waitRisingEdge(200)
    }
    val txdDecodeThread = fork {
        sleep(1)
        val mBaudrate = 115200
        val myBaudPeriod = floor(1e9 / mBaudrate).toInt
        printf("[UART] for baudrate: %d, baudperiod: %d\n", mBaudrate, myBaudPeriod)
        // Wait until the design sets the uartPin to true (wait for the reset effect).
        waitUntil(dut.io.uart.txd.toBoolean == true)
        while (true) {
        waitUntil(dut.io.uart.txd.toBoolean == false)
        sleep(myBaudPeriod / 2)
        assert(dut.io.uart.txd.toBoolean == false)
        sleep(myBaudPeriod)
        var buffer = 0
        for (bitId <- 0 to 7) {
            if (dut.io.uart.txd.toBoolean)
            buffer |= 1 << bitId
            sleep(myBaudPeriod)
        }
        assert(dut.io.uart.txd.toBoolean == true)
        printf("[TX] %02X\n",buffer)
        }
    }
    dut.io.uart.rxd #= true
    List(dut.io.resp.ctrl.clear, dut.io.resp.ctrl.enable, dut.io.resp.data.irq).foreach(_ #= false)
    dut.io.resp.ctrl.respType #= ResponseType.noPayload
    List(dut.io.resp.data.ack, dut.io.resp.data.readData).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(82)
    dut.clockDomain.waitRisingEdge()
    
    doResetCycle

    applyTestcase(false, BigInt(0x7Fl), BigInt(0), false)
    applyTestcase(true, BigInt(0x7Fl), BigInt(0), false)
    applyTestcase(false, BigInt(0x7Fl), BigInt(0x8BADF00Dl), true)
    /**
     * TODO: verify by pushing bytes collected through tx decoder thread into a threadsafe queue from scala/java
     * then after each testcase collect the queues content and compare the bytes with the input
     * with that generate millions of testcases to get some kind of confidence in the processing
     */
    simSuccess()
  }
}
