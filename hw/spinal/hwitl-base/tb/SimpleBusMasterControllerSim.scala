package hwitlbase

import spinal.core._
import spinal.core.sim._

object SimpleBusMasterControllerSim extends App {
  Config.sim.compile(SimpleBusMasterController()).doSim { dut =>
    List(dut.io.ctrl.enable, dut.io.bus.ready).foreach(_ #= false)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.io.bus.ready #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.bus.ready #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
  }
}
