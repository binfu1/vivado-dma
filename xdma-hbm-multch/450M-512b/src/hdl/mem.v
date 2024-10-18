`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 浪潮信息
// Engineer: 邓子为
//////////////////////////////////////////////////////////////////////////////////

module mem #(
  parameter ID_GROUP    = 0,
  parameter LENGTH      = 64,
  parameter SIZE_LOOP   = 64,
  parameter SIZE_GROUP  = 64,
  parameter DWIDTH_BRAM = 64,
  parameter AWIDTH_BRAM = 10
  ) (
  input                    sclk,
  input                    rst_n,
  input                    flag0,
  input                    flag1,
   
  input   [SIZE_GROUP-1:0] wea,
  input  [AWIDTH_BRAM-1:0] addra,
  input  [DWIDTH_BRAM-1:0] dina0,
  input  [DWIDTH_BRAM-1:0] dina1,
  input  [DWIDTH_BRAM-1:0] dina2,
  input  [DWIDTH_BRAM-1:0] dina3,
  input  [DWIDTH_BRAM-1:0] dina4,
  input  [DWIDTH_BRAM-1:0] dina5,
  input  [DWIDTH_BRAM-1:0] dina6,
  input  [DWIDTH_BRAM-1:0] dina7,

  input                    web,
  input  [AWIDTH_BRAM-1:0] addrb,
  input  [DWIDTH_BRAM-1:0] dinb0,
  input  [DWIDTH_BRAM-1:0] dinb1,
  input  [DWIDTH_BRAM-1:0] dinb2,
  input  [DWIDTH_BRAM-1:0] dinb3,
  input  [DWIDTH_BRAM-1:0] dinb4,
  input  [DWIDTH_BRAM-1:0] dinb5,
  input  [DWIDTH_BRAM-1:0] dinb6,
  input  [DWIDTH_BRAM-1:0] dinb7,

  input  [AWIDTH_BRAM-1:0] addrc,
  output [DWIDTH_BRAM-1:0] douta0,
  output [DWIDTH_BRAM-1:0] douta1,
  output [DWIDTH_BRAM-1:0] douta2,
  output [DWIDTH_BRAM-1:0] douta3,
  output [DWIDTH_BRAM-1:0] douta4,
  output [DWIDTH_BRAM-1:0] douta5,
  output [DWIDTH_BRAM-1:0] douta6,
  output [DWIDTH_BRAM-1:0] douta7,

  input  [AWIDTH_BRAM-1:0] addrd,
  output [DWIDTH_BRAM-1:0] doutb0,
  output [DWIDTH_BRAM-1:0] doutb1,
  output [DWIDTH_BRAM-1:0] doutb2,
  output [DWIDTH_BRAM-1:0] doutb3,
  output [DWIDTH_BRAM-1:0] doutb4,
  output [DWIDTH_BRAM-1:0] doutb5,
  output [DWIDTH_BRAM-1:0] doutb6,
  output [DWIDTH_BRAM-1:0] doutb7
);

wire [DWIDTH_BRAM-1:0] dina [SIZE_GROUP-1:0];
assign dina[0]  = dina0;
assign dina[1]  = dina1;
assign dina[2]  = dina2;
assign dina[3]  = dina3;
assign dina[4]  = dina4;
assign dina[5]  = dina5;
assign dina[6]  = dina6;
assign dina[7]  = dina7;

wire [DWIDTH_BRAM-1:0] dinb [SIZE_GROUP-1:0];
assign dinb[0]  = dinb0;
assign dinb[1]  = dinb1;
assign dinb[2]  = dinb2;
assign dinb[3]  = dinb3;
assign dinb[4]  = dinb4;
assign dinb[5]  = dinb5;
assign dinb[6]  = dinb6;
assign dinb[7]  = dinb7;

reg [DWIDTH_BRAM-1:0] douta [SIZE_GROUP-1:0];
assign douta0  = douta[0];
assign douta1  = douta[1];
assign douta2  = douta[2];
assign douta3  = douta[3];
assign douta4  = douta[4];
assign douta5  = douta[5];
assign douta6  = douta[6];
assign douta7  = douta[7];

reg [DWIDTH_BRAM-1:0] doutb [SIZE_GROUP-1:0];
assign doutb0  = doutb[0];
assign doutb1  = doutb[1];
assign doutb2  = doutb[2];
assign doutb3  = doutb[3];
assign doutb4  = doutb[4];
assign doutb5  = doutb[5];
assign doutb6  = doutb[6];
assign doutb7  = doutb[7];

integer i;
localparam DEPTH_BRAM = LENGTH*LENGTH;

reg rstn;
always @(posedge sclk or negedge rst_n) begin
  if (!rst_n) begin
    rstn <= 0;
  end
  else begin
    rstn <= 1;
  end
end

reg state_fft;
always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    state_fft <= 0;
  end
  else if (flag0 || flag1) begin
    state_fft <= !state_fft;
  end
end

reg  [SIZE_GROUP-1:0] we;
reg [AWIDTH_BRAM-1:0] adin [SIZE_GROUP-1:0];
reg [DWIDTH_BRAM-1:0] din  [SIZE_GROUP-1:0];
always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    we <= 0;
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      adin[i] <= 0; din[i] <= 0;
    end
  end
  else if (state_fft) begin
    we <= {we[SIZE_GROUP-2:0], web};
    adin[0] <= addrb; din[0] <= dinb[0];
    for (i=1; i<SIZE_GROUP; i=i+1) begin
      adin[i] <= adin[i-1]; din[i] <= dinb[i];
    end
  end
  else begin
    we <= wea;
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      adin[i] <= addra;
      din[i]  <= dina[i];
    end
  end
end

reg  [AWIDTH_BRAM-1:0] adout [SIZE_GROUP-1:0];
wire [DWIDTH_BRAM-1:0] dout  [SIZE_GROUP-1:0];
always @(posedge sclk or negedge rstn) begin
  if (!rstn) begin
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      adout[i] <= 0;
      douta[i] <= 0; doutb[i] <= 0;
    end
  end
  else if (state_fft) begin
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      adout[i] <= addrd;
      doutb[i] <= dout[i];
    end
  end
  else begin
    for (i=0; i<SIZE_GROUP; i=i+1) begin
      adout[i] <= addrc;
      douta[i] <= dout[i];
    end
  end
end

generate for (genvar m=0; m<SIZE_GROUP; m=m+1) begin
  xpm_memory_sdpram #(
    .ADDR_WIDTH_A           (AWIDTH_BRAM),              
    .ADDR_WIDTH_B           (AWIDTH_BRAM),              
    .AUTO_SLEEP_TIME        (0),           
    .BYTE_WRITE_WIDTH_A     (DWIDTH_BRAM),       
    .CASCADE_HEIGHT         (0),            
    .CLOCKING_MODE          ("common_clock"),
    .ECC_MODE               ("no_ecc"),           
    .MEMORY_INIT_FILE       ("none"),     
    .MEMORY_INIT_PARAM      ("0"),       
    .MEMORY_OPTIMIZATION    ("true"),  
    .MEMORY_PRIMITIVE       ("ultra"),     
    .MEMORY_SIZE            (DEPTH_BRAM*DWIDTH_BRAM),            
    .MESSAGE_CONTROL        (0),           
    .READ_DATA_WIDTH_B      (DWIDTH_BRAM),        
    .READ_LATENCY_B         (2),            
    .READ_RESET_VALUE_B     ("0"),      
    .RST_MODE_A             ("SYNC"),           
    .RST_MODE_B             ("SYNC"),           
    .SIM_ASSERT_CHK         (0),            
    .USE_EMBEDDED_CONSTRAINT(0),   
    .USE_MEM_INIT           (1),              
    .WAKEUP_TIME            ("disable_sleep"), 
    .WRITE_DATA_WIDTH_A     (DWIDTH_BRAM),       
    .WRITE_MODE_B           ("read_first")     
  ) xpm_memory_sdpram_i (
    .clka          (sclk), 
    .wea           (we[m]),
    .ena           (1'b1),  
    .addra         (adin[m]), 
    .dina          (din[m]),
    .clkb          (sclk),
    .enb           (1'b1), 
    .addrb         (adout[m]),  
    .doutb         (dout[m]), 
    .dbiterrb      (),                              
    .sbiterrb      (),            
    .injectdbiterra(1'b0), 
    .injectsbiterra(1'b0), 
    .regceb        (1'b1),
    .rstb          (1'b0),                    
    .sleep         (1'b0)  
  );
end
endgenerate
/*
generate if (ID_GROUP==0 || ID_GROUP==1)
  ila_mem ila_mem_i (
    .clk(sclk),
    .probe0(web_d[0]),
    .probe1(addrb_d[0]),
    .probe2(dinb_1d[0]),
    .probe3(doutb[0])
  );
endgenerate
*/
endmodule