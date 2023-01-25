package hwitlbase

import spinal.core._
import spinal.core.sim._

object Config {
  def spinal = SpinalConfig(
    targetDirectory = "hw/gen",
    defaultClockDomainFrequency = FixedFrequency(12 MHz),
    defaultConfigForClockDomains = ClockDomainConfig(
      resetActiveLevel = LOW,
      resetKind = ASYNC
    ),
    onlyStdLogicVectorAtTopLevelIo = true
  )

  def sim = SimConfig.withConfig(spinal).withFstWave
  def simNoWave = SimConfig.withConfig(spinal)
}
