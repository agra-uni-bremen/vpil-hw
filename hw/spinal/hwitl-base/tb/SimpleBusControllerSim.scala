package hwitlbase

import spinal.core._
import spinal.core.sim._

object SimpleBusControllerSim extends App {
  Config.sim.compile(SimpleBusController()).doSim { dut =>
    List(dut.io.enable, dut.io.sbReady).foreach(_ #= false)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.io.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.enable #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.io.sbReady #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.sbReady #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.io.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
  }
}
