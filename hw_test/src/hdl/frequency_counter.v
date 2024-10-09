//  frequency_counter #(
//      .RefClk_Frequency_g   ( 125000000 )
//  ) frequency_counter_inst (
//      .i_RefClk_p           (axil_aclk            ),
//      .i_Clock_p            (gt_ref_clk_out       ),
//      .o_Frequency_Update_p (gt_refclk_update     ),
//      .ov32_Frequency_p     (gt_refclk_freq_value )
//  );
//
//  ila_refclk_0 ila_freq_cnt_inst (
//  	.clk    (axil_aclk), // input wire clk
//
//  	.probe0 ( gt_refclk_update    ), // input wire [0:0] probe0  
//  	.probe1 ( gt_refclk_freq_value)  // input wire [31:0]  probe1 
//  );

// frequency_counter
module frequency_counter #
(
  parameter RefClk_Frequency_g  = 100000000
)
(
  input   wire          i_RefClk_p,
  input   wire          i_Clock_p,
  output  wire          o_Frequency_Update_p,
  output  reg   [31:0]  ov32_Frequency_p
);

  // RefClk Domain
  wire  [31:0]  One_Second_minus2_c       = RefClk_Frequency_g-2;
  reg           Next_is_1s_s              = 1'b0;
  reg           RefClk_1s_Toggle_s        = 1'b0;
  wire          RefClk_1s_Toggle_Sync_s;
  reg           RefClk_1s_Toggle_Sync_rs  = 1'b0;
  reg   [31:0]  v32_1s_Counter_s          = 32'b0;
  // Computed Frequency Domain
  wire          One_Second_Toggle_Xor_as;
  reg   [31:0]  v32_Frequency_s           = 32'b0;
  reg           o_Frequency_Update_s      = 1'b0;

  // Process to create 1 second toggle bit based on RefClk_Frequency_g
  always @(posedge i_RefClk_p) begin
    if (v32_1s_Counter_s == One_Second_minus2_c) begin
      Next_is_1s_s  <= 1'b1;
    end else begin
      Next_is_1s_s  <= 1'b0;
    end
    if (Next_is_1s_s == 1'b1) begin
      RefClk_1s_Toggle_s <= ~RefClk_1s_Toggle_s;
      v32_1s_Counter_s   <= 32'b0;
    end else begin
      v32_1s_Counter_s   <= v32_1s_Counter_s + 1'b1;
    end
  end

  freq_meta #
  (
    .DW           (1)
  )
  meta_RefClk_1s
  (
    .i_data       (RefClk_1s_Toggle_s),
    .i_oclk       (i_Clock_p),
    .i_orst       (1'b0),
    .o_data_sync  (RefClk_1s_Toggle_Sync_s)
  );

  assign One_Second_Toggle_Xor_as = (RefClk_1s_Toggle_Sync_rs ^ RefClk_1s_Toggle_Sync_s);

  always @(posedge i_Clock_p) begin
    RefClk_1s_Toggle_Sync_rs <=  RefClk_1s_Toggle_Sync_s;
    if (One_Second_Toggle_Xor_as == 1'b1) begin
      o_Frequency_Update_s  <=  ~o_Frequency_Update_s;
      v32_Frequency_s       <=  32'b0;
      ov32_Frequency_p      <=  v32_Frequency_s;
    end else begin
      v32_Frequency_s       <=  v32_Frequency_s + 1'b1;
    end
  end

  assign o_Frequency_Update_p = o_Frequency_Update_s;

endmodule

module freq_meta #
(
  parameter DW     = 4, //% Data Width
  parameter NBPIPE = 3  //% NumBer of PIPEline
)
(
  input  [DW-1:0] i_data,
  input           i_oclk,
  input           i_orst,
  output [DW-1:0] o_data_sync
);

  (* async_reg = "true" *) reg [DW-1:0] data_meta;
  (* async_reg = "true" *) reg [DW-1:0] data[1:NBPIPE-1];
  integer i;

  always @(posedge i_oclk or posedge i_orst) begin
    if (i_orst) begin
      data_meta <= {DW{1'b0}};
      for (i = 1 ; i < NBPIPE ; i = i+1) 
        data[i] <= {DW{1'b0}};
    end else begin // if (i_rst)
      data_meta <= i_data;
      data[1]   <= data_meta;
      for (i = 2 ; i < NBPIPE ; i = i+1) 
        data[i] <= data[i-1];
    end // else: !if(i_rst)
  end

  assign o_data_sync = data[NBPIPE-1];

endmodule // freq_meta
