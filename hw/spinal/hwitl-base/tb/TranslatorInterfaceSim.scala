package hwitlbase

import spinal.core._
import spinal.core.sim._

object TranslatorInterfaceSim extends App {
  Config.sim.compile(TranslatorInterface()).doSim { dut =>
    List(dut.io.rxCtrl.fifoEmpty, dut.io.rxCtrl.fifo.valid, dut.io.resp.busy, dut.io.timeout, dut.io.bus.busy, dut.io.bus.unmapped).foreach(_ #= false)
    List(dut.io.rxCtrl.fifo.payload).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)

    dut.clockDomain.waitRisingEdge(4)
    dut.clockDomain.waitFallingEdge()
    dut.io.rxCtrl.fifo.valid #= true
    dut.io.rxCtrl.fifo.payload #= BigInt(0x01l)
    dut.clockDomain.waitFallingEdge()
    dut.io.rxCtrl.fifo.valid #= false
    dut.clockDomain.waitRisingEdge(4)

    for(i <- 0 to 3) {
      dut.clockDomain.waitFallingEdge()
      dut.io.rxCtrl.fifo.valid #= true
      dut.io.rxCtrl.fifo.payload #= BigInt(0xA5l + i)
      dut.clockDomain.waitFallingEdge()
      dut.io.rxCtrl.fifo.valid #= false
      dut.clockDomain.waitRisingEdge()
    }
    waitUntil(dut.io.bus.enable.toBoolean)
    dut.io.bus.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.bus.busy #= false
    dut.clockDomain.waitRisingEdge()

    waitUntil(dut.io.resp.enable.toBoolean)
    dut.io.resp.busy #= true
    dut.clockDomain.waitRisingEdge(4)
    dut.io.resp.busy #= false
    dut.clockDomain.waitRisingEdge()

    simSuccess()    
  }
}
