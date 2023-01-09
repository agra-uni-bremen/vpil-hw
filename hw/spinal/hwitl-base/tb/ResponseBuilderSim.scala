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

    // FSM for no payload
    dut.clockDomain.waitFallingEdge()
    dut.io.data.readData #= BigInt(0xCAFECAFEl)
    dut.io.data.ack #= BigInt(0x5Al)
    dut.io.ctrl.enable #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.enable #= false
    dut.clockDomain.waitFallingEdge()
    dut.clockDomain.waitFallingEdge()
    dut.clockDomain.waitFallingEdge()
    dut.io.txFifo.ready #= true
    dut.clockDomain.waitFallingEdge()
    dut.io.txFifo.ready #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()

    // RESET
    dut.clockDomain.assertReset()
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.deassertReset()
    dut.clockDomain.waitRisingEdge()

    // FSM for payload
    dut.clockDomain.waitFallingEdge()
    dut.io.data.readData #= BigInt(0xCAFEBABEl)
    dut.io.data.ack #= BigInt(0x5Al)
    dut.io.data.irq #= true
    dut.io.ctrl.respType #= ResponseType.payload
    dut.io.ctrl.enable #= true
    dut.clockDomain.waitFallingEdge()
    dut.io.ctrl.enable #= false
    dut.clockDomain.waitRisingEdge()

    for(i <- 0 to 4) {
      dut.clockDomain.waitFallingEdge()
      dut.io.txFifo.ready #= true
      dut.clockDomain.waitFallingEdge()
      dut.io.txFifo.ready #= false
      dut.clockDomain.waitRisingEdge()
    }
    dut.clockDomain.waitRisingEdge()

  }
}
