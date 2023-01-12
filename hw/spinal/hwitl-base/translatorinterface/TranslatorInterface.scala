package hwitlbase

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

object CommandByte {
  def reset = B"8'x00"
  def read = B"8'x01"
  def write = B"8'x02"
  def getIrq = B"8'x03"
  def exit = B"8'x04"
}

object Request extends SpinalEnum {
  val none, read, write, clear, unsupported = newElement()
}

case class TranslatorInterface() extends Component {
  val io = new Bundle {
    val rxCtrl = new Bundle {
      val fifo = slave(Stream(Bits(8 bits)))
      val fifoEmpty = in(Bool())
    }
    val resp = master(ResponseControlIF())
    val timeout = in(Bool())
    val bus = new Bundle {
      val write = out(Bool())
      val enable = out(Bool())
      val busy = in(Bool())
      val unmapped = in(Bool())
    }
    val reg = new Bundle {
      val enable = new Bundle {
        val address = out(Bool())
        val writeData = out(Bool())
        val command = out(Bool())
        val readData = out(Bool())
      }
      val clear = out(Bool())
    }
    val shiftEnable = out(Bool())
  }

  // Transaction Interface Controller (TIC)
  val tic = new StateMachine {
    // val addressCounter = Counter(0 to 3)
    // val wdataCounter = Counter(0 to 3)
    // we can probably use one counter at a time anyway => reuse = less area
    val wordCounter = Counter(0 to 4)
    val commandFlag = Reg(Request()) init(Request.none)

    io.rxCtrl.fifo.ready := False
    io.resp.respType := ResponseType.noPayload
    io.resp.enable := False
    io.resp.clear := False
    io.bus.enable := False
    io.bus.write := (commandFlag === Request.write)
    io.reg.enable.address := False
    io.reg.enable.writeData := False
    io.reg.enable.command := False
    io.reg.enable.readData := False
    io.reg.clear := False
    io.shiftEnable := False

    val idle : State = new State with EntryPoint {
      whenIsActive {
        wordCounter.clear()
        io.reg.clear := True
        when(io.rxCtrl.fifo.valid) {
          goto(command)
        }
      }
    }

    val command : State = new State {
      whenIsActive {
        // when(io.rxCtrl.fifo.valid) {
        // }
        io.reg.enable.command := True
        switch(io.rxCtrl.fifo.payload){
          is(CommandByte.reset) { 
            commandFlag := Request.clear
            goto(clear) 
          }
          is(CommandByte.read) {
            commandFlag := Request.read
            goto(shiftAddressBytes)
          }
          is(CommandByte.write) { 
            commandFlag := Request.write
            goto(shiftAddressBytes)
          }
          // NOTE: no implemented yet exit, get interrupt, send unsupported ack byte
          default {
            commandFlag := Request.unsupported
            goto(startResponse)
          }
        }
      }
    }

    val shiftAddressBytes : State = new State {
      whenIsActive {
        io.shiftEnable := io.rxCtrl.fifo.valid
        io.rxCtrl.fifo.ready := True
        when(io.rxCtrl.fifo.valid && !wordCounter.willOverflowIfInc) {
          wordCounter.increment()
        }.elsewhen(wordCounter.willOverflowIfInc) { 
          goto(writeAddressWord)
        }
      }
    }

    val writeAddressWord : State = new State {
      whenIsActive {
        io.reg.enable.address := True
        wordCounter.clear()
        switch(commandFlag) {
          is(Request.read) {
            goto(startTransaction)
          }
          is(Request.write) {
            goto(shiftWriteDataBytes)
          }
          // this shouldnt happen at this point
          // but for robustness less recover to idle which clears registers
          default { 
            goto(idle)
          }
        }
      }
    }

    val shiftWriteDataBytes : State = new State {
      whenIsActive {}
    }

    val writeWriteDataWord : State = new State {
      whenIsActive {}
    }

    val startTransaction : State = new State {
      whenIsActive {
        io.bus.enable := True
        goto(waitTransaction)
      }
    }
    
    val waitTransaction : State = new State {
      whenIsActive {
        io.reg.enable.readData := True
        when(!io.bus.busy) {
          goto(startResponse)
        }
      }
    }

    val clear : State = new State {
      whenIsActive {}
    }

    val startResponse : State = new State {
      whenIsActive {
        io.resp.enable := True
        goto(waitResponse)
      }
    }

    val waitResponse : State = new State {
      whenIsActive {
        when(!io.resp.busy) {
          goto(idle)
        }
      }
    }
  }
}
