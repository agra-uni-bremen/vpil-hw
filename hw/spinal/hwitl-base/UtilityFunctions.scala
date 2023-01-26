package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.io.{InOutWrapper, TriStateArray}

object UtilityFunctions {
  def isInRange(addr: UInt, addr_begin: UInt, addr_end: UInt): Bool = {
    (addr >= addr_begin && addr <= addr_end)
  }

  def createSBIOConnection(tristateGPIOInput: TriStateArray, gpioOutputPort: Vec[Bool]): Unit = { 
    // create SB_IO primitves for each GPIO pin of bank 1 - create instance, and connect
    for(i <- 0 until 8) {
      println("set_io " + tristateGPIOInput.getName() + "_" + i)
      // val newIo = inout(Analog(Bool)).setWeakName(gpio_bank1.io.gpio.getName() + "_" + i)
      val sbio = SB_IO("101001")
      //io.gpio0.setWeakName(gpio_bank0.io.gpio.getName() + "_" + i)
      sbio.PACKAGE_PIN := gpioOutputPort(i)
      sbio.OUTPUT_ENABLE := tristateGPIOInput.writeEnable(i)
      sbio.D_OUT_0 := tristateGPIOInput.write(i)
      tristateGPIOInput.read(i) := sbio.D_IN_0
      //io.gpioA(i) := sbio.PACKAGE_PIN
    }
  }
  def createSBIOConnectionStubs(tristateGPIOInput: TriStateArray, gpioOutputPort: Vec[Bool]): Unit = { 
    // create SB_IO primitves for each GPIO pin of bank 1 - create instance, and connect
    for(i <- 0 until 8) {
      // println("set_io " + tristateGPIOInput.getName() + "_" + i)
      // val newIo = inout(Analog(Bool)).setWeakName(gpio_bank1.io.gpio.getName() + "_" + i)
      // val sbio = SB_IO("101001")
      //io.gpio0.setWeakName(gpio_bank0.io.gpio.getName() + "_" + i)
      tristateGPIOInput.read(i) := tristateGPIOInput.write(i)
      //io.gpioA(i) := sbio.PACKAGE_PIN
    }
  }
}