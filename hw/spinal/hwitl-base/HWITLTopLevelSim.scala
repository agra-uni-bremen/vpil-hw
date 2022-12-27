package hwitlbase

import spinal.core._
import spinal.core.sim._

object HWITLTopLevelSim extends App {
  Config.sim.compile(HWITLTopLevel()).doSim { dut =>
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)

    for (idx <- 0 to 99) {
      // Wait a rising edge on the clock
      dut.clockDomain.waitRisingEdge()

    }
  }
}
