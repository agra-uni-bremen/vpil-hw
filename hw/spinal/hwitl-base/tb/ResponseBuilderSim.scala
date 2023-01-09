package hwitlbase

import spinal.core._
import spinal.core.sim._

object ResponseBuilderSim extends App {
  Config.sim.compile(ResponseBuilder()).doSim { dut =>
    List().foreach(_ #= false)
    List().foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.io.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.enable #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
  }
}
