package hwitlbase

import spinal.core._
import spinal.lib.fsm._
import spinal.lib.IMasterSlave
import spinal.lib._

case class ResponseBuilderController() extends Component {
  val io = new Bundle {
    val ctrl = new Bundle {
        val enable = in(Bool())
        val busy = out(Bool())
        val respType = in(ResponseType())
    }
    val txCtrl = new Bundle {
        val valid = out(Bool())
        val ready = in(Bool())
    }
    
  }
  
  val rbFSM = new StateMachine {
    val byteCounter = Counter(0 to byteCountMax)
    val busyFlag = Reg(Bool()) init(False)
    io.ctrl.busy := busyFlag
    io.txCtrl := False
    val idle: State = new State with EntryPoint {
      whenIsActive {
        when(io.ctrl.enable){
            busyFlag := True
            goto(txStatus)
        }
      }
    }
    val txStatus : State = new State {
        whenIsActive{
            txCtrl.valid := True

        }
    }
    val txPayload : State = new State {
        whenIsActive{
            
        }
    }
  }
}
