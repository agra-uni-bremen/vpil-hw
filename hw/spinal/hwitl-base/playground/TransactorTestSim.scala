package hwitlbase

import spinal.core._
import spinal.core.sim._

object TransactorTestSim extends App {
  Config.sim.compile(TransactorTest()).doSim { dut =>
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    def startRead(addr : Long) = {
      dut.io.addr #= addr
      dut.io.valid #= true
      dut.io.wdata #= 0
      dut.io.write #= false
      dut.clockDomain.waitRisingEdge()
    }
    def doRead(addr : Long) : BigInt = {
      startRead(addr)
      dut.io.valid #= false
      dut.clockDomain.waitRisingEdge()
      waitUntil(dut.io.ready.toBoolean)
      val rd = dut.io.rdata.toBigInt
      rd
    }
    def startWrite(addr : Long, value : Long) = {
      dut.io.write #= true
      dut.io.valid #= true
      dut.io.addr #= addr
      dut.io.wdata #= value
      dut.clockDomain.waitRisingEdge()
    }

    List(dut.io.valid, dut.io.write, dut.io.nomapClear).foreach(_ #= false)
    List(dut.io.addr, dut.io.wdata).foreach(_ #= 0)
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 10)
    dut.clockDomain.waitRisingEdge()
    
    // test asynchronous reset
    dut.clockDomain.waitRisingEdge()
    dut.io.valid #= true
    dut.clockDomain.waitRisingEdge()
    dut.io.valid #= false
    dut.clockDomain.waitRisingEdge()
    dut.clockDomain.waitFallingEdge()
    doResetCycle
    dut.clockDomain.waitRisingEdge()

    // talk to the gpio led peripheral
    dut.clockDomain.waitRisingEdge()
    val wrVal = 0x8BADF00Dl
    
    startWrite(0x00001000l, wrVal)
    dut.io.valid #= false
    dut.clockDomain.waitRisingEdge()
    waitUntil(dut.io.ready.toBoolean)
    dut.clockDomain.waitRisingEdge()

    List(dut.io.valid, dut.io.write, dut.io.nomapClear).foreach(_ #= false)
    List(dut.io.addr, dut.io.wdata).foreach(_ #= 0)
    dut.clockDomain.waitRisingEdge()
    
    // startRead(0x00001000l)
    // dut.io.valid #= false
    // dut.clockDomain.waitRisingEdge()
    // waitUntil(dut.io.ready.toBoolean)
    // val rd = dut.io.rdata.toBigInt
    var rd = doRead(0x00001000l)
    dut.clockDomain.waitRisingEdge(2)

    assert(rd == wrVal, "Written data was not retrieved: rd(" + rd + ") wrVal(" + wrVal + ")\n")

    rd = doRead(0x00000000l) // unmapped, should return 0 and fire the no_map peripheral
    dut.clockDomain.waitRisingEdge(2)
    assert(rd == 0, "Reading from no_map should return 0 always.\n")
    assert(dut.io.nomapFired.toBoolean, "Interaction with no_map should fire signal\n")
    dut.clockDomain.waitFallingEdge()
    dut.io.nomapClear #= true
    dut.clockDomain.waitFallingEdge()
    dut.io.nomapClear #= false
    assert(!dut.io.nomapFired.toBoolean, "Clearing should deassert the fire signal\n")
    dut.clockDomain.waitRisingEdge(2)

    simSuccess()
  }
}
