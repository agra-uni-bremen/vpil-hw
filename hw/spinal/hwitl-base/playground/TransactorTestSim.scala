package hwitlbase

import spinal.core._
import spinal.core.sim._

object TransactorTestSim extends App {
  Config.sim.compile(TransactorTest()).doSim { dut =>
    List(dut.io.valid, dut.io.write).foreach(_ #= false)
    List(dut.io.addr, dut.io.wdata).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.assertReset()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.deassertReset()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    
  }
}
