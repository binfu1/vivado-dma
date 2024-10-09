`timescale 1ns / 1ps

module top (
  input         init_clk,
  input         gt0_ref_clk_p,
  input         gt0_ref_clk_n,
  input  [3:0]  gt0_rxp_in,
  input  [3:0]  gt0_rxn_in,
  output [3:0]  gt0_txp_out,
  output [3:0]  gt0_txn_out,
  output        qsfp0_modesel_l,
  output        qsfp0_reset_l,
  output        qsfp0_lpmode,
  output        qsfp0_fs,
  output        qsfp0_oeb,

  input         gt1_ref_clk_p,
  input         gt1_ref_clk_n,
  input  [3:0]  gt1_rxp_in,
  input  [3:0]  gt1_rxn_in,
  output [3:0]  gt1_txp_out,
  output [3:0]  gt1_txn_out,
  output        qsfp1_modesel_l,
  output        qsfp1_reset_l,
  output        qsfp1_lpmode,
  output        qsfp1_fs,
  output        qsfp1_oeb,
 
  input         ddr0_clk_n,
  input         ddr0_clk_p,
  output        ddr0_reset_n,
  output        ddr0_act_n,
  output [16:0] ddr0_adr,
  output [1:0]  ddr0_ba,
  output [0:0]  ddr0_bg,
  output [0:0]  ddr0_ck_c,
  output [0:0]  ddr0_ck_t,
  output [0:0]  ddr0_cke,
  output [1:0]  ddr0_cs_n,
  inout  [8:0]  ddr0_dm_n,
  inout  [71:0] ddr0_dq,
  inout  [8:0]  ddr0_dqs_c,
  inout  [8:0]  ddr0_dqs_t,
  output [0:0]  ddr0_odt,

  input         ddr1_clk_n,
  input         ddr1_clk_p,
  output        ddr1_reset_n,
  output        ddr1_act_n,
  output [16:0] ddr1_adr,
  output [1:0]  ddr1_ba,
  output [0:0]  ddr1_bg,
  output [0:0]  ddr1_ck_c,
  output [0:0]  ddr1_ck_t,
  output [0:0]  ddr1_cke,
  output [0:0]  ddr1_cs_n,
  inout  [8:0]  ddr1_dm_n,
  inout  [71:0] ddr1_dq,
  inout  [8:0]  ddr1_dqs_c,
  inout  [8:0]  ddr1_dqs_t,
  output [0:0]  ddr1_odt,

  input         ddr2_clk_n,
  input         ddr2_clk_p,
  output        ddr2_reset_n,
  output        ddr2_act_n,
  output [16:0] ddr2_adr,
  output [1:0]  ddr2_ba,
  output [0:0]  ddr2_bg,
  output [0:0]  ddr2_ck_c,
  output [0:0]  ddr2_ck_t,
  output [0:0]  ddr2_cke,
  output [0:0]  ddr2_cs_n,
  inout  [8:0]  ddr2_dm_n,
  inout  [71:0] ddr2_dq,
  inout  [8:0]  ddr2_dqs_c,
  inout  [8:0]  ddr2_dqs_t,
  output [0:0]  ddr2_odt,

  input  [0:0]  sys_clk_clk_n,
  input  [0:0]  sys_clk_clk_p,
  input         sys_rstn,
  input  [15:0] pcie_mgt_rxn,
  input  [15:0] pcie_mgt_rxp,
  output [15:0] pcie_mgt_txn,
  output [15:0] pcie_mgt_txp
);

assign qsfp0_lpmode    = 1'b0;
assign qsfp0_reset_l   = 1'b1;
assign qsfp0_modesel_l = 1'b0;
assign qsfp0_fs        = 1'b1;
assign qsfp0_oeb       = 1'b0;
assign qsfp1_lpmode    = 1'b0;
assign qsfp1_reset_l   = 1'b1;
assign qsfp1_modesel_l = 1'b0;
assign qsfp1_fs        = 1'b1;
assign qsfp1_oeb       = 1'b0;

wire [31:0] gpio_i;
wire [31:0] gpio_o;
xdma_wrapper xdma_wrapper_i (
  .ddr0_clk_clk_n(ddr0_clk_n),
  .ddr0_clk_clk_p(ddr0_clk_p),
  .ddr0_reset_n  (ddr0_reset_n),
  .ddr0_act_n    (ddr0_act_n),
  .ddr0_adr      (ddr0_adr),
  .ddr0_ba       (ddr0_ba),
  .ddr0_bg       (ddr0_bg),
  .ddr0_ck_c     (ddr0_ck_c),
  .ddr0_ck_t     (ddr0_ck_t),
  .ddr0_cke      (ddr0_cke),
  .ddr0_cs_n     (ddr0_cs_n),
  .ddr0_dm_n     (ddr0_dm_n),
  .ddr0_dq       (ddr0_dq),
  .ddr0_dqs_c    (ddr0_dqs_c),
  .ddr0_dqs_t    (ddr0_dqs_t),
  .ddr0_odt      (ddr0_odt),

  .ddr1_clk_clk_n(ddr1_clk_n),
  .ddr1_clk_clk_p(ddr1_clk_p),
  .ddr1_reset_n  (ddr1_reset_n),
  .ddr1_act_n    (ddr1_act_n),
  .ddr1_adr      (ddr1_adr),
  .ddr1_ba       (ddr1_ba),
  .ddr1_bg       (ddr1_bg),
  .ddr1_ck_c     (ddr1_ck_c),
  .ddr1_ck_t     (ddr1_ck_t),
  .ddr1_cke      (ddr1_cke),
  .ddr1_cs_n     (ddr1_cs_n),
  .ddr1_dm_n     (ddr1_dm_n),
  .ddr1_dq       (ddr1_dq),
  .ddr1_dqs_c    (ddr1_dqs_c),
  .ddr1_dqs_t    (ddr1_dqs_t),
  .ddr1_odt      (ddr1_odt),

  .ddr2_clk_clk_n(ddr2_clk_n),
  .ddr2_clk_clk_p(ddr2_clk_p),
  .ddr2_reset_n  (ddr2_reset_n),
  .ddr2_act_n    (ddr2_act_n),
  .ddr2_adr      (ddr2_adr),
  .ddr2_ba       (ddr2_ba),
  .ddr2_bg       (ddr2_bg),
  .ddr2_ck_c     (ddr2_ck_c),
  .ddr2_ck_t     (ddr2_ck_t),
  .ddr2_cke      (ddr2_cke),
  .ddr2_cs_n     (ddr2_cs_n),
  .ddr2_dm_n     (ddr2_dm_n),
  .ddr2_dq       (ddr2_dq),
  .ddr2_dqs_c    (ddr2_dqs_c),
  .ddr2_dqs_t    (ddr2_dqs_t),
  .ddr2_odt      (ddr2_odt),

  .sys_clk_clk_n(sys_clk_n),
  .sys_clk_clk_p(sys_clk_p),
  .sys_rstn     (sys_rstn),
  .pcie_mgt_rxn (pcie_mgt_rxn),
  .pcie_mgt_rxp (pcie_mgt_rxp),
  .pcie_mgt_txn (pcie_mgt_txn),
  .pcie_mgt_txp (pcie_mgt_txp),
  .gpio_i_tri_i (gpio_i),
  .gpio_o_tri_o (gpio_o)
);

wire send_continuous_pkts_0;
wire lbus_tx_rx_restart_in_0;
wire tx_done_led_0;
wire tx_busy_led_0;
wire rx_gt_locked_led_0;
wire rx_aligned_led_0;
wire rx_done_led_0;
wire rx_data_fail_led_0;
wire rx_busy_led_0;
wire sys_reset_0;
wire loopback_en_0;

cmac0 cmac0_i (
  .init_clk             (init_clk),
  .gt_ref_clk_p         (gt0_ref_clk_p),
  .gt_ref_clk_n         (gt0_ref_clk_n),
  .gt_rxp_in            (gt0_rxp_in),
  .gt_rxn_in            (gt0_rxn_in),
  .gt_txp_out           (gt0_txp_out),
  .gt_txn_out           (gt0_txn_out),
  .send_continuous_pkts (send_continuous_pkts_0),
  .lbus_tx_rx_restart_in(lbus_tx_rx_restart_in_0),
  .tx_done_led          (tx_done_led_0),
  .tx_busy_led          (tx_busy_led_0),
  .rx_gt_locked_led     (rx_gt_locked_led_0),
  .rx_aligned_led       (rx_aligned_led_0),
  .rx_done_led          (rx_done_led_0),
  .rx_data_fail_led     (rx_data_fail_led_0),
  .rx_busy_led          (rx_busy_led_0),
  .sys_reset            (sys_reset_0),
  .loopback_en          (loopback_en_0)
);
wire [15:0] gpio_i_cmac0;
assign gpio_i_cmac0 = {9'b000000000, rx_busy_led_0, tx_busy_led_0, rx_data_fail_led_0, rx_done_led_0, tx_done_led_0, rx_aligned_led_0, rx_gt_locked_led_0};
assign loopback_en_0           = gpio_o[0];
assign send_continuous_pkts_0  = gpio_o[1];
assign sys_reset_0             = gpio_o[2];
assign lbus_tx_rx_restart_in_0 = gpio_o[3];

wire send_continuous_pkts_1;
wire lbus_tx_rx_restart_in_1;
wire tx_done_led_1;
wire tx_busy_led_1;
wire rx_gt_locked_led_1;
wire rx_aligned_led_1;
wire rx_done_led_1;
wire rx_data_fail_led_1;
wire rx_busy_led_1;
wire sys_reset_1;
wire loopback_en_1;

cmac1 cmac1_i (
  .init_clk             (init_clk),
  .gt_ref_clk_p         (gt1_ref_clk_p),
  .gt_ref_clk_n         (gt1_ref_clk_n),
  .gt_rxp_in            (gt1_rxp_in),
  .gt_rxn_in            (gt1_rxn_in),
  .gt_txp_out           (gt1_txp_out),
  .gt_txn_out           (gt1_txn_out),
  .send_continuous_pkts (send_continuous_pkts_1),
  .lbus_tx_rx_restart_in(lbus_tx_rx_restart_in_1),
  .tx_done_led          (tx_done_led_1),
  .tx_busy_led          (tx_busy_led_1),
  .rx_gt_locked_led     (rx_gt_locked_led_1),
  .rx_aligned_led       (rx_aligned_led_1),
  .rx_done_led          (rx_done_led_1),
  .rx_data_fail_led     (rx_data_fail_led_1),
  .rx_busy_led          (rx_busy_led_1),
  .sys_reset            (sys_reset_1),
  .loopback_en          (loopback_en_1)
);

wire [15:0] gpio_i_cmac1;
assign gpio_i_cmac1 = {9'b000000000, rx_busy_led_1, tx_busy_led_1, rx_data_fail_led_1, rx_done_led_1, tx_done_led_1, rx_aligned_led_1, rx_gt_locked_led_1};
assign loopback_en_1           = gpio_o[16];
assign send_continuous_pkts_1  = gpio_o[17];
assign sys_reset_1             = gpio_o[18];
assign lbus_tx_rx_restart_in_1 = gpio_o[19];

assign gpio_i = {gpio_i_cmac1, gpio_i_cmac0};

endmodule
