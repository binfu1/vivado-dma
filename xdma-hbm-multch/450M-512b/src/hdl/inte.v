`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 浪潮信息
// Engineer: 邓子为
//////////////////////////////////////////////////////////////////////////////////

module inte #(
  parameter NUM_GROUP = 4
  ) (
  input                      sclk,
  input                      xdma_rstn,
  input               [31:0] gpio,
  input      [NUM_GROUP-1:0] start_load,
  output reg                 rst_n,
  output reg [NUM_GROUP-1:0] launch,
  output reg                 start_load_all
);

wire user_rstn;
assign user_rstn = gpio[0];
always @(posedge sclk) begin
  if (!user_rstn || !xdma_rstn) begin
    rst_n <= 0;
  end
  else begin
    rst_n <= 1;
  end
end

always @(posedge sclk or negedge rst_n) begin
  if (!rst_n) begin
    launch <= 0;
  end
  else begin
    launch <= {NUM_GROUP{gpio[1]}};
  end
end

// 同步启动信号
integer i;
reg [3:0] start_load_cnt;
always @(posedge sclk or negedge rst_n) begin
  if (!rst_n) begin
    start_load_cnt <= 0;
    start_load_all <= 0;
  end
  else if (start_load_cnt == NUM_GROUP) begin
    start_load_cnt <= 0;
    start_load_all <= 1;
  end
  else begin
    start_load_all <= 0;
    for (i=0; i<NUM_GROUP; i=i+1) begin
      start_load_cnt = start_load_cnt + start_load[i];
    end
  end
end

/*
ila_inte ila_inte_i (
  .clk(sclk),
  .probe0(start_load),
  .probe1(start_load_cnt),
  .probe2(start_load_all),
  .probe3(xdma_rstn),
  .probe4(gpio),
  .probe5(user_rstn),
  .probe6(launch),
  .probe7(load_cnt0),
  .probe8(load_cnt1),
  .probe9(load_cnt2),
  .probe10(load_cnt3),
  .probe11(load_cnt_all)
);
*/
endmodule

