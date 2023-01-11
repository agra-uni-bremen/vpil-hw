package hwitlbase

import spinal.core._
import spinal.lib.IMasterSlave
import spinal.lib.fsm._

case class TranslatorInterface() extends Component {
  val io = new Bundle {
    val rxCtrl = new Bundle {
        val fifo = in(Stream(8 bits))
        val fifoEmpty = in(Bool())
    }
    val resp = new Bundle {
        val enable = out(Bool())
        val busy = in(Bool())
        val response = out(ResponseType())
    }
    val timeout = in(Bool())
    val bus = new Bundle {
        val enable = out(Bool())
        val busy = in(Bool())
        val write = out(Bool())
    }
    val reg = new Bundle {
        val enable = new Bundle {
            val address = out(Bool())
            val writeData = out(Bool())
            val command = out(Bool())
        }
        val clear = out(Bool())
    }
    val shiftEnable = out(Bool())
  }
  
}