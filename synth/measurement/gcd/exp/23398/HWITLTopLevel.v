// Generator : SpinalHDL v1.8.0    git head : 4e3563a282582b41f4eaafc503787757251d23ea
// Component : HWITLTopLevel
// Git hash  : 3b2466203c52554b20c8e90f5c6d8b8f3b149865

`timescale 1ns/1ps

module HWITLTopLevel (
  output              io_uartCMD_txd,
  input               io_uartCMD_rxd,
  input               clk,
  input               resetn
);
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam ResponseType_noPayload = 1'd0;
  localparam ResponseType_payload = 1'd1;

  wire                builder_io_txFifoEmpty;
  wire                tic_io_rx_fifoEmpty;
  wire                uartCtrl_1_io_write_ready;
  wire                uartCtrl_1_io_read_valid;
  wire       [7:0]    uartCtrl_1_io_read_payload;
  wire                uartCtrl_1_io_uart_txd;
  wire                uartCtrl_1_io_readError;
  wire                uartCtrl_1_io_readBreak;
  wire                rxFifo_io_push_ready;
  wire                rxFifo_io_pop_valid;
  wire       [7:0]    rxFifo_io_pop_payload;
  wire       [4:0]    rxFifo_io_occupancy;
  wire       [4:0]    rxFifo_io_availability;
  wire                txFifo_io_push_ready;
  wire                txFifo_io_pop_valid;
  wire       [7:0]    txFifo_io_pop_payload;
  wire       [4:0]    txFifo_io_occupancy;
  wire       [4:0]    txFifo_io_availability;
  wire       [31:0]   serParConv_io_outData;
  wire                builder_io_txFifo_valid;
  wire       [7:0]    builder_io_txFifo_payload;
  wire                builder_io_ctrl_busy;
  wire                tic_io_rx_fifo_ready;
  wire       [0:0]    tic_io_resp_respType;
  wire                tic_io_resp_enable;
  wire                tic_io_resp_clear;
  wire                tic_io_timeout_clear;
  wire                tic_io_bus_write;
  wire                tic_io_bus_enable;
  wire                tic_io_reg_enable_address;
  wire                tic_io_reg_enable_writeData;
  wire                tic_io_reg_enable_command;
  wire                tic_io_reg_enable_readData;
  wire                tic_io_reg_clear;
  wire                tic_io_shiftReg_enable;
  wire                tic_io_shiftReg_clear;
  wire                busMaster_io_sb_SBvalid;
  wire       [31:0]   busMaster_io_sb_SBaddress;
  wire       [31:0]   busMaster_io_sb_SBwdata;
  wire                busMaster_io_sb_SBwrite;
  wire       [3:0]    busMaster_io_sb_SBsize;
  wire                busMaster_io_ctrl_busy;
  wire                busMaster_io_response_irq;
  wire       [6:0]    busMaster_io_response_ack;
  wire       [31:0]   busMaster_io_response_payload;
  wire                gcd_periph_io_sb_SBready;
  wire       [31:0]   gcd_periph_io_sb_SBrdata;
  wire                io_sb_decoder_io_input_SBready;
  wire       [31:0]   io_sb_decoder_io_input_SBrdata;
  wire                io_sb_decoder_io_outputs_0_SBvalid;
  wire       [31:0]   io_sb_decoder_io_outputs_0_SBaddress;
  wire       [31:0]   io_sb_decoder_io_outputs_0_SBwdata;
  wire                io_sb_decoder_io_outputs_0_SBwrite;
  wire       [3:0]    io_sb_decoder_io_outputs_0_SBsize;
  wire                io_sb_decoder_io_selects_0;
  wire                io_sb_decoder_io_unmapped_fired;
  wire       [14:0]   _zz_timeout_counter_valueNext;
  wire       [0:0]    _zz_timeout_counter_valueNext_1;
  reg                 timeout_state;
  reg                 timeout_stateRise;
  wire                timeout_counter_willIncrement;
  reg                 timeout_counter_willClear;
  reg        [14:0]   timeout_counter_valueNext;
  reg        [14:0]   timeout_counter_value;
  wire                timeout_counter_willOverflowIfInc;
  wire                timeout_counter_willOverflow;

  assign _zz_timeout_counter_valueNext_1 = timeout_counter_willIncrement;
  assign _zz_timeout_counter_valueNext = {14'd0, _zz_timeout_counter_valueNext_1};
  UartCtrl uartCtrl_1 (
    .io_config_frame_dataLength (3'b111                         ), //i
    .io_config_frame_stop       (UartStopType_ONE               ), //i
    .io_config_frame_parity     (UartParityType_NONE            ), //i
    .io_config_clockDivider     (20'h0000c                      ), //i
    .io_write_valid             (txFifo_io_pop_valid            ), //i
    .io_write_ready             (uartCtrl_1_io_write_ready      ), //o
    .io_write_payload           (txFifo_io_pop_payload[7:0]     ), //i
    .io_read_valid              (uartCtrl_1_io_read_valid       ), //o
    .io_read_ready              (rxFifo_io_push_ready           ), //i
    .io_read_payload            (uartCtrl_1_io_read_payload[7:0]), //o
    .io_uart_txd                (uartCtrl_1_io_uart_txd         ), //o
    .io_uart_rxd                (io_uartCMD_rxd                 ), //i
    .io_readError               (uartCtrl_1_io_readError        ), //o
    .io_writeBreak              (1'b0                           ), //i
    .io_readBreak               (uartCtrl_1_io_readBreak        ), //o
    .clk                        (clk                            ), //i
    .resetn                     (resetn                         )  //i
  );
  StreamFifo_1 rxFifo (
    .io_push_valid   (uartCtrl_1_io_read_valid       ), //i
    .io_push_ready   (rxFifo_io_push_ready           ), //o
    .io_push_payload (uartCtrl_1_io_read_payload[7:0]), //i
    .io_pop_valid    (rxFifo_io_pop_valid            ), //o
    .io_pop_ready    (tic_io_rx_fifo_ready           ), //i
    .io_pop_payload  (rxFifo_io_pop_payload[7:0]     ), //o
    .io_flush        (1'b0                           ), //i
    .io_occupancy    (rxFifo_io_occupancy[4:0]       ), //o
    .io_availability (rxFifo_io_availability[4:0]    ), //o
    .clk             (clk                            ), //i
    .resetn          (resetn                         )  //i
  );
  StreamFifo_1 txFifo (
    .io_push_valid   (builder_io_txFifo_valid       ), //i
    .io_push_ready   (txFifo_io_push_ready          ), //o
    .io_push_payload (builder_io_txFifo_payload[7:0]), //i
    .io_pop_valid    (txFifo_io_pop_valid           ), //o
    .io_pop_ready    (uartCtrl_1_io_write_ready     ), //i
    .io_pop_payload  (txFifo_io_pop_payload[7:0]    ), //o
    .io_flush        (1'b0                          ), //i
    .io_occupancy    (txFifo_io_occupancy[4:0]      ), //o
    .io_availability (txFifo_io_availability[4:0]   ), //o
    .clk             (clk                           ), //i
    .resetn          (resetn                        )  //i
  );
  SerialParallelConverter serParConv (
    .io_shiftEnable  (tic_io_shiftReg_enable     ), //i
    .io_clear        (tic_io_shiftReg_clear      ), //i
    .io_outputEnable (1'b1                       ), //i
    .io_inData       (rxFifo_io_pop_payload[7:0] ), //i
    .io_outData      (serParConv_io_outData[31:0]), //o
    .clk             (clk                        ), //i
    .resetn          (resetn                     )  //i
  );
  ResponseBuilder builder (
    .io_txFifo_valid   (builder_io_txFifo_valid            ), //o
    .io_txFifo_ready   (txFifo_io_push_ready               ), //i
    .io_txFifo_payload (builder_io_txFifo_payload[7:0]     ), //o
    .io_txFifoEmpty    (builder_io_txFifoEmpty             ), //i
    .io_ctrl_respType  (tic_io_resp_respType               ), //i
    .io_ctrl_enable    (tic_io_resp_enable                 ), //i
    .io_ctrl_busy      (builder_io_ctrl_busy               ), //o
    .io_ctrl_clear     (tic_io_resp_clear                  ), //i
    .io_data_ack       (busMaster_io_response_ack[6:0]     ), //i
    .io_data_irq       (busMaster_io_response_irq          ), //i
    .io_data_readData  (busMaster_io_response_payload[31:0]), //i
    .clk               (clk                                ), //i
    .resetn            (resetn                             )  //i
  );
  TranslatorInterfaceController tic (
    .io_rx_fifo_valid        (rxFifo_io_pop_valid            ), //i
    .io_rx_fifo_ready        (tic_io_rx_fifo_ready           ), //o
    .io_rx_fifo_payload      (rxFifo_io_pop_payload[7:0]     ), //i
    .io_rx_fifoEmpty         (tic_io_rx_fifoEmpty            ), //i
    .io_resp_respType        (tic_io_resp_respType           ), //o
    .io_resp_enable          (tic_io_resp_enable             ), //o
    .io_resp_busy            (builder_io_ctrl_busy           ), //i
    .io_resp_clear           (tic_io_resp_clear              ), //o
    .io_timeout_pending      (timeout_state                  ), //i
    .io_timeout_clear        (tic_io_timeout_clear           ), //o
    .io_bus_write            (tic_io_bus_write               ), //o
    .io_bus_enable           (tic_io_bus_enable              ), //o
    .io_bus_busy             (busMaster_io_ctrl_busy         ), //i
    .io_bus_unmapped         (io_sb_decoder_io_unmapped_fired), //i
    .io_reg_enable_address   (tic_io_reg_enable_address      ), //o
    .io_reg_enable_writeData (tic_io_reg_enable_writeData    ), //o
    .io_reg_enable_command   (tic_io_reg_enable_command      ), //o
    .io_reg_enable_readData  (tic_io_reg_enable_readData     ), //o
    .io_reg_clear            (tic_io_reg_clear               ), //o
    .io_shiftReg_enable      (tic_io_shiftReg_enable         ), //o
    .io_shiftReg_clear       (tic_io_shiftReg_clear          ), //o
    .clk                     (clk                            ), //i
    .resetn                  (resetn                         )  //i
  );
  HWITLBusMaster busMaster (
    .io_sb_SBaddress         (busMaster_io_sb_SBaddress[31:0]     ), //o
    .io_sb_SBvalid           (busMaster_io_sb_SBvalid             ), //o
    .io_sb_SBwdata           (busMaster_io_sb_SBwdata[31:0]       ), //o
    .io_sb_SBwrite           (busMaster_io_sb_SBwrite             ), //o
    .io_sb_SBsize            (busMaster_io_sb_SBsize[3:0]         ), //o
    .io_sb_SBready           (io_sb_decoder_io_input_SBready      ), //i
    .io_sb_SBrdata           (io_sb_decoder_io_input_SBrdata[31:0]), //i
    .io_ctrl_enable          (tic_io_bus_enable                   ), //i
    .io_ctrl_write           (tic_io_bus_write                    ), //i
    .io_ctrl_busy            (busMaster_io_ctrl_busy              ), //o
    .io_ctrl_unmappedAccess  (io_sb_decoder_io_unmapped_fired     ), //i
    .io_reg_enable_address   (tic_io_reg_enable_address           ), //i
    .io_reg_enable_writeData (tic_io_reg_enable_writeData         ), //i
    .io_reg_enable_command   (tic_io_reg_enable_command           ), //i
    .io_reg_enable_readData  (tic_io_reg_enable_readData          ), //i
    .io_reg_clear            (tic_io_reg_clear                    ), //i
    .io_reg_data             (serParConv_io_outData[31:0]         ), //i
    .io_reg_command          (rxFifo_io_pop_payload[7:0]          ), //i
    .io_response_irq         (busMaster_io_response_irq           ), //o
    .io_response_ack         (busMaster_io_response_ack[6:0]      ), //o
    .io_response_payload     (busMaster_io_response_payload[31:0] ), //o
    .clk                     (clk                                 ), //i
    .resetn                  (resetn                              )  //i
  );
  SBGCDCtrl gcd_periph (
    .io_sb_SBaddress (io_sb_decoder_io_outputs_0_SBaddress[31:0]), //i
    .io_sb_SBvalid   (io_sb_decoder_io_outputs_0_SBvalid        ), //i
    .io_sb_SBwdata   (io_sb_decoder_io_outputs_0_SBwdata[31:0]  ), //i
    .io_sb_SBwrite   (io_sb_decoder_io_outputs_0_SBwrite        ), //i
    .io_sb_SBsize    (io_sb_decoder_io_outputs_0_SBsize[3:0]    ), //i
    .io_sb_SBready   (gcd_periph_io_sb_SBready                  ), //o
    .io_sb_SBrdata   (gcd_periph_io_sb_SBrdata[31:0]            ), //o
    .io_sel          (io_sb_decoder_io_selects_0                ), //i
    .clk             (clk                                       ), //i
    .resetn          (resetn                                    )  //i
  );
  SimpleBusDecoder io_sb_decoder (
    .io_input_SBaddress     (busMaster_io_sb_SBaddress[31:0]           ), //i
    .io_input_SBvalid       (busMaster_io_sb_SBvalid                   ), //i
    .io_input_SBwdata       (busMaster_io_sb_SBwdata[31:0]             ), //i
    .io_input_SBwrite       (busMaster_io_sb_SBwrite                   ), //i
    .io_input_SBsize        (busMaster_io_sb_SBsize[3:0]               ), //i
    .io_input_SBready       (io_sb_decoder_io_input_SBready            ), //o
    .io_input_SBrdata       (io_sb_decoder_io_input_SBrdata[31:0]      ), //o
    .io_outputs_0_SBaddress (io_sb_decoder_io_outputs_0_SBaddress[31:0]), //o
    .io_outputs_0_SBvalid   (io_sb_decoder_io_outputs_0_SBvalid        ), //o
    .io_outputs_0_SBwdata   (io_sb_decoder_io_outputs_0_SBwdata[31:0]  ), //o
    .io_outputs_0_SBwrite   (io_sb_decoder_io_outputs_0_SBwrite        ), //o
    .io_outputs_0_SBsize    (io_sb_decoder_io_outputs_0_SBsize[3:0]    ), //o
    .io_outputs_0_SBready   (gcd_periph_io_sb_SBready                  ), //i
    .io_outputs_0_SBrdata   (gcd_periph_io_sb_SBrdata[31:0]            ), //i
    .io_selects_0           (io_sb_decoder_io_selects_0                ), //o
    .io_unmapped_fired      (io_sb_decoder_io_unmapped_fired           ), //o
    .io_unmapped_clear      (tic_io_reg_clear                          ), //i
    .clk                    (clk                                       ), //i
    .resetn                 (resetn                                    )  //i
  );
  always @(*) begin
    timeout_stateRise = 1'b0; // @[Utils.scala 594:19]
    if(timeout_counter_willOverflow) begin
      timeout_stateRise = (! timeout_state); // @[Utils.scala 599:15]
    end
    if(tic_io_timeout_clear) begin
      timeout_stateRise = 1'b0; // @[Utils.scala 605:15]
    end
  end

  always @(*) begin
    timeout_counter_willClear = 1'b0; // @[Utils.scala 537:19]
    if(tic_io_timeout_clear) begin
      timeout_counter_willClear = 1'b1; // @[Utils.scala 539:33]
    end
  end

  assign timeout_counter_willOverflowIfInc = (timeout_counter_value == 15'h5dbf); // @[BaseType.scala 305:24]
  assign timeout_counter_willOverflow = (timeout_counter_willOverflowIfInc && timeout_counter_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    if(timeout_counter_willOverflow) begin
      timeout_counter_valueNext = 15'h0; // @[Utils.scala 552:17]
    end else begin
      timeout_counter_valueNext = (timeout_counter_value + _zz_timeout_counter_valueNext); // @[Utils.scala 554:17]
    end
    if(timeout_counter_willClear) begin
      timeout_counter_valueNext = 15'h0; // @[Utils.scala 558:15]
    end
  end

  assign timeout_counter_willIncrement = 1'b1; // @[Utils.scala 540:41]
  assign io_uartCMD_txd = uartCtrl_1_io_uart_txd; // @[HWITLTopLevel.scala 46:20]
  assign builder_io_txFifoEmpty = (txFifo_io_occupancy == 5'h0); // @[HWITLTopLevel.scala 63:26]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      timeout_state <= 1'b0; // @[Data.scala 400:33]
      timeout_counter_value <= 15'h0; // @[Data.scala 400:33]
    end else begin
      timeout_counter_value <= timeout_counter_valueNext; // @[Reg.scala 39:30]
      if(timeout_counter_willOverflow) begin
        timeout_state <= 1'b1; // @[Utils.scala 598:11]
      end
      if(tic_io_timeout_clear) begin
        timeout_state <= 1'b0; // @[Utils.scala 604:11]
      end
    end
  end


endmodule

module SimpleBusDecoder (
  input      [31:0]   io_input_SBaddress,
  input               io_input_SBvalid,
  input      [31:0]   io_input_SBwdata,
  input               io_input_SBwrite,
  input      [3:0]    io_input_SBsize,
  output              io_input_SBready,
  output     [31:0]   io_input_SBrdata,
  output     [31:0]   io_outputs_0_SBaddress,
  output              io_outputs_0_SBvalid,
  output     [31:0]   io_outputs_0_SBwdata,
  output              io_outputs_0_SBwrite,
  output     [3:0]    io_outputs_0_SBsize,
  input               io_outputs_0_SBready,
  input      [31:0]   io_outputs_0_SBrdata,
  output              io_selects_0,
  output              io_unmapped_fired,
  input               io_unmapped_clear,
  input               clk,
  input               resetn
);

  wire                decodeLogic_addressMapSelector_0;
  reg                 decodeLogic_noHitReg;
  wire                when_SimpleBusDecoder_l53;

  assign decodeLogic_addressMapSelector_0 = (((io_input_SBaddress & 32'hffffff00) == 32'h50004000) && io_input_SBvalid); // @[BaseType.scala 305:24]
  assign io_selects_0 = decodeLogic_addressMapSelector_0; // @[SimpleBusDecoder.scala 38:55]
  assign io_outputs_0_SBaddress = io_input_SBaddress; // @[SimpleBusDecoder.scala 41:43]
  assign io_outputs_0_SBwdata = io_input_SBwdata; // @[SimpleBusDecoder.scala 42:41]
  assign io_outputs_0_SBwrite = io_input_SBwrite; // @[SimpleBusDecoder.scala 43:41]
  assign io_outputs_0_SBsize = io_input_SBsize; // @[SimpleBusDecoder.scala 44:40]
  assign io_outputs_0_SBvalid = io_input_SBvalid; // @[SimpleBusDecoder.scala 45:41]
  assign io_input_SBrdata = io_outputs_0_SBrdata; // @[SimpleBusDecoder.scala 47:22]
  assign io_input_SBready = io_outputs_0_SBready; // @[SimpleBusDecoder.scala 48:22]
  assign io_unmapped_fired = decodeLogic_noHitReg; // @[SimpleBusDecoder.scala 52:23]
  assign when_SimpleBusDecoder_l53 = (io_input_SBvalid && (! (decodeLogic_addressMapSelector_0 != 1'b0))); // @[BaseType.scala 305:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      decodeLogic_noHitReg <= 1'b0; // @[Data.scala 400:33]
    end else begin
      if(when_SimpleBusDecoder_l53) begin
        decodeLogic_noHitReg <= 1'b1; // @[SimpleBusDecoder.scala 54:16]
      end else begin
        if(io_unmapped_clear) begin
          decodeLogic_noHitReg <= 1'b0; // @[SimpleBusDecoder.scala 56:16]
        end
      end
    end
  end


endmodule

module SBGCDCtrl (
  input      [31:0]   io_sb_SBaddress,
  input               io_sb_SBvalid,
  input      [31:0]   io_sb_SBwdata,
  input               io_sb_SBwrite,
  input      [3:0]    io_sb_SBsize,
  output              io_sb_SBready,
  output     [31:0]   io_sb_SBrdata,
  input               io_sel,
  input               clk,
  input               resetn
);

  wire                gcdCtrl_1_io_ready;
  wire       [31:0]   gcdCtrl_1_io_res;
  wire                busCtrl_io_ready;
  wire       [0:0]    _zz_sbDataOutputReg;
  reg        [31:0]   regA;
  reg        [31:0]   regB;
  reg        [31:0]   regResBuf;
  reg                 regValid;
  reg                 regReadyBuf;
  reg        [31:0]   sbDataOutputReg;
  wire                mmioRegLogic_read;
  wire                mmioRegLogic_write;
  wire       [7:0]    mmioRegLogic_addr;
  wire                when_SBGCDCtrl_l29;
  wire                when_SBGCDCtrl_l31;
  wire                when_SBGCDCtrl_l33;
  wire                when_SBGCDCtrl_l35;
  wire                when_SBGCDCtrl_l37;
  wire                when_SBGCDCtrl_l41;
  wire                when_SBGCDCtrl_l43;
  wire                when_SBGCDCtrl_l45;
  wire                when_SBGCDCtrl_l50;

  assign _zz_sbDataOutputReg = regReadyBuf;
  GCDTop gcdCtrl_1 (
    .io_valid (regValid              ), //i
    .io_ready (gcdCtrl_1_io_ready    ), //o
    .io_a     (regA[31:0]            ), //i
    .io_b     (regB[31:0]            ), //i
    .io_res   (gcdCtrl_1_io_res[31:0]), //o
    .clk      (clk                   ), //i
    .resetn   (resetn                )  //i
  );
  SimpleBusSlaveController busCtrl (
    .io_valid  (io_sb_SBvalid   ), //i
    .io_ready  (busCtrl_io_ready), //o
    .io_select (io_sel          ), //i
    .clk       (clk             ), //i
    .resetn    (resetn          )  //i
  );
  assign mmioRegLogic_read = ((io_sb_SBvalid && io_sel) && (! io_sb_SBwrite)); // @[BaseType.scala 305:24]
  assign mmioRegLogic_write = ((io_sb_SBvalid && io_sel) && io_sb_SBwrite); // @[BaseType.scala 305:24]
  assign mmioRegLogic_addr = io_sb_SBaddress[7 : 0]; // @[BaseType.scala 299:24]
  assign when_SBGCDCtrl_l29 = (mmioRegLogic_addr == 8'h0); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l31 = (mmioRegLogic_addr == 8'h04); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l33 = (mmioRegLogic_addr == 8'h08); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l35 = (mmioRegLogic_addr == 8'h0c); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l37 = (mmioRegLogic_addr == 8'h10); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l41 = (mmioRegLogic_addr == 8'h0); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l43 = (mmioRegLogic_addr == 8'h04); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l45 = (mmioRegLogic_addr == 8'h08); // @[BaseType.scala 305:24]
  assign when_SBGCDCtrl_l50 = (mmioRegLogic_addr == 8'h0c); // @[BaseType.scala 305:24]
  assign io_sb_SBready = busCtrl_io_ready; // @[SBGCDCtrl.scala 63:17]
  assign io_sb_SBrdata = sbDataOutputReg; // @[SBGCDCtrl.scala 64:17]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      regA <= 32'h0; // @[Data.scala 400:33]
      regB <= 32'h0; // @[Data.scala 400:33]
      regValid <= 1'b0; // @[Data.scala 400:33]
      sbDataOutputReg <= 32'h0; // @[Data.scala 400:33]
    end else begin
      regValid <= 1'b0; // @[Reg.scala 39:30]
      sbDataOutputReg <= 32'h0; // @[SBGCDCtrl.scala 25:21]
      if(mmioRegLogic_write) begin
        if(when_SBGCDCtrl_l29) begin
          regA <= io_sb_SBwdata; // @[SBGCDCtrl.scala 30:14]
        end else begin
          if(when_SBGCDCtrl_l31) begin
            regB <= io_sb_SBwdata; // @[SBGCDCtrl.scala 32:14]
          end else begin
            if(!when_SBGCDCtrl_l33) begin
              if(!when_SBGCDCtrl_l35) begin
                if(when_SBGCDCtrl_l37) begin
                  regValid <= (io_sb_SBwdata == 32'h00000001); // @[SBGCDCtrl.scala 38:18]
                end
              end
            end
          end
        end
      end else begin
        if(mmioRegLogic_read) begin
          if(when_SBGCDCtrl_l41) begin
            sbDataOutputReg <= regA; // @[SBGCDCtrl.scala 42:25]
          end else begin
            if(when_SBGCDCtrl_l43) begin
              sbDataOutputReg <= regB; // @[SBGCDCtrl.scala 44:25]
            end else begin
              if(when_SBGCDCtrl_l45) begin
                sbDataOutputReg <= regResBuf; // @[SBGCDCtrl.scala 46:25]
              end else begin
                if(when_SBGCDCtrl_l50) begin
                  sbDataOutputReg <= {31'd0, _zz_sbDataOutputReg}; // @[SBGCDCtrl.scala 51:25]
                end
              end
            end
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    if(gcdCtrl_1_io_ready) begin
      regResBuf <= gcdCtrl_1_io_res; // @[SBGCDCtrl.scala 17:30]
    end
    if(gcdCtrl_1_io_ready) begin
      regReadyBuf <= gcdCtrl_1_io_ready; // @[SBGCDCtrl.scala 19:32]
    end
    if(!mmioRegLogic_write) begin
      if(mmioRegLogic_read) begin
        if(!when_SBGCDCtrl_l41) begin
          if(!when_SBGCDCtrl_l43) begin
            if(when_SBGCDCtrl_l45) begin
              regResBuf <= 32'h0; // @[SBGCDCtrl.scala 48:19]
              regReadyBuf <= 1'b0; // @[SBGCDCtrl.scala 49:21]
            end
          end
        end
      end
    end
  end


endmodule

module HWITLBusMaster (
  output     [31:0]   io_sb_SBaddress,
  output              io_sb_SBvalid,
  output     [31:0]   io_sb_SBwdata,
  output              io_sb_SBwrite,
  output     [3:0]    io_sb_SBsize,
  input               io_sb_SBready,
  input      [31:0]   io_sb_SBrdata,
  input               io_ctrl_enable,
  input               io_ctrl_write,
  output              io_ctrl_busy,
  input               io_ctrl_unmappedAccess,
  input               io_reg_enable_address,
  input               io_reg_enable_writeData,
  input               io_reg_enable_command,
  input               io_reg_enable_readData,
  input               io_reg_clear,
  input      [31:0]   io_reg_data,
  input      [7:0]    io_reg_command,
  output              io_response_irq,
  output     [6:0]    io_response_ack,
  output     [31:0]   io_response_payload,
  input               clk,
  input               resetn
);

  wire                busCtrl_io_ctrl_write;
  wire                busCtrl_io_ctrl_busy;
  wire                busCtrl_io_bus_valid;
  wire                busCtrl_io_bus_write;
  wire       [31:0]   _zz_io_sb_SBaddress;
  wire       [6:0]    _zz_io_response_ack;
  wire       [6:0]    _zz_io_response_ack_1;
  reg        [7:0]    command;
  reg        [31:0]   address;
  reg        [31:0]   writeData;
  reg        [31:0]   readData;
  wire       [6:0]    ackCode;
  reg        [6:0]    _zz_ackCode;

  assign _zz_io_sb_SBaddress = address;
  assign _zz_io_response_ack_1 = 7'h02;
  assign _zz_io_response_ack = _zz_io_response_ack_1;
  SimpleBusMasterController busCtrl (
    .io_ctrl_enable  (io_ctrl_enable        ), //i
    .io_ctrl_write   (busCtrl_io_ctrl_write ), //i
    .io_ctrl_busy    (busCtrl_io_ctrl_busy  ), //o
    .io_bus_valid    (busCtrl_io_bus_valid  ), //o
    .io_bus_ready    (io_sb_SBready         ), //i
    .io_bus_write    (busCtrl_io_bus_write  ), //o
    .io_bus_unmapped (io_ctrl_unmappedAccess), //i
    .clk             (clk                   ), //i
    .resetn          (resetn                )  //i
  );
  assign io_ctrl_busy = busCtrl_io_ctrl_busy; // @[HWITLBusMaster.scala 43:16]
  always @(*) begin
    case(command)
      8'h0 : begin
        _zz_ackCode = 7'h01; // @[Misc.scala 239:22]
      end
      8'h01 : begin
        _zz_ackCode = 7'h01; // @[Misc.scala 239:22]
      end
      8'h02 : begin
        _zz_ackCode = 7'h01; // @[Misc.scala 239:22]
      end
      8'h03 : begin
        _zz_ackCode = 7'h03; // @[Misc.scala 239:22]
      end
      8'h04 : begin
        _zz_ackCode = 7'h01; // @[Misc.scala 239:22]
      end
      default : begin
        _zz_ackCode = 7'h03; // @[Misc.scala 235:22]
      end
    endcase
  end

  assign ackCode = _zz_ackCode; // @[HWITLBusMaster.scala 67:11]
  assign io_sb_SBaddress = _zz_io_sb_SBaddress; // @[HWITLBusMaster.scala 77:19]
  assign io_sb_SBwdata = writeData; // @[HWITLBusMaster.scala 78:17]
  assign io_sb_SBsize = 4'b0100; // @[HWITLBusMaster.scala 79:16]
  assign io_sb_SBwrite = io_ctrl_write; // @[HWITLBusMaster.scala 80:17]
  assign io_sb_SBvalid = busCtrl_io_bus_valid; // @[HWITLBusMaster.scala 81:17]
  assign io_response_irq = 1'b0; // @[HWITLBusMaster.scala 86:19]
  assign io_response_ack = ((! io_ctrl_unmappedAccess) ? ackCode : _zz_io_response_ack); // @[HWITLBusMaster.scala 88:19]
  assign io_response_payload = readData; // @[HWITLBusMaster.scala 90:23]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      command <= 8'h0; // @[Data.scala 400:33]
      address <= 32'h0; // @[Data.scala 400:33]
      writeData <= 32'h0; // @[Data.scala 400:33]
      readData <= 32'h0; // @[Data.scala 400:33]
    end else begin
      if(io_reg_clear) begin
        command <= 8'h0; // @[HWITLBusMaster.scala 52:59]
        address <= 32'h0; // @[HWITLBusMaster.scala 52:59]
        writeData <= 32'h0; // @[HWITLBusMaster.scala 52:59]
        readData <= 32'h0; // @[HWITLBusMaster.scala 52:59]
      end
      if(io_reg_enable_command) begin
        command <= io_reg_command; // @[HWITLBusMaster.scala 55:13]
      end
      if(io_reg_enable_address) begin
        address <= io_reg_data; // @[HWITLBusMaster.scala 58:13]
      end
      if(io_reg_enable_writeData) begin
        writeData <= io_reg_data; // @[HWITLBusMaster.scala 61:15]
      end
      if(io_reg_enable_readData) begin
        readData <= io_sb_SBrdata; // @[HWITLBusMaster.scala 64:14]
      end
    end
  end


endmodule

module TranslatorInterfaceController (
  input               io_rx_fifo_valid,
  output reg          io_rx_fifo_ready,
  input      [7:0]    io_rx_fifo_payload,
  input               io_rx_fifoEmpty,
  output     [0:0]    io_resp_respType,
  output reg          io_resp_enable,
  input               io_resp_busy,
  output reg          io_resp_clear,
  input               io_timeout_pending,
  output reg          io_timeout_clear,
  output              io_bus_write,
  output reg          io_bus_enable,
  input               io_bus_busy,
  input               io_bus_unmapped,
  output reg          io_reg_enable_address,
  output reg          io_reg_enable_writeData,
  output reg          io_reg_enable_command,
  output reg          io_reg_enable_readData,
  output reg          io_reg_clear,
  output reg          io_shiftReg_enable,
  output reg          io_shiftReg_clear,
  input               clk,
  input               resetn
);
  localparam ResponseType_noPayload = 1'd0;
  localparam ResponseType_payload = 1'd1;
  localparam Request_none = 3'd0;
  localparam Request_read = 3'd1;
  localparam Request_write = 3'd2;
  localparam Request_clear = 3'd3;
  localparam Request_unsupported = 3'd4;
  localparam tic_enumDef_BOOT = 4'd0;
  localparam tic_enumDef_idle = 4'd1;
  localparam tic_enumDef_command = 4'd2;
  localparam tic_enumDef_shiftAddressBytes = 4'd3;
  localparam tic_enumDef_writeAddressWord = 4'd4;
  localparam tic_enumDef_shiftWriteDataBytes = 4'd5;
  localparam tic_enumDef_writeWriteDataWord = 4'd6;
  localparam tic_enumDef_startTransaction = 4'd7;
  localparam tic_enumDef_waitTransaction = 4'd8;
  localparam tic_enumDef_clear = 4'd9;
  localparam tic_enumDef_startResponse = 4'd10;
  localparam tic_enumDef_waitResponse = 4'd11;

  wire       [2:0]    _zz_tic_wordCounter_valueNext;
  wire       [0:0]    _zz_tic_wordCounter_valueNext_1;
  wire                tic_wantExit;
  reg                 tic_wantStart;
  wire                tic_wantKill;
  reg                 tic_wordCounter_willIncrement;
  reg                 tic_wordCounter_willClear;
  reg        [2:0]    tic_wordCounter_valueNext;
  reg        [2:0]    tic_wordCounter_value;
  wire                tic_wordCounter_willOverflowIfInc;
  wire                tic_wordCounter_willOverflow;
  reg        [2:0]    tic_commandFlag;
  wire       [0:0]    _zz_io_resp_respType;
  reg        [3:0]    tic_stateReg;
  reg        [3:0]    tic_stateNext;
  wire                when_TranslatorInterfaceController_l118;
  wire                when_TranslatorInterfaceController_l155;
  wire                when_TranslatorInterfaceController_l185;
  wire                when_TranslatorInterfaceController_l217;
  `ifndef SYNTHESIS
  reg [71:0] io_resp_respType_string;
  reg [87:0] tic_commandFlag_string;
  reg [71:0] _zz_io_resp_respType_string;
  reg [151:0] tic_stateReg_string;
  reg [151:0] tic_stateNext_string;
  `endif


  assign _zz_tic_wordCounter_valueNext_1 = tic_wordCounter_willIncrement;
  assign _zz_tic_wordCounter_valueNext = {2'd0, _zz_tic_wordCounter_valueNext_1};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_resp_respType)
      ResponseType_noPayload : io_resp_respType_string = "noPayload";
      ResponseType_payload : io_resp_respType_string = "payload  ";
      default : io_resp_respType_string = "?????????";
    endcase
  end
  always @(*) begin
    case(tic_commandFlag)
      Request_none : tic_commandFlag_string = "none       ";
      Request_read : tic_commandFlag_string = "read       ";
      Request_write : tic_commandFlag_string = "write      ";
      Request_clear : tic_commandFlag_string = "clear      ";
      Request_unsupported : tic_commandFlag_string = "unsupported";
      default : tic_commandFlag_string = "???????????";
    endcase
  end
  always @(*) begin
    case(_zz_io_resp_respType)
      ResponseType_noPayload : _zz_io_resp_respType_string = "noPayload";
      ResponseType_payload : _zz_io_resp_respType_string = "payload  ";
      default : _zz_io_resp_respType_string = "?????????";
    endcase
  end
  always @(*) begin
    case(tic_stateReg)
      tic_enumDef_BOOT : tic_stateReg_string = "BOOT               ";
      tic_enumDef_idle : tic_stateReg_string = "idle               ";
      tic_enumDef_command : tic_stateReg_string = "command            ";
      tic_enumDef_shiftAddressBytes : tic_stateReg_string = "shiftAddressBytes  ";
      tic_enumDef_writeAddressWord : tic_stateReg_string = "writeAddressWord   ";
      tic_enumDef_shiftWriteDataBytes : tic_stateReg_string = "shiftWriteDataBytes";
      tic_enumDef_writeWriteDataWord : tic_stateReg_string = "writeWriteDataWord ";
      tic_enumDef_startTransaction : tic_stateReg_string = "startTransaction   ";
      tic_enumDef_waitTransaction : tic_stateReg_string = "waitTransaction    ";
      tic_enumDef_clear : tic_stateReg_string = "clear              ";
      tic_enumDef_startResponse : tic_stateReg_string = "startResponse      ";
      tic_enumDef_waitResponse : tic_stateReg_string = "waitResponse       ";
      default : tic_stateReg_string = "???????????????????";
    endcase
  end
  always @(*) begin
    case(tic_stateNext)
      tic_enumDef_BOOT : tic_stateNext_string = "BOOT               ";
      tic_enumDef_idle : tic_stateNext_string = "idle               ";
      tic_enumDef_command : tic_stateNext_string = "command            ";
      tic_enumDef_shiftAddressBytes : tic_stateNext_string = "shiftAddressBytes  ";
      tic_enumDef_writeAddressWord : tic_stateNext_string = "writeAddressWord   ";
      tic_enumDef_shiftWriteDataBytes : tic_stateNext_string = "shiftWriteDataBytes";
      tic_enumDef_writeWriteDataWord : tic_stateNext_string = "writeWriteDataWord ";
      tic_enumDef_startTransaction : tic_stateNext_string = "startTransaction   ";
      tic_enumDef_waitTransaction : tic_stateNext_string = "waitTransaction    ";
      tic_enumDef_clear : tic_stateNext_string = "clear              ";
      tic_enumDef_startResponse : tic_stateNext_string = "startResponse      ";
      tic_enumDef_waitResponse : tic_stateNext_string = "waitResponse       ";
      default : tic_stateNext_string = "???????????????????";
    endcase
  end
  `endif

  assign tic_wantExit = 1'b0; // @[StateMachine.scala 151:28]
  always @(*) begin
    tic_wantStart = 1'b0; // @[StateMachine.scala 152:19]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
        tic_wantStart = 1'b1; // @[StateMachine.scala 362:15]
      end
    endcase
  end

  assign tic_wantKill = 1'b0; // @[StateMachine.scala 153:18]
  always @(*) begin
    tic_wordCounter_willIncrement = 1'b0; // @[Utils.scala 536:23]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
        if(when_TranslatorInterfaceController_l118) begin
          tic_wordCounter_willIncrement = 1'b1; // @[Utils.scala 540:41]
        end
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
        if(when_TranslatorInterfaceController_l155) begin
          tic_wordCounter_willIncrement = 1'b1; // @[Utils.scala 540:41]
        end
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tic_wordCounter_willClear = 1'b0; // @[Utils.scala 537:19]
    case(tic_stateReg)
      tic_enumDef_idle : begin
        tic_wordCounter_willClear = 1'b1; // @[Utils.scala 539:33]
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
        tic_wordCounter_willClear = 1'b1; // @[Utils.scala 539:33]
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
        tic_wordCounter_willClear = 1'b1; // @[Utils.scala 539:33]
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
        tic_wordCounter_willClear = 1'b1; // @[Utils.scala 539:33]
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  assign tic_wordCounter_willOverflowIfInc = (tic_wordCounter_value == 3'b100); // @[BaseType.scala 305:24]
  assign tic_wordCounter_willOverflow = (tic_wordCounter_willOverflowIfInc && tic_wordCounter_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    if(tic_wordCounter_willOverflow) begin
      tic_wordCounter_valueNext = 3'b000; // @[Utils.scala 552:17]
    end else begin
      tic_wordCounter_valueNext = (tic_wordCounter_value + _zz_tic_wordCounter_valueNext); // @[Utils.scala 554:17]
    end
    if(tic_wordCounter_willClear) begin
      tic_wordCounter_valueNext = 3'b000; // @[Utils.scala 558:15]
    end
  end

  always @(*) begin
    io_rx_fifo_ready = 1'b0; // @[TranslatorInterfaceController.scala 59:22]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
        io_rx_fifo_ready = 1'b1; // @[TranslatorInterfaceController.scala 91:26]
      end
      tic_enumDef_shiftAddressBytes : begin
        io_rx_fifo_ready = 1'b1; // @[TranslatorInterfaceController.scala 117:26]
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
        io_rx_fifo_ready = 1'b1; // @[TranslatorInterfaceController.scala 154:26]
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  assign _zz_io_resp_respType = ((tic_commandFlag == Request_read) ? ResponseType_payload : ResponseType_noPayload); // @[Expression.scala 1420:25]
  assign io_resp_respType = _zz_io_resp_respType; // @[TranslatorInterfaceController.scala 60:22]
  always @(*) begin
    io_resp_enable = 1'b0; // @[TranslatorInterfaceController.scala 61:20]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
        io_resp_enable = 1'b1; // @[TranslatorInterfaceController.scala 208:24]
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_resp_clear = 1'b0; // @[TranslatorInterfaceController.scala 62:19]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
        io_resp_clear = 1'b1; // @[TranslatorInterfaceController.scala 197:23]
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_bus_enable = 1'b0; // @[TranslatorInterfaceController.scala 63:19]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
        io_bus_enable = 1'b1; // @[TranslatorInterfaceController.scala 175:23]
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  assign io_bus_write = (tic_commandFlag == Request_write); // @[TranslatorInterfaceController.scala 64:18]
  always @(*) begin
    io_timeout_clear = 1'b0; // @[TranslatorInterfaceController.scala 65:22]
    case(tic_stateReg)
      tic_enumDef_idle : begin
        io_timeout_clear = 1'b1; // @[TranslatorInterfaceController.scala 79:26]
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
        io_timeout_clear = 1'b1; // @[TranslatorInterfaceController.scala 199:26]
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_reg_enable_address = 1'b0; // @[TranslatorInterfaceController.scala 66:27]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
        io_reg_enable_address = 1'b1; // @[TranslatorInterfaceController.scala 130:31]
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_reg_enable_writeData = 1'b0; // @[TranslatorInterfaceController.scala 67:29]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
        io_reg_enable_writeData = 1'b1; // @[TranslatorInterfaceController.scala 167:33]
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_reg_enable_command = 1'b0; // @[TranslatorInterfaceController.scala 68:27]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
        io_reg_enable_command = 1'b1; // @[TranslatorInterfaceController.scala 90:31]
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_reg_enable_readData = 1'b0; // @[TranslatorInterfaceController.scala 69:28]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
        io_reg_enable_readData = (! io_bus_write); // @[TranslatorInterfaceController.scala 184:32]
        if(when_TranslatorInterfaceController_l185) begin
          io_reg_enable_readData = 1'b0; // @[TranslatorInterfaceController.scala 186:34]
        end
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_reg_clear = 1'b0; // @[TranslatorInterfaceController.scala 70:18]
    case(tic_stateReg)
      tic_enumDef_idle : begin
        io_reg_clear = 1'b1; // @[TranslatorInterfaceController.scala 78:22]
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
        io_reg_clear = 1'b1; // @[TranslatorInterfaceController.scala 196:22]
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_shiftReg_enable = 1'b0; // @[TranslatorInterfaceController.scala 71:24]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
        io_shiftReg_enable = io_rx_fifo_valid; // @[TranslatorInterfaceController.scala 116:28]
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
        io_shiftReg_enable = io_rx_fifo_valid; // @[TranslatorInterfaceController.scala 153:28]
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_shiftReg_clear = 1'b0; // @[TranslatorInterfaceController.scala 72:23]
    case(tic_stateReg)
      tic_enumDef_idle : begin
      end
      tic_enumDef_command : begin
      end
      tic_enumDef_shiftAddressBytes : begin
      end
      tic_enumDef_writeAddressWord : begin
      end
      tic_enumDef_shiftWriteDataBytes : begin
      end
      tic_enumDef_writeWriteDataWord : begin
      end
      tic_enumDef_startTransaction : begin
      end
      tic_enumDef_waitTransaction : begin
      end
      tic_enumDef_clear : begin
        io_shiftReg_clear = 1'b1; // @[TranslatorInterfaceController.scala 198:27]
      end
      tic_enumDef_startResponse : begin
      end
      tic_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    tic_stateNext = tic_stateReg; // @[StateMachine.scala 217:17]
    case(tic_stateReg)
      tic_enumDef_idle : begin
        if(io_rx_fifo_valid) begin
          tic_stateNext = tic_enumDef_command; // @[Enum.scala 148:67]
        end
      end
      tic_enumDef_command : begin
        case(io_rx_fifo_payload)
          8'h0 : begin
            tic_stateNext = tic_enumDef_clear; // @[Enum.scala 148:67]
          end
          8'h01 : begin
            tic_stateNext = tic_enumDef_shiftAddressBytes; // @[Enum.scala 148:67]
          end
          8'h02 : begin
            tic_stateNext = tic_enumDef_shiftAddressBytes; // @[Enum.scala 148:67]
          end
          default : begin
            tic_stateNext = tic_enumDef_startResponse; // @[Enum.scala 148:67]
          end
        endcase
      end
      tic_enumDef_shiftAddressBytes : begin
        if(!when_TranslatorInterfaceController_l118) begin
          if(tic_wordCounter_willOverflowIfInc) begin
            tic_stateNext = tic_enumDef_writeAddressWord; // @[Enum.scala 148:67]
          end else begin
            if(io_timeout_pending) begin
              tic_stateNext = tic_enumDef_clear; // @[Enum.scala 148:67]
            end
          end
        end
      end
      tic_enumDef_writeAddressWord : begin
        case(tic_commandFlag)
          Request_read : begin
            tic_stateNext = tic_enumDef_startTransaction; // @[Enum.scala 148:67]
          end
          Request_write : begin
            tic_stateNext = tic_enumDef_shiftWriteDataBytes; // @[Enum.scala 148:67]
          end
          default : begin
            tic_stateNext = tic_enumDef_idle; // @[Enum.scala 148:67]
          end
        endcase
      end
      tic_enumDef_shiftWriteDataBytes : begin
        if(!when_TranslatorInterfaceController_l155) begin
          if(tic_wordCounter_willOverflowIfInc) begin
            tic_stateNext = tic_enumDef_writeWriteDataWord; // @[Enum.scala 148:67]
          end else begin
            if(io_timeout_pending) begin
              tic_stateNext = tic_enumDef_clear; // @[Enum.scala 148:67]
            end
          end
        end
      end
      tic_enumDef_writeWriteDataWord : begin
        tic_stateNext = tic_enumDef_startTransaction; // @[Enum.scala 148:67]
      end
      tic_enumDef_startTransaction : begin
        if(io_bus_busy) begin
          tic_stateNext = tic_enumDef_waitTransaction; // @[Enum.scala 148:67]
        end
      end
      tic_enumDef_waitTransaction : begin
        if(when_TranslatorInterfaceController_l185) begin
          tic_stateNext = tic_enumDef_startResponse; // @[Enum.scala 148:67]
        end else begin
          if(io_timeout_pending) begin
            tic_stateNext = tic_enumDef_clear; // @[Enum.scala 148:67]
          end
        end
      end
      tic_enumDef_clear : begin
        tic_stateNext = tic_enumDef_idle; // @[Enum.scala 148:67]
      end
      tic_enumDef_startResponse : begin
        if(io_resp_busy) begin
          tic_stateNext = tic_enumDef_waitResponse; // @[Enum.scala 148:67]
        end
      end
      tic_enumDef_waitResponse : begin
        if(when_TranslatorInterfaceController_l217) begin
          tic_stateNext = tic_enumDef_idle; // @[Enum.scala 148:67]
        end else begin
          if(io_timeout_pending) begin
            tic_stateNext = tic_enumDef_clear; // @[Enum.scala 148:67]
          end
        end
      end
      default : begin
      end
    endcase
    if(tic_wantStart) begin
      tic_stateNext = tic_enumDef_idle; // @[Enum.scala 148:67]
    end
    if(tic_wantKill) begin
      tic_stateNext = tic_enumDef_BOOT; // @[Enum.scala 148:67]
    end
  end

  assign when_TranslatorInterfaceController_l118 = (io_rx_fifo_valid && (! tic_wordCounter_willOverflowIfInc)); // @[BaseType.scala 305:24]
  assign when_TranslatorInterfaceController_l155 = (io_rx_fifo_valid && (! tic_wordCounter_willOverflowIfInc)); // @[BaseType.scala 305:24]
  assign when_TranslatorInterfaceController_l185 = ((! io_bus_busy) || io_bus_unmapped); // @[BaseType.scala 305:24]
  assign when_TranslatorInterfaceController_l217 = (! io_resp_busy); // @[BaseType.scala 299:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      tic_wordCounter_value <= 3'b000; // @[Data.scala 400:33]
      tic_commandFlag <= Request_none; // @[Data.scala 400:33]
      tic_stateReg <= tic_enumDef_BOOT; // @[Data.scala 400:33]
    end else begin
      tic_wordCounter_value <= tic_wordCounter_valueNext; // @[Reg.scala 39:30]
      tic_stateReg <= tic_stateNext; // @[StateMachine.scala 212:14]
      case(tic_stateReg)
        tic_enumDef_idle : begin
          tic_commandFlag <= Request_none; // @[Enum.scala 148:67]
        end
        tic_enumDef_command : begin
          case(io_rx_fifo_payload)
            8'h0 : begin
              tic_commandFlag <= Request_clear; // @[Enum.scala 148:67]
            end
            8'h01 : begin
              tic_commandFlag <= Request_read; // @[Enum.scala 148:67]
            end
            8'h02 : begin
              tic_commandFlag <= Request_write; // @[Enum.scala 148:67]
            end
            default : begin
              tic_commandFlag <= Request_unsupported; // @[Enum.scala 148:67]
            end
          endcase
        end
        tic_enumDef_shiftAddressBytes : begin
        end
        tic_enumDef_writeAddressWord : begin
        end
        tic_enumDef_shiftWriteDataBytes : begin
        end
        tic_enumDef_writeWriteDataWord : begin
        end
        tic_enumDef_startTransaction : begin
        end
        tic_enumDef_waitTransaction : begin
        end
        tic_enumDef_clear : begin
          tic_commandFlag <= Request_none; // @[Enum.scala 148:67]
        end
        tic_enumDef_startResponse : begin
        end
        tic_enumDef_waitResponse : begin
        end
        default : begin
        end
      endcase
    end
  end


endmodule

module ResponseBuilder (
  output reg          io_txFifo_valid,
  input               io_txFifo_ready,
  output     [7:0]    io_txFifo_payload,
  input               io_txFifoEmpty,
  input      [0:0]    io_ctrl_respType,
  input               io_ctrl_enable,
  output              io_ctrl_busy,
  input               io_ctrl_clear,
  input      [6:0]    io_data_ack,
  input               io_data_irq,
  input      [31:0]   io_data_readData,
  input               clk,
  input               resetn
);
  localparam ResponseType_noPayload = 1'd0;
  localparam ResponseType_payload = 1'd1;
  localparam rbFSM_enumDef_BOOT = 3'd0;
  localparam rbFSM_enumDef_idle = 3'd1;
  localparam rbFSM_enumDef_txStatus = 3'd2;
  localparam rbFSM_enumDef_txPayload = 3'd3;
  localparam rbFSM_enumDef_waitTx = 3'd4;

  wire       [2:0]    _zz_rbFSM_byteCounter_valueNext;
  wire       [0:0]    _zz_rbFSM_byteCounter_valueNext_1;
  wire       [7:0]    _zz_payloadByte;
  wire                rbFSM_wantExit;
  reg                 rbFSM_wantStart;
  wire                rbFSM_wantKill;
  reg                 rbFSM_byteCounter_willIncrement;
  reg                 rbFSM_byteCounter_willClear;
  reg        [2:0]    rbFSM_byteCounter_valueNext;
  reg        [2:0]    rbFSM_byteCounter_value;
  wire                rbFSM_byteCounter_willOverflowIfInc;
  wire                rbFSM_byteCounter_willOverflow;
  reg                 rbFSM_busyFlag;
  reg        [7:0]    payloadByte;
  reg        [2:0]    rbFSM_stateReg;
  reg        [2:0]    rbFSM_stateNext;
  wire                when_ResponseBuilder_l63;
  wire                when_ResponseBuilder_l64;
  wire                when_ResponseBuilder_l69;
  wire                when_ResponseBuilder_l68;
  wire                when_ResponseBuilder_l84;
  wire                when_StateMachine_l237;
  `ifndef SYNTHESIS
  reg [71:0] io_ctrl_respType_string;
  reg [71:0] rbFSM_stateReg_string;
  reg [71:0] rbFSM_stateNext_string;
  `endif


  assign _zz_rbFSM_byteCounter_valueNext_1 = rbFSM_byteCounter_willIncrement;
  assign _zz_rbFSM_byteCounter_valueNext = {2'd0, _zz_rbFSM_byteCounter_valueNext_1};
  assign _zz_payloadByte = {io_data_irq,io_data_ack};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_ctrl_respType)
      ResponseType_noPayload : io_ctrl_respType_string = "noPayload";
      ResponseType_payload : io_ctrl_respType_string = "payload  ";
      default : io_ctrl_respType_string = "?????????";
    endcase
  end
  always @(*) begin
    case(rbFSM_stateReg)
      rbFSM_enumDef_BOOT : rbFSM_stateReg_string = "BOOT     ";
      rbFSM_enumDef_idle : rbFSM_stateReg_string = "idle     ";
      rbFSM_enumDef_txStatus : rbFSM_stateReg_string = "txStatus ";
      rbFSM_enumDef_txPayload : rbFSM_stateReg_string = "txPayload";
      rbFSM_enumDef_waitTx : rbFSM_stateReg_string = "waitTx   ";
      default : rbFSM_stateReg_string = "?????????";
    endcase
  end
  always @(*) begin
    case(rbFSM_stateNext)
      rbFSM_enumDef_BOOT : rbFSM_stateNext_string = "BOOT     ";
      rbFSM_enumDef_idle : rbFSM_stateNext_string = "idle     ";
      rbFSM_enumDef_txStatus : rbFSM_stateNext_string = "txStatus ";
      rbFSM_enumDef_txPayload : rbFSM_stateNext_string = "txPayload";
      rbFSM_enumDef_waitTx : rbFSM_stateNext_string = "waitTx   ";
      default : rbFSM_stateNext_string = "?????????";
    endcase
  end
  `endif

  assign rbFSM_wantExit = 1'b0; // @[StateMachine.scala 151:28]
  always @(*) begin
    rbFSM_wantStart = 1'b0; // @[StateMachine.scala 152:19]
    case(rbFSM_stateReg)
      rbFSM_enumDef_idle : begin
      end
      rbFSM_enumDef_txStatus : begin
      end
      rbFSM_enumDef_txPayload : begin
      end
      rbFSM_enumDef_waitTx : begin
      end
      default : begin
        rbFSM_wantStart = 1'b1; // @[StateMachine.scala 362:15]
      end
    endcase
  end

  assign rbFSM_wantKill = 1'b0; // @[StateMachine.scala 153:18]
  always @(*) begin
    rbFSM_byteCounter_willIncrement = 1'b0; // @[Utils.scala 536:23]
    case(rbFSM_stateReg)
      rbFSM_enumDef_idle : begin
      end
      rbFSM_enumDef_txStatus : begin
        if(io_txFifo_ready) begin
          rbFSM_byteCounter_willIncrement = 1'b1; // @[Utils.scala 540:41]
        end
      end
      rbFSM_enumDef_txPayload : begin
        if(io_txFifo_ready) begin
          rbFSM_byteCounter_willIncrement = 1'b1; // @[Utils.scala 540:41]
        end
      end
      rbFSM_enumDef_waitTx : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    rbFSM_byteCounter_willClear = 1'b0; // @[Utils.scala 537:19]
    case(rbFSM_stateReg)
      rbFSM_enumDef_idle : begin
        rbFSM_byteCounter_willClear = 1'b1; // @[Utils.scala 539:33]
      end
      rbFSM_enumDef_txStatus : begin
      end
      rbFSM_enumDef_txPayload : begin
      end
      rbFSM_enumDef_waitTx : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l237) begin
      rbFSM_byteCounter_willClear = 1'b1; // @[Utils.scala 539:33]
    end
  end

  assign rbFSM_byteCounter_willOverflowIfInc = (rbFSM_byteCounter_value == 3'b101); // @[BaseType.scala 305:24]
  assign rbFSM_byteCounter_willOverflow = (rbFSM_byteCounter_willOverflowIfInc && rbFSM_byteCounter_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    if(rbFSM_byteCounter_willOverflow) begin
      rbFSM_byteCounter_valueNext = 3'b000; // @[Utils.scala 552:17]
    end else begin
      rbFSM_byteCounter_valueNext = (rbFSM_byteCounter_value + _zz_rbFSM_byteCounter_valueNext); // @[Utils.scala 554:17]
    end
    if(rbFSM_byteCounter_willClear) begin
      rbFSM_byteCounter_valueNext = 3'b000; // @[Utils.scala 558:15]
    end
  end

  assign io_ctrl_busy = rbFSM_busyFlag; // @[ResponseBuilder.scala 39:18]
  always @(*) begin
    io_txFifo_valid = 1'b0; // @[ResponseBuilder.scala 40:21]
    case(rbFSM_stateReg)
      rbFSM_enumDef_idle : begin
      end
      rbFSM_enumDef_txStatus : begin
        io_txFifo_valid = 1'b1; // @[ResponseBuilder.scala 57:25]
        if(when_ResponseBuilder_l63) begin
          if(when_ResponseBuilder_l64) begin
            io_txFifo_valid = 1'b0; // @[ResponseBuilder.scala 65:29]
          end
        end
      end
      rbFSM_enumDef_txPayload : begin
        io_txFifo_valid = 1'b1; // @[ResponseBuilder.scala 78:25]
        if(when_ResponseBuilder_l84) begin
          io_txFifo_valid = 1'b0; // @[ResponseBuilder.scala 85:27]
        end
      end
      rbFSM_enumDef_waitTx : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    case(rbFSM_byteCounter_value)
      3'b000 : begin
        payloadByte = _zz_payloadByte; // @[Misc.scala 239:22]
      end
      3'b001 : begin
        payloadByte = io_data_readData[31 : 24]; // @[Misc.scala 239:22]
      end
      3'b010 : begin
        payloadByte = io_data_readData[23 : 16]; // @[Misc.scala 239:22]
      end
      3'b011 : begin
        payloadByte = io_data_readData[15 : 8]; // @[Misc.scala 239:22]
      end
      3'b100 : begin
        payloadByte = io_data_readData[7 : 0]; // @[Misc.scala 239:22]
      end
      default : begin
        payloadByte = 8'h0; // @[Misc.scala 235:22]
      end
    endcase
  end

  assign io_txFifo_payload = payloadByte; // @[ResponseBuilder.scala 110:21]
  always @(*) begin
    rbFSM_stateNext = rbFSM_stateReg; // @[StateMachine.scala 217:17]
    case(rbFSM_stateReg)
      rbFSM_enumDef_idle : begin
        if(io_ctrl_enable) begin
          rbFSM_stateNext = rbFSM_enumDef_txStatus; // @[Enum.scala 148:67]
        end
      end
      rbFSM_enumDef_txStatus : begin
        if(when_ResponseBuilder_l63) begin
          if(when_ResponseBuilder_l64) begin
            rbFSM_stateNext = rbFSM_enumDef_waitTx; // @[Enum.scala 148:67]
          end
        end else begin
          if(when_ResponseBuilder_l68) begin
            if(when_ResponseBuilder_l69) begin
              rbFSM_stateNext = rbFSM_enumDef_txPayload; // @[Enum.scala 148:67]
            end
          end
        end
      end
      rbFSM_enumDef_txPayload : begin
        if(when_ResponseBuilder_l84) begin
          rbFSM_stateNext = rbFSM_enumDef_waitTx; // @[Enum.scala 148:67]
        end
      end
      rbFSM_enumDef_waitTx : begin
        if(io_txFifoEmpty) begin
          rbFSM_stateNext = rbFSM_enumDef_idle; // @[Enum.scala 148:67]
        end
      end
      default : begin
      end
    endcase
    if(rbFSM_wantStart) begin
      rbFSM_stateNext = rbFSM_enumDef_idle; // @[Enum.scala 148:67]
    end
    if(rbFSM_wantKill) begin
      rbFSM_stateNext = rbFSM_enumDef_BOOT; // @[Enum.scala 148:67]
    end
  end

  assign when_ResponseBuilder_l63 = (io_ctrl_respType == ResponseType_noPayload); // @[BaseType.scala 305:24]
  assign when_ResponseBuilder_l64 = (rbFSM_byteCounter_value == 3'b001); // @[BaseType.scala 305:24]
  assign when_ResponseBuilder_l69 = (rbFSM_byteCounter_value == 3'b001); // @[BaseType.scala 305:24]
  assign when_ResponseBuilder_l68 = (io_ctrl_respType == ResponseType_payload); // @[BaseType.scala 305:24]
  assign when_ResponseBuilder_l84 = (rbFSM_byteCounter_value == 3'b101); // @[BaseType.scala 305:24]
  assign when_StateMachine_l237 = ((rbFSM_stateReg == rbFSM_enumDef_idle) && (! (rbFSM_stateNext == rbFSM_enumDef_idle))); // @[BaseType.scala 305:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      rbFSM_byteCounter_value <= 3'b000; // @[Data.scala 400:33]
      rbFSM_busyFlag <= 1'b0; // @[Data.scala 400:33]
      rbFSM_stateReg <= rbFSM_enumDef_BOOT; // @[Data.scala 400:33]
    end else begin
      rbFSM_byteCounter_value <= rbFSM_byteCounter_valueNext; // @[Reg.scala 39:30]
      rbFSM_stateReg <= rbFSM_stateNext; // @[StateMachine.scala 212:14]
      case(rbFSM_stateReg)
        rbFSM_enumDef_idle : begin
        end
        rbFSM_enumDef_txStatus : begin
        end
        rbFSM_enumDef_txPayload : begin
        end
        rbFSM_enumDef_waitTx : begin
          if(io_txFifoEmpty) begin
            rbFSM_busyFlag <= 1'b0; // @[ResponseBuilder.scala 95:20]
          end
        end
        default : begin
        end
      endcase
      if(when_StateMachine_l237) begin
        rbFSM_busyFlag <= 1'b1; // @[ResponseBuilder.scala 51:18]
      end
    end
  end


endmodule

module SerialParallelConverter (
  input               io_shiftEnable,
  input               io_clear,
  input               io_outputEnable,
  input      [7:0]    io_inData,
  output     [31:0]   io_outData,
  input               clk,
  input               resetn
);

  reg        [7:0]    shiftReg_0;
  reg        [7:0]    shiftReg_1;
  reg        [7:0]    shiftReg_2;
  reg        [7:0]    shiftReg_3;

  assign io_outData = (io_outputEnable ? {shiftReg_3,{shiftReg_2,{shiftReg_1,shiftReg_0}}} : 32'h0); // @[SerialParallelConverter.scala 40:14]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      shiftReg_0 <= 8'h0; // @[Data.scala 400:33]
      shiftReg_1 <= 8'h0; // @[Data.scala 400:33]
      shiftReg_2 <= 8'h0; // @[Data.scala 400:33]
      shiftReg_3 <= 8'h0; // @[Data.scala 400:33]
    end else begin
      if(io_shiftEnable) begin
        shiftReg_0 <= io_inData; // @[SerialParallelConverter.scala 28:17]
        shiftReg_1 <= shiftReg_0; // @[SerialParallelConverter.scala 30:21]
        shiftReg_2 <= shiftReg_1; // @[SerialParallelConverter.scala 30:21]
        shiftReg_3 <= shiftReg_2; // @[SerialParallelConverter.scala 30:21]
      end
      if(io_clear) begin
        shiftReg_0 <= 8'h0; // @[SerialParallelConverter.scala 36:24]
        shiftReg_1 <= 8'h0; // @[SerialParallelConverter.scala 36:24]
        shiftReg_2 <= 8'h0; // @[SerialParallelConverter.scala 36:24]
        shiftReg_3 <= 8'h0; // @[SerialParallelConverter.scala 36:24]
      end
    end
  end


endmodule

//StreamFifo_1 replaced by StreamFifo_1

module StreamFifo_1 (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [4:0]    io_occupancy,
  output     [4:0]    io_availability,
  input               clk,
  input               resetn
);

  reg        [7:0]    _zz_logic_ram_port0;
  wire       [3:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [3:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [3:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [3:0]    logic_pushPtr_valueNext;
  reg        [3:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [3:0]    logic_popPtr_valueNext;
  reg        [3:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1101;
  wire       [3:0]    logic_ptrDif;
  reg [7:0] logic_ram [0:15];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {3'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {3'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= io_push_payload;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0; // @[when.scala 47:16]
    if(logic_pushing) begin
      _zz_1 = 1'b1; // @[when.scala 52:10]
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0; // @[Utils.scala 536:23]
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1; // @[Utils.scala 540:41]
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0; // @[Utils.scala 537:19]
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1; // @[Utils.scala 539:33]
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 4'b1111); // @[BaseType.scala 305:24]
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext); // @[Utils.scala 548:15]
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 4'b0000; // @[Utils.scala 558:15]
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0; // @[Utils.scala 536:23]
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1; // @[Utils.scala 540:41]
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0; // @[Utils.scala 537:19]
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1; // @[Utils.scala 539:33]
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 4'b1111); // @[BaseType.scala 305:24]
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext); // @[Utils.scala 548:15]
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 4'b0000; // @[Utils.scala 558:15]
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value); // @[BaseType.scala 305:24]
  assign logic_pushing = (io_push_valid && io_push_ready); // @[BaseType.scala 305:24]
  assign logic_popping = (io_pop_valid && io_pop_ready); // @[BaseType.scala 305:24]
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy)); // @[BaseType.scala 305:24]
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy); // @[BaseType.scala 305:24]
  assign io_push_ready = (! logic_full); // @[Stream.scala 1097:19]
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full)))); // @[Stream.scala 1098:18]
  assign io_pop_payload = _zz_logic_ram_port0; // @[Stream.scala 1099:20]
  assign when_Stream_l1101 = (logic_pushing != logic_popping); // @[BaseType.scala 305:24]
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value); // @[BaseType.scala 299:24]
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif}; // @[Stream.scala 1114:20]
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability}; // @[Stream.scala 1115:23]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      logic_pushPtr_value <= 4'b0000; // @[Data.scala 400:33]
      logic_popPtr_value <= 4'b0000; // @[Data.scala 400:33]
      logic_risingOccupancy <= 1'b0; // @[Data.scala 400:33]
      _zz_io_pop_valid <= 1'b0; // @[Data.scala 400:33]
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext; // @[Reg.scala 39:30]
      logic_popPtr_value <= logic_popPtr_valueNext; // @[Reg.scala 39:30]
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value); // @[Reg.scala 39:30]
      if(when_Stream_l1101) begin
        logic_risingOccupancy <= logic_pushing; // @[Stream.scala 1102:23]
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0; // @[Stream.scala 1129:23]
      end
    end
  end


endmodule

module UartCtrl (
  input      [2:0]    io_config_frame_dataLength,
  input      [0:0]    io_config_frame_stop,
  input      [1:0]    io_config_frame_parity,
  input      [19:0]   io_config_clockDivider,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  output              io_uart_txd,
  input               io_uart_rxd,
  output              io_readError,
  input               io_writeBreak,
  output              io_readBreak,
  input               clk,
  input               resetn
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;

  wire                tx_io_write_ready;
  wire                tx_io_txd;
  wire                rx_io_read_valid;
  wire       [7:0]    rx_io_read_payload;
  wire                rx_io_rts;
  wire                rx_io_error;
  wire                rx_io_break;
  reg        [19:0]   clockDivider_counter;
  wire                clockDivider_tick;
  reg                 clockDivider_tickReg;
  reg                 io_write_thrown_valid;
  wire                io_write_thrown_ready;
  wire       [7:0]    io_write_thrown_payload;
  `ifndef SYNTHESIS
  reg [23:0] io_config_frame_stop_string;
  reg [31:0] io_config_frame_parity_string;
  `endif


  UartCtrlTx tx (
    .io_configFrame_dataLength (io_config_frame_dataLength[2:0]), //i
    .io_configFrame_stop       (io_config_frame_stop           ), //i
    .io_configFrame_parity     (io_config_frame_parity[1:0]    ), //i
    .io_samplingTick           (clockDivider_tickReg           ), //i
    .io_write_valid            (io_write_thrown_valid          ), //i
    .io_write_ready            (tx_io_write_ready              ), //o
    .io_write_payload          (io_write_thrown_payload[7:0]   ), //i
    .io_cts                    (1'b0                           ), //i
    .io_txd                    (tx_io_txd                      ), //o
    .io_break                  (io_writeBreak                  ), //i
    .clk                       (clk                            ), //i
    .resetn                    (resetn                         )  //i
  );
  UartCtrlRx rx (
    .io_configFrame_dataLength (io_config_frame_dataLength[2:0]), //i
    .io_configFrame_stop       (io_config_frame_stop           ), //i
    .io_configFrame_parity     (io_config_frame_parity[1:0]    ), //i
    .io_samplingTick           (clockDivider_tickReg           ), //i
    .io_read_valid             (rx_io_read_valid               ), //o
    .io_read_ready             (io_read_ready                  ), //i
    .io_read_payload           (rx_io_read_payload[7:0]        ), //o
    .io_rxd                    (io_uart_rxd                    ), //i
    .io_rts                    (rx_io_rts                      ), //o
    .io_error                  (rx_io_error                    ), //o
    .io_break                  (rx_io_break                    ), //o
    .clk                       (clk                            ), //i
    .resetn                    (resetn                         )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_config_frame_stop)
      UartStopType_ONE : io_config_frame_stop_string = "ONE";
      UartStopType_TWO : io_config_frame_stop_string = "TWO";
      default : io_config_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_config_frame_parity)
      UartParityType_NONE : io_config_frame_parity_string = "NONE";
      UartParityType_EVEN : io_config_frame_parity_string = "EVEN";
      UartParityType_ODD : io_config_frame_parity_string = "ODD ";
      default : io_config_frame_parity_string = "????";
    endcase
  end
  `endif

  assign clockDivider_tick = (clockDivider_counter == 20'h0); // @[BaseType.scala 305:24]
  always @(*) begin
    io_write_thrown_valid = io_write_valid; // @[Stream.scala 294:16]
    if(rx_io_break) begin
      io_write_thrown_valid = 1'b0; // @[Stream.scala 439:18]
    end
  end

  always @(*) begin
    io_write_ready = io_write_thrown_ready; // @[Stream.scala 295:16]
    if(rx_io_break) begin
      io_write_ready = 1'b1; // @[Stream.scala 440:18]
    end
  end

  assign io_write_thrown_payload = io_write_payload; // @[Stream.scala 296:18]
  assign io_write_thrown_ready = tx_io_write_ready; // @[Stream.scala 295:16]
  assign io_read_valid = rx_io_read_valid; // @[Stream.scala 294:16]
  assign io_read_payload = rx_io_read_payload; // @[Stream.scala 296:18]
  assign io_uart_txd = tx_io_txd; // @[UartCtrl.scala 76:15]
  assign io_readError = rx_io_error; // @[UartCtrl.scala 79:16]
  assign io_readBreak = rx_io_break; // @[UartCtrl.scala 82:16]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      clockDivider_counter <= 20'h0; // @[Data.scala 400:33]
      clockDivider_tickReg <= 1'b0; // @[Data.scala 400:33]
    end else begin
      clockDivider_tickReg <= clockDivider_tick; // @[Reg.scala 39:30]
      clockDivider_counter <= (clockDivider_counter - 20'h00001); // @[UartCtrl.scala 61:13]
      if(clockDivider_tick) begin
        clockDivider_counter <= io_config_clockDivider; // @[UartCtrl.scala 63:15]
      end
    end
  end


endmodule

module SimpleBusSlaveController (
  input               io_valid,
  output              io_ready,
  input               io_select,
  input               clk,
  input               resetn
);
  localparam busStateMachine_enumDef_1_BOOT = 2'd0;
  localparam busStateMachine_enumDef_1_idle = 2'd1;
  localparam busStateMachine_enumDef_1_handleRequest = 2'd2;

  wire                busStateMachine_wantExit;
  reg                 busStateMachine_wantStart;
  wire                busStateMachine_wantKill;
  reg                 busStateMachine_readyFlag;
  reg        [1:0]    busStateMachine_stateReg;
  reg        [1:0]    busStateMachine_stateNext;
  reg                 io_valid_regNext;
  wire                when_SimpleBusSlaveController_l22;
  `ifndef SYNTHESIS
  reg [103:0] busStateMachine_stateReg_string;
  reg [103:0] busStateMachine_stateNext_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_1_BOOT : busStateMachine_stateReg_string = "BOOT         ";
      busStateMachine_enumDef_1_idle : busStateMachine_stateReg_string = "idle         ";
      busStateMachine_enumDef_1_handleRequest : busStateMachine_stateReg_string = "handleRequest";
      default : busStateMachine_stateReg_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(busStateMachine_stateNext)
      busStateMachine_enumDef_1_BOOT : busStateMachine_stateNext_string = "BOOT         ";
      busStateMachine_enumDef_1_idle : busStateMachine_stateNext_string = "idle         ";
      busStateMachine_enumDef_1_handleRequest : busStateMachine_stateNext_string = "handleRequest";
      default : busStateMachine_stateNext_string = "?????????????";
    endcase
  end
  `endif

  assign busStateMachine_wantExit = 1'b0; // @[StateMachine.scala 151:28]
  always @(*) begin
    busStateMachine_wantStart = 1'b0; // @[StateMachine.scala 152:19]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_1_idle : begin
      end
      busStateMachine_enumDef_1_handleRequest : begin
      end
      default : begin
        busStateMachine_wantStart = 1'b1; // @[StateMachine.scala 362:15]
      end
    endcase
  end

  assign busStateMachine_wantKill = 1'b0; // @[StateMachine.scala 153:18]
  assign io_ready = busStateMachine_readyFlag; // @[SimpleBusSlaveController.scala 16:14]
  always @(*) begin
    busStateMachine_stateNext = busStateMachine_stateReg; // @[StateMachine.scala 217:17]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_1_idle : begin
        if(when_SimpleBusSlaveController_l22) begin
          busStateMachine_stateNext = busStateMachine_enumDef_1_handleRequest; // @[Enum.scala 148:67]
        end
      end
      busStateMachine_enumDef_1_handleRequest : begin
        busStateMachine_stateNext = busStateMachine_enumDef_1_idle; // @[Enum.scala 148:67]
      end
      default : begin
      end
    endcase
    if(busStateMachine_wantStart) begin
      busStateMachine_stateNext = busStateMachine_enumDef_1_idle; // @[Enum.scala 148:67]
    end
    if(busStateMachine_wantKill) begin
      busStateMachine_stateNext = busStateMachine_enumDef_1_BOOT; // @[Enum.scala 148:67]
    end
  end

  assign when_SimpleBusSlaveController_l22 = (io_select && (io_valid && (! io_valid_regNext))); // @[BaseType.scala 305:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      busStateMachine_readyFlag <= 1'b0; // @[Data.scala 400:33]
      busStateMachine_stateReg <= busStateMachine_enumDef_1_BOOT; // @[Data.scala 400:33]
    end else begin
      busStateMachine_stateReg <= busStateMachine_stateNext; // @[StateMachine.scala 212:14]
      case(busStateMachine_stateReg)
        busStateMachine_enumDef_1_idle : begin
          if(when_SimpleBusSlaveController_l22) begin
            busStateMachine_readyFlag <= 1'b1; // @[SimpleBusSlaveController.scala 23:21]
          end
        end
        busStateMachine_enumDef_1_handleRequest : begin
          busStateMachine_readyFlag <= 1'b0; // @[SimpleBusSlaveController.scala 32:19]
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clk) begin
    io_valid_regNext <= io_valid; // @[Reg.scala 39:30]
  end


endmodule

module GCDTop (
  input               io_valid,
  output              io_ready,
  input      [31:0]   io_a,
  input      [31:0]   io_b,
  output     [31:0]   io_res,
  input               clk,
  input               resetn
);

  wire                gcdCtr_io_ready;
  wire                gcdCtr_io_dataCtrl_loadA;
  wire                gcdCtr_io_dataCtrl_loadB;
  wire                gcdCtr_io_dataCtrl_selL;
  wire                gcdCtr_io_dataCtrl_selR;
  wire                gcdCtr_io_dataCtrl_init;
  wire       [31:0]   gcdDat_io_res;
  wire                gcdDat_io_dataCtrl_cmpAgtB;
  wire                gcdDat_io_dataCtrl_cmpAltB;

  GCDCtrl gcdCtr (
    .io_valid            (io_valid                  ), //i
    .io_ready            (gcdCtr_io_ready           ), //o
    .io_dataCtrl_cmpAgtB (gcdDat_io_dataCtrl_cmpAgtB), //i
    .io_dataCtrl_cmpAltB (gcdDat_io_dataCtrl_cmpAltB), //i
    .io_dataCtrl_loadA   (gcdCtr_io_dataCtrl_loadA  ), //o
    .io_dataCtrl_loadB   (gcdCtr_io_dataCtrl_loadB  ), //o
    .io_dataCtrl_init    (gcdCtr_io_dataCtrl_init   ), //o
    .io_dataCtrl_selL    (gcdCtr_io_dataCtrl_selL   ), //o
    .io_dataCtrl_selR    (gcdCtr_io_dataCtrl_selR   ), //o
    .clk                 (clk                       ), //i
    .resetn              (resetn                    )  //i
  );
  GCDData gcdDat (
    .io_a                (io_a[31:0]                ), //i
    .io_b                (io_b[31:0]                ), //i
    .io_res              (gcdDat_io_res[31:0]       ), //o
    .io_dataCtrl_cmpAgtB (gcdDat_io_dataCtrl_cmpAgtB), //o
    .io_dataCtrl_cmpAltB (gcdDat_io_dataCtrl_cmpAltB), //o
    .io_dataCtrl_loadA   (gcdCtr_io_dataCtrl_loadA  ), //i
    .io_dataCtrl_loadB   (gcdCtr_io_dataCtrl_loadB  ), //i
    .io_dataCtrl_init    (gcdCtr_io_dataCtrl_init   ), //i
    .io_dataCtrl_selL    (gcdCtr_io_dataCtrl_selL   ), //i
    .io_dataCtrl_selR    (gcdCtr_io_dataCtrl_selR   ), //i
    .clk                 (clk                       ), //i
    .resetn              (resetn                    )  //i
  );
  assign io_ready = gcdCtr_io_ready; // @[GCDTop.scala 34:12]
  assign io_res = gcdDat_io_res; // @[GCDTop.scala 38:10]

endmodule

module SimpleBusMasterController (
  input               io_ctrl_enable,
  input               io_ctrl_write,
  output              io_ctrl_busy,
  output reg          io_bus_valid,
  input               io_bus_ready,
  output reg          io_bus_write,
  input               io_bus_unmapped,
  input               clk,
  input               resetn
);
  localparam busStateMachine_enumDef_BOOT = 2'd0;
  localparam busStateMachine_enumDef_idle = 2'd1;
  localparam busStateMachine_enumDef_sendRequest = 2'd2;
  localparam busStateMachine_enumDef_waitResponse = 2'd3;

  wire                busStateMachine_wantExit;
  reg                 busStateMachine_wantStart;
  wire                busStateMachine_wantKill;
  reg                 busStateMachine_busyFlag;
  reg        [1:0]    busStateMachine_stateReg;
  reg        [1:0]    busStateMachine_stateNext;
  wire                when_SimpleBusMasterController_l50;
  wire                when_StateMachine_l237;
  wire                when_StateMachine_l237_1;
  `ifndef SYNTHESIS
  reg [95:0] busStateMachine_stateReg_string;
  reg [95:0] busStateMachine_stateNext_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_BOOT : busStateMachine_stateReg_string = "BOOT        ";
      busStateMachine_enumDef_idle : busStateMachine_stateReg_string = "idle        ";
      busStateMachine_enumDef_sendRequest : busStateMachine_stateReg_string = "sendRequest ";
      busStateMachine_enumDef_waitResponse : busStateMachine_stateReg_string = "waitResponse";
      default : busStateMachine_stateReg_string = "????????????";
    endcase
  end
  always @(*) begin
    case(busStateMachine_stateNext)
      busStateMachine_enumDef_BOOT : busStateMachine_stateNext_string = "BOOT        ";
      busStateMachine_enumDef_idle : busStateMachine_stateNext_string = "idle        ";
      busStateMachine_enumDef_sendRequest : busStateMachine_stateNext_string = "sendRequest ";
      busStateMachine_enumDef_waitResponse : busStateMachine_stateNext_string = "waitResponse";
      default : busStateMachine_stateNext_string = "????????????";
    endcase
  end
  `endif

  assign busStateMachine_wantExit = 1'b0; // @[StateMachine.scala 151:28]
  always @(*) begin
    busStateMachine_wantStart = 1'b0; // @[StateMachine.scala 152:19]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_idle : begin
      end
      busStateMachine_enumDef_sendRequest : begin
      end
      busStateMachine_enumDef_waitResponse : begin
      end
      default : begin
        busStateMachine_wantStart = 1'b1; // @[StateMachine.scala 362:15]
      end
    endcase
  end

  assign busStateMachine_wantKill = 1'b0; // @[StateMachine.scala 153:18]
  always @(*) begin
    io_bus_valid = 1'b0; // @[SimpleBusMasterController.scala 24:18]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_idle : begin
      end
      busStateMachine_enumDef_sendRequest : begin
        io_bus_valid = 1'b1; // @[SimpleBusMasterController.scala 41:22]
      end
      busStateMachine_enumDef_waitResponse : begin
        io_bus_valid = 1'b1; // @[SimpleBusMasterController.scala 49:22]
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_bus_write = 1'b0; // @[SimpleBusMasterController.scala 25:18]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_idle : begin
      end
      busStateMachine_enumDef_sendRequest : begin
        io_bus_write = io_ctrl_write; // @[SimpleBusMasterController.scala 42:22]
      end
      busStateMachine_enumDef_waitResponse : begin
      end
      default : begin
      end
    endcase
  end

  assign io_ctrl_busy = busStateMachine_busyFlag; // @[SimpleBusMasterController.scala 59:16]
  always @(*) begin
    busStateMachine_stateNext = busStateMachine_stateReg; // @[StateMachine.scala 217:17]
    case(busStateMachine_stateReg)
      busStateMachine_enumDef_idle : begin
        if(io_ctrl_enable) begin
          busStateMachine_stateNext = busStateMachine_enumDef_sendRequest; // @[Enum.scala 148:67]
        end
      end
      busStateMachine_enumDef_sendRequest : begin
        busStateMachine_stateNext = busStateMachine_enumDef_waitResponse; // @[Enum.scala 148:67]
      end
      busStateMachine_enumDef_waitResponse : begin
        if(when_SimpleBusMasterController_l50) begin
          busStateMachine_stateNext = busStateMachine_enumDef_idle; // @[Enum.scala 148:67]
        end
      end
      default : begin
      end
    endcase
    if(busStateMachine_wantStart) begin
      busStateMachine_stateNext = busStateMachine_enumDef_idle; // @[Enum.scala 148:67]
    end
    if(busStateMachine_wantKill) begin
      busStateMachine_stateNext = busStateMachine_enumDef_BOOT; // @[Enum.scala 148:67]
    end
  end

  assign when_SimpleBusMasterController_l50 = (io_bus_ready || io_bus_unmapped); // @[BaseType.scala 305:24]
  assign when_StateMachine_l237 = ((busStateMachine_stateReg == busStateMachine_enumDef_idle) && (! (busStateMachine_stateNext == busStateMachine_enumDef_idle))); // @[BaseType.scala 305:24]
  assign when_StateMachine_l237_1 = ((busStateMachine_stateReg == busStateMachine_enumDef_waitResponse) && (! (busStateMachine_stateNext == busStateMachine_enumDef_waitResponse))); // @[BaseType.scala 305:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      busStateMachine_busyFlag <= 1'b0; // @[Data.scala 400:33]
      busStateMachine_stateReg <= busStateMachine_enumDef_BOOT; // @[Data.scala 400:33]
    end else begin
      busStateMachine_stateReg <= busStateMachine_stateNext; // @[StateMachine.scala 212:14]
      if(when_StateMachine_l237) begin
        busStateMachine_busyFlag <= 1'b1; // @[SimpleBusMasterController.scala 34:18]
      end
      if(when_StateMachine_l237_1) begin
        busStateMachine_busyFlag <= 1'b0; // @[SimpleBusMasterController.scala 55:18]
      end
    end
  end


endmodule

module UartCtrlRx (
  input      [2:0]    io_configFrame_dataLength,
  input      [0:0]    io_configFrame_stop,
  input      [1:0]    io_configFrame_parity,
  input               io_samplingTick,
  output              io_read_valid,
  input               io_read_ready,
  output     [7:0]    io_read_payload,
  input               io_rxd,
  output              io_rts,
  output reg          io_error,
  output              io_break,
  input               clk,
  input               resetn
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;
  localparam UartCtrlRxState_IDLE = 3'd0;
  localparam UartCtrlRxState_START = 3'd1;
  localparam UartCtrlRxState_DATA = 3'd2;
  localparam UartCtrlRxState_PARITY = 3'd3;
  localparam UartCtrlRxState_STOP = 3'd4;

  wire                io_rxd_buffercc_io_dataOut;
  wire                _zz_sampler_value;
  wire                _zz_sampler_value_1;
  wire                _zz_sampler_value_2;
  wire                _zz_sampler_value_3;
  wire                _zz_sampler_value_4;
  wire                _zz_sampler_value_5;
  wire                _zz_sampler_value_6;
  wire       [2:0]    _zz_when_UartCtrlRx_l139;
  wire       [0:0]    _zz_when_UartCtrlRx_l139_1;
  reg                 _zz_io_rts;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_samples_3;
  reg                 sampler_samples_4;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  wire                when_UartCtrlRx_l43;
  reg        [2:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  wire                when_UartCtrlRx_l69;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg        [7:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  wire                when_UartCtrlRx_l93;
  wire                when_UartCtrlRx_l103;
  wire                when_UartCtrlRx_l111;
  wire                when_UartCtrlRx_l113;
  wire                when_UartCtrlRx_l125;
  wire                when_UartCtrlRx_l136;
  wire                when_UartCtrlRx_l139;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_when_UartCtrlRx_l139_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlRx_l139 = {2'd0, _zz_when_UartCtrlRx_l139_1};
  assign _zz_sampler_value = ((((1'b0 || ((_zz_sampler_value_1 && sampler_samples_1) && sampler_samples_2)) || (((_zz_sampler_value_2 && sampler_samples_0) && sampler_samples_1) && sampler_samples_3)) || (((1'b1 && sampler_samples_0) && sampler_samples_2) && sampler_samples_3)) || (((1'b1 && sampler_samples_1) && sampler_samples_2) && sampler_samples_3));
  assign _zz_sampler_value_3 = (((1'b1 && sampler_samples_0) && sampler_samples_1) && sampler_samples_4);
  assign _zz_sampler_value_4 = ((1'b1 && sampler_samples_0) && sampler_samples_2);
  assign _zz_sampler_value_5 = (1'b1 && sampler_samples_1);
  assign _zz_sampler_value_6 = 1'b1;
  assign _zz_sampler_value_1 = (1'b1 && sampler_samples_0);
  assign _zz_sampler_value_2 = 1'b1;
  BufferCC io_rxd_buffercc (
    .io_dataIn  (io_rxd                    ), //i
    .io_dataOut (io_rxd_buffercc_io_dataOut), //o
    .clk        (clk                       ), //i
    .resetn     (resetn                    )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      UartStopType_ONE : io_configFrame_stop_string = "ONE";
      UartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      UartParityType_NONE : io_configFrame_parity_string = "NONE";
      UartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      UartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      UartCtrlRxState_IDLE : stateMachine_state_string = "IDLE  ";
      UartCtrlRxState_START : stateMachine_state_string = "START ";
      UartCtrlRxState_DATA : stateMachine_state_string = "DATA  ";
      UartCtrlRxState_PARITY : stateMachine_state_string = "PARITY";
      UartCtrlRxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    io_error = 1'b0; // @[UartCtrlRx.scala 23:12]
    case(stateMachine_state)
      UartCtrlRxState_IDLE : begin
      end
      UartCtrlRxState_START : begin
      end
      UartCtrlRxState_DATA : begin
      end
      UartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          if(!when_UartCtrlRx_l125) begin
            io_error = 1'b1; // @[UartCtrlRx.scala 130:22]
          end
        end
      end
      default : begin
        if(bitTimer_tick) begin
          if(when_UartCtrlRx_l136) begin
            io_error = 1'b1; // @[UartCtrlRx.scala 137:22]
          end
        end
      end
    endcase
  end

  assign io_rts = _zz_io_rts; // @[UartCtrlRx.scala 24:10]
  assign sampler_synchroniser = io_rxd_buffercc_io_dataOut; // @[CrossClock.scala 13:9]
  assign sampler_samples_0 = sampler_synchroniser; // @[Utils.scala 1115:50]
  always @(*) begin
    bitTimer_tick = 1'b0; // @[UartCtrlRx.scala 40:16]
    if(sampler_tick) begin
      if(when_UartCtrlRx_l43) begin
        bitTimer_tick = 1'b1; // @[UartCtrlRx.scala 44:14]
      end
    end
  end

  assign when_UartCtrlRx_l43 = (bitTimer_counter == 3'b000); // @[BaseType.scala 305:24]
  assign break_valid = (break_counter == 7'h68); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l69 = (io_samplingTick && (! break_valid)); // @[BaseType.scala 305:24]
  assign io_break = break_valid; // @[UartCtrlRx.scala 75:12]
  assign io_read_valid = stateMachine_validReg; // @[UartCtrlRx.scala 84:19]
  assign when_UartCtrlRx_l93 = ((sampler_tick && (! sampler_value)) && (! break_valid)); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l103 = (sampler_value == 1'b1); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l111 = (bitCounter_value == io_configFrame_dataLength); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l113 = (io_configFrame_parity == UartParityType_NONE); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l125 = (stateMachine_parity == sampler_value); // @[BaseType.scala 305:24]
  assign when_UartCtrlRx_l136 = (! sampler_value); // @[BaseType.scala 299:24]
  assign when_UartCtrlRx_l139 = (bitCounter_value == _zz_when_UartCtrlRx_l139); // @[BaseType.scala 305:24]
  assign io_read_payload = stateMachine_shifter; // @[UartCtrlRx.scala 146:19]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      _zz_io_rts <= 1'b0; // @[Data.scala 400:33]
      sampler_samples_1 <= 1'b1; // @[Data.scala 400:33]
      sampler_samples_2 <= 1'b1; // @[Data.scala 400:33]
      sampler_samples_3 <= 1'b1; // @[Data.scala 400:33]
      sampler_samples_4 <= 1'b1; // @[Data.scala 400:33]
      sampler_value <= 1'b1; // @[Data.scala 400:33]
      sampler_tick <= 1'b0; // @[Data.scala 400:33]
      break_counter <= 7'h0; // @[Data.scala 400:33]
      stateMachine_state <= UartCtrlRxState_IDLE; // @[Data.scala 400:33]
      stateMachine_validReg <= 1'b0; // @[Data.scala 400:33]
    end else begin
      _zz_io_rts <= (! io_read_ready); // @[Reg.scala 39:30]
      if(io_samplingTick) begin
        sampler_samples_1 <= sampler_samples_0; // @[Utils.scala 1109:24]
      end
      if(io_samplingTick) begin
        sampler_samples_2 <= sampler_samples_1; // @[Utils.scala 1109:24]
      end
      if(io_samplingTick) begin
        sampler_samples_3 <= sampler_samples_2; // @[Utils.scala 1109:24]
      end
      if(io_samplingTick) begin
        sampler_samples_4 <= sampler_samples_3; // @[Utils.scala 1109:24]
      end
      sampler_value <= ((((((_zz_sampler_value || _zz_sampler_value_3) || (_zz_sampler_value_4 && sampler_samples_4)) || ((_zz_sampler_value_5 && sampler_samples_2) && sampler_samples_4)) || (((_zz_sampler_value_6 && sampler_samples_0) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_1) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_2) && sampler_samples_3) && sampler_samples_4)); // @[Reg.scala 39:30]
      sampler_tick <= io_samplingTick; // @[Reg.scala 39:30]
      if(sampler_value) begin
        break_counter <= 7'h0; // @[UartCtrlRx.scala 67:15]
      end else begin
        if(when_UartCtrlRx_l69) begin
          break_counter <= (break_counter + 7'h01); // @[UartCtrlRx.scala 70:17]
        end
      end
      stateMachine_validReg <= 1'b0; // @[Reg.scala 39:30]
      case(stateMachine_state)
        UartCtrlRxState_IDLE : begin
          if(when_UartCtrlRx_l93) begin
            stateMachine_state <= UartCtrlRxState_START; // @[Enum.scala 148:67]
          end
        end
        UartCtrlRxState_START : begin
          if(bitTimer_tick) begin
            stateMachine_state <= UartCtrlRxState_DATA; // @[Enum.scala 148:67]
            if(when_UartCtrlRx_l103) begin
              stateMachine_state <= UartCtrlRxState_IDLE; // @[Enum.scala 148:67]
            end
          end
        end
        UartCtrlRxState_DATA : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l111) begin
              if(when_UartCtrlRx_l113) begin
                stateMachine_state <= UartCtrlRxState_STOP; // @[Enum.scala 148:67]
                stateMachine_validReg <= 1'b1; // @[UartCtrlRx.scala 115:24]
              end else begin
                stateMachine_state <= UartCtrlRxState_PARITY; // @[Enum.scala 148:67]
              end
            end
          end
        end
        UartCtrlRxState_PARITY : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l125) begin
              stateMachine_state <= UartCtrlRxState_STOP; // @[Enum.scala 148:67]
              stateMachine_validReg <= 1'b1; // @[UartCtrlRx.scala 127:22]
            end else begin
              stateMachine_state <= UartCtrlRxState_IDLE; // @[Enum.scala 148:67]
            end
          end
        end
        default : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l136) begin
              stateMachine_state <= UartCtrlRxState_IDLE; // @[Enum.scala 148:67]
            end else begin
              if(when_UartCtrlRx_l139) begin
                stateMachine_state <= UartCtrlRxState_IDLE; // @[Enum.scala 148:67]
              end
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(sampler_tick) begin
      bitTimer_counter <= (bitTimer_counter - 3'b001); // @[UartCtrlRx.scala 42:15]
    end
    if(bitTimer_tick) begin
      bitCounter_value <= (bitCounter_value + 3'b001); // @[UartCtrlRx.scala 58:13]
    end
    if(bitTimer_tick) begin
      stateMachine_parity <= (stateMachine_parity ^ sampler_value); // @[UartCtrlRx.scala 88:14]
    end
    case(stateMachine_state)
      UartCtrlRxState_IDLE : begin
        if(when_UartCtrlRx_l93) begin
          bitTimer_counter <= 3'b010; // @[UartCtrlRx.scala 39:27]
        end
      end
      UartCtrlRxState_START : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 3'b000; // @[UartCtrlRx.scala 55:25]
          stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD); // @[UartCtrlRx.scala 102:18]
        end
      end
      UartCtrlRxState_DATA : begin
        if(bitTimer_tick) begin
          stateMachine_shifter[bitCounter_value] <= sampler_value; // @[UartCtrlRx.scala 110:37]
          if(when_UartCtrlRx_l111) begin
            bitCounter_value <= 3'b000; // @[UartCtrlRx.scala 55:25]
          end
        end
      end
      UartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 3'b000; // @[UartCtrlRx.scala 55:25]
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module UartCtrlTx (
  input      [2:0]    io_configFrame_dataLength,
  input      [0:0]    io_configFrame_stop,
  input      [1:0]    io_configFrame_parity,
  input               io_samplingTick,
  input               io_write_valid,
  output reg          io_write_ready,
  input      [7:0]    io_write_payload,
  input               io_cts,
  output              io_txd,
  input               io_break,
  input               clk,
  input               resetn
);
  localparam UartStopType_ONE = 1'd0;
  localparam UartStopType_TWO = 1'd1;
  localparam UartParityType_NONE = 2'd0;
  localparam UartParityType_EVEN = 2'd1;
  localparam UartParityType_ODD = 2'd2;
  localparam UartCtrlTxState_IDLE = 3'd0;
  localparam UartCtrlTxState_START = 3'd1;
  localparam UartCtrlTxState_DATA = 3'd2;
  localparam UartCtrlTxState_PARITY = 3'd3;
  localparam UartCtrlTxState_STOP = 3'd4;

  wire       [2:0]    _zz_clockDivider_counter_valueNext;
  wire       [0:0]    _zz_clockDivider_counter_valueNext_1;
  wire       [2:0]    _zz_when_UartCtrlTx_l93;
  wire       [0:0]    _zz_when_UartCtrlTx_l93_1;
  reg                 clockDivider_counter_willIncrement;
  wire                clockDivider_counter_willClear;
  reg        [2:0]    clockDivider_counter_valueNext;
  reg        [2:0]    clockDivider_counter_value;
  wire                clockDivider_counter_willOverflowIfInc;
  wire                clockDivider_counter_willOverflow;
  reg        [2:0]    tickCounter_value;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg                 stateMachine_txd;
  wire                when_UartCtrlTx_l58;
  wire                when_UartCtrlTx_l73;
  wire                when_UartCtrlTx_l76;
  wire                when_UartCtrlTx_l93;
  wire       [2:0]    _zz_stateMachine_state;
  reg                 _zz_io_txd;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  reg [47:0] _zz_stateMachine_state_string;
  `endif


  assign _zz_clockDivider_counter_valueNext_1 = clockDivider_counter_willIncrement;
  assign _zz_clockDivider_counter_valueNext = {2'd0, _zz_clockDivider_counter_valueNext_1};
  assign _zz_when_UartCtrlTx_l93_1 = ((io_configFrame_stop == UartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlTx_l93 = {2'd0, _zz_when_UartCtrlTx_l93_1};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      UartStopType_ONE : io_configFrame_stop_string = "ONE";
      UartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      UartParityType_NONE : io_configFrame_parity_string = "NONE";
      UartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      UartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      UartCtrlTxState_IDLE : stateMachine_state_string = "IDLE  ";
      UartCtrlTxState_START : stateMachine_state_string = "START ";
      UartCtrlTxState_DATA : stateMachine_state_string = "DATA  ";
      UartCtrlTxState_PARITY : stateMachine_state_string = "PARITY";
      UartCtrlTxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_stateMachine_state)
      UartCtrlTxState_IDLE : _zz_stateMachine_state_string = "IDLE  ";
      UartCtrlTxState_START : _zz_stateMachine_state_string = "START ";
      UartCtrlTxState_DATA : _zz_stateMachine_state_string = "DATA  ";
      UartCtrlTxState_PARITY : _zz_stateMachine_state_string = "PARITY";
      UartCtrlTxState_STOP : _zz_stateMachine_state_string = "STOP  ";
      default : _zz_stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    clockDivider_counter_willIncrement = 1'b0; // @[Utils.scala 536:23]
    if(io_samplingTick) begin
      clockDivider_counter_willIncrement = 1'b1; // @[Utils.scala 540:41]
    end
  end

  assign clockDivider_counter_willClear = 1'b0; // @[Utils.scala 537:19]
  assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == 3'b111); // @[BaseType.scala 305:24]
  assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement); // @[BaseType.scala 305:24]
  always @(*) begin
    clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_clockDivider_counter_valueNext); // @[Utils.scala 548:15]
    if(clockDivider_counter_willClear) begin
      clockDivider_counter_valueNext = 3'b000; // @[Utils.scala 558:15]
    end
  end

  always @(*) begin
    stateMachine_txd = 1'b1; // @[UartCtrlTx.scala 49:15]
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
        stateMachine_txd = 1'b0; // @[UartCtrlTx.scala 63:13]
      end
      UartCtrlTxState_DATA : begin
        stateMachine_txd = io_write_payload[tickCounter_value]; // @[UartCtrlTx.scala 71:13]
      end
      UartCtrlTxState_PARITY : begin
        stateMachine_txd = stateMachine_parity; // @[UartCtrlTx.scala 85:13]
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_write_ready = io_break; // @[UartCtrlTx.scala 55:20]
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
      end
      UartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            io_write_ready = 1'b1; // @[UartCtrlTx.scala 74:28]
          end
        end
      end
      UartCtrlTxState_PARITY : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UartCtrlTx_l58 = ((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow); // @[BaseType.scala 305:24]
  assign when_UartCtrlTx_l73 = (tickCounter_value == io_configFrame_dataLength); // @[BaseType.scala 305:24]
  assign when_UartCtrlTx_l76 = (io_configFrame_parity == UartParityType_NONE); // @[BaseType.scala 305:24]
  assign when_UartCtrlTx_l93 = (tickCounter_value == _zz_when_UartCtrlTx_l93); // @[BaseType.scala 305:24]
  assign _zz_stateMachine_state = (io_write_valid ? UartCtrlTxState_START : UartCtrlTxState_IDLE); // @[Expression.scala 1420:25]
  assign io_txd = _zz_io_txd; // @[UartCtrlTx.scala 101:10]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      clockDivider_counter_value <= 3'b000; // @[Data.scala 400:33]
      stateMachine_state <= UartCtrlTxState_IDLE; // @[Data.scala 400:33]
      _zz_io_txd <= 1'b1; // @[Data.scala 400:33]
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext; // @[Reg.scala 39:30]
      case(stateMachine_state)
        UartCtrlTxState_IDLE : begin
          if(when_UartCtrlTx_l58) begin
            stateMachine_state <= UartCtrlTxState_START; // @[Enum.scala 148:67]
          end
        end
        UartCtrlTxState_START : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= UartCtrlTxState_DATA; // @[Enum.scala 148:67]
          end
        end
        UartCtrlTxState_DATA : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l73) begin
              if(when_UartCtrlTx_l76) begin
                stateMachine_state <= UartCtrlTxState_STOP; // @[Enum.scala 148:67]
              end else begin
                stateMachine_state <= UartCtrlTxState_PARITY; // @[Enum.scala 148:67]
              end
            end
          end
        end
        UartCtrlTxState_PARITY : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= UartCtrlTxState_STOP; // @[Enum.scala 148:67]
          end
        end
        default : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l93) begin
              stateMachine_state <= _zz_stateMachine_state; // @[UartCtrlTx.scala 94:19]
            end
          end
        end
      endcase
      _zz_io_txd <= (stateMachine_txd && (! io_break)); // @[Reg.scala 39:30]
    end
  end

  always @(posedge clk) begin
    if(clockDivider_counter_willOverflow) begin
      tickCounter_value <= (tickCounter_value + 3'b001); // @[UartCtrlTx.scala 40:13]
    end
    if(clockDivider_counter_willOverflow) begin
      stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd); // @[UartCtrlTx.scala 52:14]
    end
    case(stateMachine_state)
      UartCtrlTxState_IDLE : begin
      end
      UartCtrlTxState_START : begin
        if(clockDivider_counter_willOverflow) begin
          stateMachine_parity <= (io_configFrame_parity == UartParityType_ODD); // @[UartCtrlTx.scala 66:18]
          tickCounter_value <= 3'b000; // @[UartCtrlTx.scala 37:25]
        end
      end
      UartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            tickCounter_value <= 3'b000; // @[UartCtrlTx.scala 37:25]
          end
        end
      end
      UartCtrlTxState_PARITY : begin
        if(clockDivider_counter_willOverflow) begin
          tickCounter_value <= 3'b000; // @[UartCtrlTx.scala 37:25]
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module GCDData (
  input      [31:0]   io_a,
  input      [31:0]   io_b,
  output     [31:0]   io_res,
  output              io_dataCtrl_cmpAgtB,
  output              io_dataCtrl_cmpAltB,
  input               io_dataCtrl_loadA,
  input               io_dataCtrl_loadB,
  input               io_dataCtrl_init,
  input               io_dataCtrl_selL,
  input               io_dataCtrl_selR,
  input               clk,
  input               resetn
);

  reg        [31:0]   regA;
  reg        [31:0]   regB;
  wire                xGTy;
  wire                xLTy;
  wire       [31:0]   chX;
  wire       [31:0]   chY;
  wire       [31:0]   subXY;

  assign xGTy = (regB < regA); // @[BaseType.scala 305:24]
  assign xLTy = (regA < regB); // @[BaseType.scala 305:24]
  assign chX = (io_dataCtrl_selL ? regB : regA); // @[Expression.scala 1420:25]
  assign chY = (io_dataCtrl_selR ? regB : regA); // @[Expression.scala 1420:25]
  assign subXY = (chX - chY); // @[BaseType.scala 299:24]
  assign io_dataCtrl_cmpAgtB = xGTy; // @[GCDData.scala 51:23]
  assign io_dataCtrl_cmpAltB = xLTy; // @[GCDData.scala 52:23]
  assign io_res = regA; // @[GCDData.scala 53:10]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      regA <= 32'h0; // @[Data.scala 400:33]
      regB <= 32'h0; // @[Data.scala 400:33]
    end else begin
      if(io_dataCtrl_init) begin
        regA <= io_a; // @[GCDData.scala 42:10]
        regB <= io_b; // @[GCDData.scala 43:10]
      end
      if(io_dataCtrl_loadA) begin
        regA <= subXY; // @[GCDData.scala 46:10]
      end
      if(io_dataCtrl_loadB) begin
        regB <= subXY; // @[GCDData.scala 49:10]
      end
    end
  end


endmodule

module GCDCtrl (
  input               io_valid,
  output reg          io_ready,
  input               io_dataCtrl_cmpAgtB,
  input               io_dataCtrl_cmpAltB,
  output reg          io_dataCtrl_loadA,
  output reg          io_dataCtrl_loadB,
  output reg          io_dataCtrl_init,
  output reg          io_dataCtrl_selL,
  output reg          io_dataCtrl_selR,
  input               clk,
  input               resetn
);
  localparam fsm_enumDef_BOOT = 3'd0;
  localparam fsm_enumDef_idle = 3'd1;
  localparam fsm_enumDef_calculate = 3'd2;
  localparam fsm_enumDef_calcA = 3'd3;
  localparam fsm_enumDef_calcB = 3'd4;
  localparam fsm_enumDef_calcDone = 3'd5;

  wire                fsm_wantExit;
  reg                 fsm_wantStart;
  wire                fsm_wantKill;
  reg        [2:0]    fsm_stateReg;
  reg        [2:0]    fsm_stateNext;
  wire                when_GCDCtrl_l36;
  `ifndef SYNTHESIS
  reg [71:0] fsm_stateReg_string;
  reg [71:0] fsm_stateNext_string;
  `endif


  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_stateReg)
      fsm_enumDef_BOOT : fsm_stateReg_string = "BOOT     ";
      fsm_enumDef_idle : fsm_stateReg_string = "idle     ";
      fsm_enumDef_calculate : fsm_stateReg_string = "calculate";
      fsm_enumDef_calcA : fsm_stateReg_string = "calcA    ";
      fsm_enumDef_calcB : fsm_stateReg_string = "calcB    ";
      fsm_enumDef_calcDone : fsm_stateReg_string = "calcDone ";
      default : fsm_stateReg_string = "?????????";
    endcase
  end
  always @(*) begin
    case(fsm_stateNext)
      fsm_enumDef_BOOT : fsm_stateNext_string = "BOOT     ";
      fsm_enumDef_idle : fsm_stateNext_string = "idle     ";
      fsm_enumDef_calculate : fsm_stateNext_string = "calculate";
      fsm_enumDef_calcA : fsm_stateNext_string = "calcA    ";
      fsm_enumDef_calcB : fsm_stateNext_string = "calcB    ";
      fsm_enumDef_calcDone : fsm_stateNext_string = "calcDone ";
      default : fsm_stateNext_string = "?????????";
    endcase
  end
  `endif

  assign fsm_wantExit = 1'b0; // @[StateMachine.scala 151:28]
  always @(*) begin
    fsm_wantStart = 1'b0; // @[StateMachine.scala 152:19]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
      end
      fsm_enumDef_calcB : begin
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
        fsm_wantStart = 1'b1; // @[StateMachine.scala 362:15]
      end
    endcase
  end

  assign fsm_wantKill = 1'b0; // @[StateMachine.scala 153:18]
  always @(*) begin
    io_dataCtrl_loadA = 1'b0; // @[GCDCtrl.scala 16:23]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
        io_dataCtrl_loadA = 1'b1; // @[GCDCtrl.scala 44:27]
      end
      fsm_enumDef_calcB : begin
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataCtrl_loadB = 1'b0; // @[GCDCtrl.scala 17:23]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
      end
      fsm_enumDef_calcB : begin
        io_dataCtrl_loadB = 1'b1; // @[GCDCtrl.scala 51:27]
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataCtrl_init = 1'b0; // @[GCDCtrl.scala 18:22]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(io_valid) begin
          io_dataCtrl_init = 1'b1; // @[GCDCtrl.scala 25:28]
        end
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
      end
      fsm_enumDef_calcB : begin
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataCtrl_selL = 1'b0; // @[GCDCtrl.scala 19:22]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
      end
      fsm_enumDef_calcB : begin
        io_dataCtrl_selL = 1'b1; // @[GCDCtrl.scala 50:26]
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_dataCtrl_selR = 1'b0; // @[GCDCtrl.scala 20:22]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
        io_dataCtrl_selR = 1'b1; // @[GCDCtrl.scala 43:26]
      end
      fsm_enumDef_calcB : begin
      end
      fsm_enumDef_calcDone : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_ready = 1'b0; // @[GCDCtrl.scala 21:14]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
      end
      fsm_enumDef_calculate : begin
      end
      fsm_enumDef_calcA : begin
      end
      fsm_enumDef_calcB : begin
      end
      fsm_enumDef_calcDone : begin
        io_ready = 1'b1; // @[GCDCtrl.scala 57:18]
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fsm_stateNext = fsm_stateReg; // @[StateMachine.scala 217:17]
    case(fsm_stateReg)
      fsm_enumDef_idle : begin
        if(io_valid) begin
          fsm_stateNext = fsm_enumDef_calculate; // @[Enum.scala 148:67]
        end
      end
      fsm_enumDef_calculate : begin
        if(io_dataCtrl_cmpAgtB) begin
          fsm_stateNext = fsm_enumDef_calcA; // @[Enum.scala 148:67]
        end else begin
          if(io_dataCtrl_cmpAltB) begin
            fsm_stateNext = fsm_enumDef_calcB; // @[Enum.scala 148:67]
          end else begin
            if(when_GCDCtrl_l36) begin
              fsm_stateNext = fsm_enumDef_calcDone; // @[Enum.scala 148:67]
            end
          end
        end
      end
      fsm_enumDef_calcA : begin
        fsm_stateNext = fsm_enumDef_calculate; // @[Enum.scala 148:67]
      end
      fsm_enumDef_calcB : begin
        fsm_stateNext = fsm_enumDef_calculate; // @[Enum.scala 148:67]
      end
      fsm_enumDef_calcDone : begin
        fsm_stateNext = fsm_enumDef_idle; // @[Enum.scala 148:67]
      end
      default : begin
      end
    endcase
    if(fsm_wantStart) begin
      fsm_stateNext = fsm_enumDef_idle; // @[Enum.scala 148:67]
    end
    if(fsm_wantKill) begin
      fsm_stateNext = fsm_enumDef_BOOT; // @[Enum.scala 148:67]
    end
  end

  assign when_GCDCtrl_l36 = ((! io_dataCtrl_cmpAgtB) && (! io_dataCtrl_cmpAgtB)); // @[BaseType.scala 305:24]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      fsm_stateReg <= fsm_enumDef_BOOT; // @[Data.scala 400:33]
    end else begin
      fsm_stateReg <= fsm_stateNext; // @[StateMachine.scala 212:14]
    end
  end


endmodule

module BufferCC (
  input               io_dataIn,
  output              io_dataOut,
  input               clk,
  input               resetn
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1; // @[CrossClock.scala 38:14]
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      buffers_0 <= 1'b0; // @[Data.scala 400:33]
      buffers_1 <= 1'b0; // @[Data.scala 400:33]
    end else begin
      buffers_0 <= io_dataIn; // @[CrossClock.scala 31:14]
      buffers_1 <= buffers_0; // @[CrossClock.scala 34:16]
    end
  end


endmodule
