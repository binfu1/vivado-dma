`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2022 03:19:19 PM
// Design Name: 
// Module Name: qsfp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cmac1(
  input  wire   init_clk,
  input  wire   gt_ref_clk_p,
  input  wire   gt_ref_clk_n,

  input  [3:0] gt_rxp_in,
  input  [3:0] gt_rxn_in,
  output [3:0] gt_txp_out,
  output [3:0] gt_txn_out,

  input send_continuous_pkts,
  input lbus_tx_rx_restart_in,
  output tx_done_led,
  output tx_busy_led,

  output rx_gt_locked_led,
  output rx_aligned_led,
  output rx_done_led,
  output rx_data_fail_led,
  output rx_busy_led,
  
  input sys_reset,
  input loopback_en
);

wire gt_ref_clk_out;
cmac_usplus_1_exdes cmac_inst(
  .gt_rxp_in(gt_rxp_in),
  .gt_rxn_in(gt_rxn_in),
  .gt_txp_out(gt_txp_out),
  .gt_txn_out(gt_txn_out),

  .send_continuous_pkts(send_continuous_pkts),
  .lbus_tx_rx_restart_in(lbus_tx_rx_restart_in),
  .tx_done_led(tx_done_led),
  .tx_busy_led(tx_busy_led),

  .rx_gt_locked_led(rx_gt_locked_led),
  .rx_aligned_led(rx_aligned_led),
  .rx_done_led(rx_done_led),
  .rx_data_fail_led(rx_data_fail_led),
  .rx_busy_led(rx_busy_led),

  .sys_reset(sys_reset),
  .loopback_en(loopback_en),
  .gt_ref_clk_p(gt_ref_clk_p),
  .gt_ref_clk_n(gt_ref_clk_n),
  .init_clk(init_clk),
  .gt_ref_clk_out(gt_ref_clk_out)
);

wire gt_refclk_update;
wire [31:0] gt_refclk_freq_value;
frequency_counter #(
  .RefClk_Frequency_g   (100000000)
) frequency_counter_inst(
  .i_RefClk_p           (init_clk),
  .i_Clock_p            (gt_ref_clk_out),
  .o_Frequency_Update_p (gt_refclk_update),
  .ov32_Frequency_p     (gt_refclk_freq_value)
);

ila_cmac ila_cmac1(
  .clk(init_clk),
  .probe0(sys_reset),
  .probe1(send_continuous_pkts),
  .probe2(lbus_tx_rx_restart_in),
  .probe3(loopback_en),
  .probe4(rx_gt_locked_led),
  .probe5(rx_aligned_led),
  .probe6(tx_done_led),
  .probe7(rx_done_led),
  .probe8(rx_data_fail_led),
  .probe9(tx_busy_led),
  .probe10(rx_busy_led),
  .probe11(gt_refclk_update),
  .probe12(gt_refclk_freq_value)
);

endmodule
