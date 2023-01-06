package hwitlbase

import spinal.core._
import spinal.core.sim._
import scala.util.Random

object SerialParallelConverterSim extends App {
  // NOTE: currently only tested with powers of two
  var inSize = 8
  var outSize = 64

  var N_TESTS = 100
  var aliveN = N_TESTS/10
  
  Config.sim.compile(new SerialParallelConverter(inSize,outSize)).doSim { dut =>
    List(dut.io.shiftEnable, dut.io.outputEnable, dut.io.clear).foreach(_ #= false)
    List(dut.io.inData, dut.io.outData).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitRisingEdge()
    // Test reset
    dut.clockDomain.waitFallingEdge()
    dut.io.inData #= 0xFFl
    dut.io.shiftEnable #= true
    dut.io.outputEnable #= true
    dut.clockDomain.waitFallingEdge(4)
    assert(dut.io.outData.toBigInt == 0xFFFFFFFFl, message = "Reset Test: Expected 0xffffffff on output")
    dut.clockDomain.assertReset()
    dut.clockDomain.waitRisingEdge()
    assert(dut.io.outData.toBigInt == 0, message = "Reset Test: Expected 0 on output")
    dut.clockDomain.deassertReset()
    dut.clockDomain.waitFallingEdge()

    List(dut.io.shiftEnable, dut.io.outputEnable, dut.io.clear).foreach(_ #= false)
    List(dut.io.inData, dut.io.outData).foreach(_ #= 0)
    dut.clockDomain.waitFallingEdge()

    // Test clear
    dut.io.inData #= 0xFFl
    dut.io.shiftEnable #= true
    dut.io.outputEnable #= true
    dut.clockDomain.waitFallingEdge(4)
    assert(dut.io.outData.toBigInt == 0xFFFFFFFFl, message = "Clear Test: Expected 0xffffffff on output")
    dut.io.shiftEnable #= false
    dut.io.clear #= true
    dut.clockDomain.waitFallingEdge()
    assert(dut.io.outData.toBigInt == 0, message = "Clear Test: Expected 0 on output")
    
    List(dut.io.shiftEnable, dut.io.outputEnable, dut.io.clear).foreach(_ #= false)
    List(dut.io.inData, dut.io.outData).foreach(_ #= 0)
    dut.clockDomain.waitFallingEdge()
    var inputDataBytes = new Array[Byte](outSize/inSize)
    var expectedResult : BigInt = 0
    for(testidx <- 0 until N_TESTS) {

      if(testidx%aliveN == 0) printf("ALIVE: Test %d of %d (%f %%)\n", testidx, N_TESTS, (testidx.toFloat/N_TESTS.toFloat)*100.0 )


      Random.nextBytes(inputDataBytes)
      expectedResult = (BigInt(inputDataBytes) & (BigInt(1) << outSize)-1)
      dut.io.shiftEnable #= true
      dut.io.outputEnable #= true
      inputDataBytes foreach { el =>
        dut.io.inData #= el & 0xff
        dut.clockDomain.waitFallingEdge()
      }
      dut.io.shiftEnable #= false
      dut.io.outputEnable #= true
      assert(
        assertion = (dut.io.outData.toBigInt == expectedResult),
        message = "Random Inputs Test: Output was " + dut.io.outData.toBigInt + " but expected " + expectedResult
      )
      dut.clockDomain.waitFallingEdge()
    }


    printf("Ending N=%d random test cases per test @SimTime= %d\n", N_TESTS, simTime())
    simSuccess()
  }
}
