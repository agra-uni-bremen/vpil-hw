package hwitlbase

import spinal.core._
import spinal.core.sim._

object SimpleBusSlaveControllerSim extends App {
  Config.sim.compile(SimpleBusSlaveController()).doSim { dut =>
    List(dut.io.valid, dut.io.select).foreach(_ #= false)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.io.select #= true
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitFallingEdge()
    dut.io.valid #= true
    dut.clockDomain.waitFallingEdge()
    dut.io.valid #= false
    dut.clockDomain.waitRisingEdge(2)
    dut.clockDomain.waitFallingEdge()
    dut.io.valid #= true
    dut.clockDomain.waitRisingEdge(2)
    // todo: assertions
    dut.clockDomain.waitRisingEdge(4)
    simSuccess()
  }
}
