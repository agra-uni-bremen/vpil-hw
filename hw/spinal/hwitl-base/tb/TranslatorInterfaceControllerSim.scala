package hwitlbase

import spinal.core._
import spinal.core.sim._

object TranslatorInterfaceControllerSim extends App {
  Config.sim.compile(TranslatorInterfaceController()).doSim { dut =>
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    List(dut.io.rx.fifoEmpty, dut.io.rx.fifo.valid, dut.io.resp.busy, dut.io.timeout.pending, dut.io.bus.busy, dut.io.bus.unmapped)
      .foreach(_ #= false)
    List(dut.io.rx.fifo.payload).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)

    // Test 0 command into address transition
    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    // dut.io.rx.fifo.valid #= true
    dut.io.rx.fifo.payload #= BigInt(0x01L)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)

    doResetCycle

    // Test 1 read command + react with busy signals
    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= true
    dut.io.rx.fifo.payload #= BigInt(0x01L)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)

    for (i <- 0 to 3) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= true
      dut.io.rx.fifo.payload #= BigInt(0xa5L + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
      if (i == 3) {
        waitUntil(dut.io.reg.enable.address.toBoolean)
      }
    }
    waitUntil(dut.io.bus.enable.toBoolean)
    dut.clockDomain.waitRisingEdge()
    dut.io.bus.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.bus.busy #= false
    dut.clockDomain.waitRisingEdge()

    waitUntil(dut.io.resp.enable.toBoolean)
    dut.clockDomain.waitRisingEdge()
    dut.io.resp.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.resp.busy #= false
    dut.clockDomain.waitRisingEdge(4)

    // Test 2 - write command + busy signals
    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= true
    dut.io.rx.fifo.payload #= BigInt(0x02L)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)
    // address
    for (i <- 0 to 3) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= true
      dut.io.rx.fifo.payload #= BigInt(0xa5L + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
      if (i == 3) {
        waitUntil(dut.io.reg.enable.address.toBoolean)
        dut.clockDomain.waitRisingEdge()
      }
    }

    dut.clockDomain.waitRisingEdge()

    // write data
    for (i <- 0 to 3) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= true
      dut.io.rx.fifo.payload #= BigInt(0xbaL + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
      if (i == 3) {
        waitUntil(dut.io.reg.enable.writeData.toBoolean)
        dut.clockDomain.waitRisingEdge()
      }
    }

    waitUntil(dut.io.bus.enable.toBoolean)
    dut.clockDomain.waitRisingEdge()
    dut.io.bus.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.bus.busy #= false
    dut.clockDomain.waitRisingEdge()

    waitUntil(dut.io.resp.enable.toBoolean)
    dut.clockDomain.waitRisingEdge()
    dut.io.resp.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.resp.busy #= false
    dut.clockDomain.waitRisingEdge(4)

    // Test 3 - clear command
    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= true
    dut.io.rx.fifo.payload #= BigInt(0x00L)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)

    // Test 4 - write command + busy signals but cause timeout event
    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= true
    dut.io.rx.fifo.payload #= BigInt(0x02L)
    dut.clockDomain.waitFallingEdge()
    dut.io.rx.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)
    // address
    for (i <- 0 to 3) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= true
      dut.io.rx.fifo.payload #= BigInt(0xa5L + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
      if (i == 3) {
        waitUntil(dut.io.reg.enable.address.toBoolean)
        dut.clockDomain.waitRisingEdge()
      }
    }

    dut.clockDomain.waitRisingEdge()

    // write data
    for (i <- 0 to 2) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= true
      dut.io.rx.fifo.payload #= BigInt(0xbaL + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rx.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
    }
    dut.clockDomain.waitRisingEdge(6)
    dut.io.timeout.pending #= true
    dut.clockDomain.waitRisingEdge(2)
    dut.io.timeout.pending #= false

    dut.clockDomain.waitRisingEdge(4)
    simSuccess()
  }
}
