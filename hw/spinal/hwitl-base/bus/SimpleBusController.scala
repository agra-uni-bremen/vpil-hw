package hwitlbase

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.fsm._

case class SimpleBusController() extends Component {
  val io = new Bundle {
    val enable = in(Bool())
    val write = in(Bool())
    val busy = out(Bool())
    val sbValid = out(Bool())
    val sbReady = in(Bool())
    val sbWrite = out(Bool())
  }
  val busStateMachine = new StateMachine {
    
    val busyFlag = Reg(Bool) init(False)
    io.sbValid := False

    val idle : State = new State with EntryPoint {
      whenIsActive{
        when(io.enable) {
          goto(sendRequest)
        }
      }
      onExit{
        busyFlag := True
      }
    }

    val sendRequest : State = new State {
      // currently only send request as strobe
      whenIsActive{
        io.sbValid := True
        io.sbWrite := io.write
        goto(waitResponse)
      }
    }

    val waitResponse : State = new State {
      whenIsActive{
        io.sbValid := True
        when(io.sbReady){
          goto(idle)
        }
      }
      onExit{
        busyFlag := False
      }
    }
  }
  io.busy := busStateMachine.busyFlag
}

object SimpleBusControllerVerilog extends App {
  Config.spinal.generateVerilog(SimpleBusController()).printPruned
}