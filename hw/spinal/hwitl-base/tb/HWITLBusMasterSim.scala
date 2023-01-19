package hwitlbase

import spinal.core._
import spinal.core.sim._

object HWITLBusMasterSim extends App {
  Config.sim.compile(HWITLBusMaster()).doSim { dut =>
    def doResetCycle() = {
      dut.clockDomain.assertReset()
      dut.clockDomain.waitRisingEdge()
      dut.clockDomain.deassertReset()
      dut.clockDomain.waitRisingEdge()
    }
    def clearRegs() = {
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.clear #= true
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.clear #= false
      dut.clockDomain.waitRisingEdge()
    }
    def setAddress(address : BigInt) = {
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.address #= true
      dut.io.reg.data #= address
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.address #= false
      dut.io.reg.data #= 0
      dut.clockDomain.waitRisingEdge()
    }
    def setWriteData(writeData : BigInt) = {
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.writeData #= true
      dut.io.reg.data #= writeData
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.writeData #= false
      dut.io.reg.data #= 0
      dut.clockDomain.waitRisingEdge()
    }
    def setCommand(command : BigInt) = {
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.command #= true
      dut.io.reg.command #= command
      dut.clockDomain.waitFallingEdge()
      dut.io.reg.enable.command #= false
      dut.io.reg.command #= 0
      dut.clockDomain.waitRisingEdge()
    }
    def sendTransaction() = {
      dut.clockDomain.waitFallingEdge()
      dut.io.ctrl.enable #= true
      dut.clockDomain.waitFallingEdge()
      dut.io.ctrl.enable #= false
      dut.clockDomain.waitRisingEdge()
    }
    def responseBusRead(readData : BigInt) = {
      waitUntil(dut.io.ctrl.busy.toBoolean)
      dut.io.reg.enable.readData #= true
      waitUntil(dut.io.sb.SBvalid.toBoolean)
      dut.io.sb.SBready #= true
      dut.io.sb.SBrdata #= readData
      dut.clockDomain.waitRisingEdge()
      dut.io.reg.enable.readData #= false
      dut.io.sb.SBready #= false
      dut.io.sb.SBrdata #= 0
    }
    def responseBusWrite() = {
      waitUntil(dut.io.ctrl.busy.toBoolean)
      waitUntil(dut.io.sb.SBvalid.toBoolean)
      dut.io.sb.SBready #= true
      dut.clockDomain.waitRisingEdge()
      dut.io.sb.SBready #= false
    }
    // Fork a process to generate the reset and the clock on the dut
    dut.clockDomain.forkStimulus(period = 82)
    List(dut.io.sb.SBready, dut.io.ctrl.enable, dut.io.ctrl.write, dut.io.ctrl.unmappedAccess, dut.io.reg.enable.address, dut.io.reg.enable.writeData, dut.io.reg.enable.command, dut.io.reg.enable.readData, dut.io.reg.clear).foreach(_ #= false)
    List(dut.io.reg.data, dut.io.reg.command, dut.io.sb.SBrdata).foreach(_ #= 0)

    dut.clockDomain.waitRisingEdge(2)
    
    clearRegs()

    setCommand(0x01l) 
    setAddress(BigInt(0xCAFEBABEl))
    sendTransaction()
    responseBusRead(BigInt(0x8BADF00Dl))
    dut.clockDomain.waitRisingEdge()

    clearRegs()

    setCommand(0x01l) 
    setAddress(BigInt(0xCAFEBABEl))
    sendTransaction()
    dut.io.ctrl.unmappedAccess #= true
    responseBusRead(BigInt(0x8BADF00Dl))
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.unmappedAccess #= false
    dut.clockDomain.waitRisingEdge()

    clearRegs()

    setCommand(0x02l)
    dut.io.ctrl.write #= true
    setAddress(BigInt(0xCAFEBABEl))
    setWriteData(BigInt(0xBEEFCAFEl))
    sendTransaction()
    responseBusWrite()
    dut.io.ctrl.write #= false
    dut.clockDomain.waitRisingEdge()

    clearRegs()

    setCommand(0x02l) 
    dut.io.ctrl.write #= true
    setAddress(BigInt(0xCAFEBABEl))
    dut.io.ctrl.write #= true
    sendTransaction()
    dut.io.ctrl.unmappedAccess #= true
    responseBusWrite()
    dut.io.ctrl.write #= false
    dut.clockDomain.waitRisingEdge()
    dut.io.ctrl.unmappedAccess #= false
    dut.clockDomain.waitRisingEdge()

    clearRegs()

    dut.clockDomain.waitRisingEdge(2)
    simSuccess()
  }
}
