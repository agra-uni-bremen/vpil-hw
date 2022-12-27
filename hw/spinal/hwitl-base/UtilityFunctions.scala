package hwitlbase

import spinal.core._

object UtilityFunctions {
  def isInRange(addr: UInt, addr_begin: UInt, addr_end: UInt): Bool = {
    (addr >= addr_begin && addr <= addr_end)
  }

}