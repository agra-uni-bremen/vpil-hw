package hwitlbase

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.fsm._

case class SimpleBusController() extends Component {
  val io = new Bundle {
    val enable = in(Bool())
    val busy = out(Bool())
    val sbValid = out(Bool())
    val sbReady = in(Bool())
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
        goto(waitResponse)
      }
    }

    val waitResponse : State = new State {
      whenIsActive{
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