`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 浪潮信息
// Engineer: 邓子为
//////////////////////////////////////////////////////////////////////////////////

module top_tb;
reg sclk;
reg rst_n;
reg [31:0] gpio;

localparam SIZE_LOOP = 128;

initial begin
  #0 begin sclk = 1; rst_n = 0; gpio <= 0; end
  #40 rst_n = 1;
  #80 gpio <= 32'h0000_0003;
  #20 gpio <= 32'h0000_0001;
end
always #2 sclk = ~sclk;

top #(
  .SIZE_LOOP  (SIZE_LOOP)
  ) top_i (
  .sclk     (sclk),
  .xdma_rstn(rst_n),
  .gpio     (gpio)
);

endmodule