package hwitlbase

import spinal.core._
import spinal.core.sim._

object ResponseBuilderSim extends App {
  Config.sim.compile(ResponseBuilder()).doSim { dut =>
    List(dut.io.ctrl.enable, dut.io.ctrl.clear, dut.io.data.irq, dut.io.txFifo.ready).foreach(_ #= false)
    List(dut.io.data.readData, dut.io.data.ack).foreach(_ #= 0)
    dut.io.ctrl.respType #= ResponseType.noPayload

    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
  }
}
