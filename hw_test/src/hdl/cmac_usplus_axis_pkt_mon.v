 
 
////------------------------------------------------------------------------------
////  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
////
////  This file contains confidential and proprietary information
////  of Xilinx, Inc. and is protected under U.S. and
////  international copyright and other intellectual property
////  laws.
////
////  DISCLAIMER
////  This disclaimer is not a license and does not grant any
////  rights to the materials distributed herewith. Except as
////  otherwise provided in a valid license issued to you by
////  Xilinx, and to the maximum extent permitted by applicable
////  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
////  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
////  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
////  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
////  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
////  (2) Xilinx shall not be liable (whether in contract or tort,
////  including negligence, or under any other theory of
////  liability) for any loss or damage of any kind or nature
////  related to, arising under or in connection with these
////  materials, including for any direct, or any indirect,
////  special, incidental, or consequential loss or damage
////  (including loss of data, profits, goodwill, or any type of
////  loss or damage suffered as a result of any action brought
////  by a third party) even if such damage or loss was
////  reasonably foreseeable or Xilinx had been advised of the
////  possibility of the same.
////
////  CRITICAL APPLICATIONS
////  Xilinx products are not designed or intended to be fail-
////  safe, or for use in any application requiring fail-safe
////  performance, such as life-support or safety devices or
////  systems, Class III medical devices, nuclear facilities,
////  applications related to the deployment of airbags, or any
////  other applications that could lead to death, personal
////  injury, or severe property or environmental damage
////  (individually and collectively, "Critical
////  Applications"). Customer assumes the sole risk and
////  liability of any use of Xilinx products in Critical
////  Applications, subject only to applicable laws and
////  regulations governing limitations on product liability.
////
////  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
////  PART OF THIS FILE AT ALL TIMES.
////------------------------------------------------------------------------------

`timescale 1ps/1ps
(* DowngradeIPIdentifiedWarnings="yes" *)

module cmac_usplus_axis_pkt_mon
   #(
    parameter PKT_NUM      = 1000     //// 1 to 65535 (Number of packets)
   )
   (
    input  wire            clk,
    input  wire            reset,
    input  wire            sys_reset,

    input  wire            send_continuous_pkts,
    input  wire            stat_rx_aligned,
    input  wire            lbus_tx_rx_restart_in,
    output wire            ctl_rx_enable,
    output wire            ctl_rx_force_resync,
    output wire            ctl_rx_test_pattern,
    output wire            ctl_rsfec_ieee_error_indication_mode,
    output wire            ctl_rx_rsfec_enable,
    output wire            ctl_rx_rsfec_enable_correction,
    output wire            ctl_rx_rsfec_enable_indication,
    output wire            rx_reset,                                       //// Used to Reset the CMAC RX Core
    output reg             rx_gt_locked_led,
    output reg             rx_aligned_led,
    output reg             rx_done_led,
    output reg             rx_data_fail_led,
    output reg             rx_busy_led,
    input  wire            stat_rx_aligned_err,
    input  wire [2:0]      stat_rx_bad_code,
    input  wire [2:0]      stat_rx_bad_fcs,
    input  wire            stat_rx_bad_preamble,
    input  wire            stat_rx_bad_sfd,
    input  wire            stat_rx_bip_err_0,
    input  wire            stat_rx_bip_err_1,
    input  wire            stat_rx_bip_err_10,
    input  wire            stat_rx_bip_err_11,
    input  wire            stat_rx_bip_err_12,
    input  wire            stat_rx_bip_err_13,
    input  wire            stat_rx_bip_err_14,
    input  wire            stat_rx_bip_err_15,
    input  wire            stat_rx_bip_err_16,
    input  wire            stat_rx_bip_err_17,
    input  wire            stat_rx_bip_err_18,
    input  wire            stat_rx_bip_err_19,
    input  wire            stat_rx_bip_err_2,
    input  wire            stat_rx_bip_err_3,
    input  wire            stat_rx_bip_err_4,
    input  wire            stat_rx_bip_err_5,
    input  wire            stat_rx_bip_err_6,
    input  wire            stat_rx_bip_err_7,
    input  wire            stat_rx_bip_err_8,
    input  wire            stat_rx_bip_err_9,
    input  wire [19:0]     stat_rx_block_lock,
    input  wire            stat_rx_broadcast,
    input  wire [2:0]      stat_rx_fragment,
    input  wire [1:0]      stat_rx_framing_err_0,
    input  wire [1:0]      stat_rx_framing_err_1,
    input  wire [1:0]      stat_rx_framing_err_10,
    input  wire [1:0]      stat_rx_framing_err_11,
    input  wire [1:0]      stat_rx_framing_err_12,
    input  wire [1:0]      stat_rx_framing_err_13,
    input  wire [1:0]      stat_rx_framing_err_14,
    input  wire [1:0]      stat_rx_framing_err_15,
    input  wire [1:0]      stat_rx_framing_err_16,
    input  wire [1:0]      stat_rx_framing_err_17,
    input  wire [1:0]      stat_rx_framing_err_18,
    input  wire [1:0]      stat_rx_framing_err_19,
    input  wire [1:0]      stat_rx_framing_err_2,
    input  wire [1:0]      stat_rx_framing_err_3,
    input  wire [1:0]      stat_rx_framing_err_4,
    input  wire [1:0]      stat_rx_framing_err_5,
    input  wire [1:0]      stat_rx_framing_err_6,
    input  wire [1:0]      stat_rx_framing_err_7,
    input  wire [1:0]      stat_rx_framing_err_8,
    input  wire [1:0]      stat_rx_framing_err_9,
    input  wire            stat_rx_framing_err_valid_0,
    input  wire            stat_rx_framing_err_valid_1,
    input  wire            stat_rx_framing_err_valid_10,
    input  wire            stat_rx_framing_err_valid_11,
    input  wire            stat_rx_framing_err_valid_12,
    input  wire            stat_rx_framing_err_valid_13,
    input  wire            stat_rx_framing_err_valid_14,
    input  wire            stat_rx_framing_err_valid_15,
    input  wire            stat_rx_framing_err_valid_16,
    input  wire            stat_rx_framing_err_valid_17,
    input  wire            stat_rx_framing_err_valid_18,
    input  wire            stat_rx_framing_err_valid_19,
    input  wire            stat_rx_framing_err_valid_2,
    input  wire            stat_rx_framing_err_valid_3,
    input  wire            stat_rx_framing_err_valid_4,
    input  wire            stat_rx_framing_err_valid_5,
    input  wire            stat_rx_framing_err_valid_6,
    input  wire            stat_rx_framing_err_valid_7,
    input  wire            stat_rx_framing_err_valid_8,
    input  wire            stat_rx_framing_err_valid_9,
    input  wire            stat_rx_got_signal_os,
    input  wire            stat_rx_hi_ber,
    input  wire            stat_rx_inrangeerr,
    input  wire            stat_rx_internal_local_fault,
    input  wire            stat_rx_jabber,
    input  wire            stat_rx_local_fault,
    input  wire [19:0]     stat_rx_mf_err,
    input  wire [19:0]     stat_rx_mf_len_err,
    input  wire [19:0]     stat_rx_mf_repeat_err,
    input  wire            stat_rx_misaligned,
    input  wire            stat_rx_multicast,
    input  wire            stat_rx_oversize,
    input  wire            stat_rx_packet_1024_1518_bytes,
    input  wire            stat_rx_packet_128_255_bytes,
    input  wire            stat_rx_packet_1519_1522_bytes,
    input  wire            stat_rx_packet_1523_1548_bytes,
    input  wire            stat_rx_packet_1549_2047_bytes,
    input  wire            stat_rx_packet_2048_4095_bytes,
    input  wire            stat_rx_packet_256_511_bytes,
    input  wire            stat_rx_packet_4096_8191_bytes,
    input  wire            stat_rx_packet_512_1023_bytes,
    input  wire            stat_rx_packet_64_bytes,
    input  wire            stat_rx_packet_65_127_bytes,
    input  wire            stat_rx_packet_8192_9215_bytes,
    input  wire            stat_rx_packet_bad_fcs,
    input  wire            stat_rx_packet_large,
    input  wire [2:0]      stat_rx_packet_small,
    input  wire            stat_rx_received_local_fault,
    input  wire            stat_rx_remote_fault,
    input  wire            stat_rx_status,
    input  wire [2:0]      stat_rx_stomped_fcs,
    input  wire [19:0]     stat_rx_synced,
    input  wire [19:0]     stat_rx_synced_err,
    input  wire [2:0]      stat_rx_test_pattern_mismatch,
    input  wire            stat_rx_toolong,
    input  wire [6:0]      stat_rx_total_bytes,
    input  wire [13:0]     stat_rx_total_good_bytes,
    input  wire            stat_rx_total_good_packets,
    input  wire [2:0]      stat_rx_total_packets,
    input  wire            stat_rx_truncated,
    input  wire [2:0]      stat_rx_undersize,
    input  wire            stat_rx_unicast,
    input  wire            stat_rx_vlan,
    input  wire [19:0]     stat_rx_pcsl_demuxed,
    input  wire [4:0]      stat_rx_pcsl_number_0,
    input  wire [4:0]      stat_rx_pcsl_number_1,
    input  wire [4:0]      stat_rx_pcsl_number_10,
    input  wire [4:0]      stat_rx_pcsl_number_11,
    input  wire [4:0]      stat_rx_pcsl_number_12,
    input  wire [4:0]      stat_rx_pcsl_number_13,
    input  wire [4:0]      stat_rx_pcsl_number_14,
    input  wire [4:0]      stat_rx_pcsl_number_15,
    input  wire [4:0]      stat_rx_pcsl_number_16,
    input  wire [4:0]      stat_rx_pcsl_number_17,
    input  wire [4:0]      stat_rx_pcsl_number_18,
    input  wire [4:0]      stat_rx_pcsl_number_19,
    input  wire [4:0]      stat_rx_pcsl_number_2,
    input  wire [4:0]      stat_rx_pcsl_number_3,
    input  wire [4:0]      stat_rx_pcsl_number_4,
    input  wire [4:0]      stat_rx_pcsl_number_5,
    input  wire [4:0]      stat_rx_pcsl_number_6,
    input  wire [4:0]      stat_rx_pcsl_number_7,
    input  wire [4:0]      stat_rx_pcsl_number_8,
    input  wire [4:0]      stat_rx_pcsl_number_9,
    input  wire            stat_rx_rsfec_am_lock0,
    input  wire            stat_rx_rsfec_am_lock1,
    input  wire            stat_rx_rsfec_am_lock2,
    input  wire            stat_rx_rsfec_am_lock3,
    input  wire            stat_rx_rsfec_corrected_cw_inc,
    input  wire            stat_rx_rsfec_cw_inc,
    input  wire [2:0]      stat_rx_rsfec_err_count0_inc,
    input  wire [2:0]      stat_rx_rsfec_err_count1_inc,
    input  wire [2:0]      stat_rx_rsfec_err_count2_inc,
    input  wire [2:0]      stat_rx_rsfec_err_count3_inc,
    input  wire            stat_rx_rsfec_hi_ser,
    input  wire            stat_rx_rsfec_lane_alignment_status,
    input  wire [13:0]     stat_rx_rsfec_lane_fill_0,
    input  wire [13:0]     stat_rx_rsfec_lane_fill_1,
    input  wire [13:0]     stat_rx_rsfec_lane_fill_2,
    input  wire [13:0]     stat_rx_rsfec_lane_fill_3,
    input  wire [7:0]      stat_rx_rsfec_lane_mapping,
    input  wire            stat_rx_rsfec_uncorrected_cw_inc,

    input  wire [55:0]     rx_preambleout,
    input  wire            rx_axis_tvalid,
    input  wire [511:0]    rx_axis_tdata,
    input  wire            rx_axis_tlast,
    input  wire [63:0]     rx_axis_tkeep,
    input  wire            rx_axis_tuser
  );

  //// Parameters Decleration

  //// pkt_mon States
    localparam STATE_RX_IDLE             = 0;
    localparam STATE_GT_LOCKED           = 1;
    localparam STATE_WAIT_RX_ALIGNED     = 2;
    localparam STATE_PKT_TRANSFER_INIT   = 3;
    localparam STATE_LBUS_RX_ENABLE      = 4;
    localparam STATE_LBUS_RX_DONE        = 5;
    localparam STATE_WAIT_FOR_RESTART    = 6;

  ////State Registers for RX
    reg  [3:0]     rx_prestate;
    reg  [512-1:0] rcv_datain, rcv_data, rcv_data_cmp;
    reg  [512-1:0] exp_datain, exp_data, exp_data_cmp;
    reg  [512-1:0] rx_axis_tdata_d;
    reg            rx_axis_tvalid_d;
    reg            rx_axis_tlast_d;
    reg  [64-1:0]  rx_axis_tkeep_d;
    reg            rx_axis_tuser_d;

    reg            rx_restart_rise_edge, rx_fsm_en, rx_done_reg, rx_data_fail, wait_to_restart;
    reg            rx_restart_1d, rx_restart_2d, rx_restart_3d, rx_restart_4d ;
    reg            check_seg;
    reg  [64-1:0]  valid_bytes;
    reg  [512-1:0] rx_payload_16byte, rx_payload_16byte_new;
    reg  [ 7:0]    rx_payload_1, rx_payload_2, rx_payload_new;
    reg            rx_data_chk_fail, byte_cmp_fail;
    reg  [15:0]    number_pkt_rx;

    reg  [15:0]    lbus_number_pkt_proc;
    reg            stat_rx_aligned_1d, reset_done;
    reg            ctl_rx_enable_r, ctl_rx_force_resync_r, ctl_rx_test_pattern_r; 
    reg            ctl_rsfec_ieee_error_indication_mode_r;
    reg            ctl_rx_rsfec_enable_r;
    reg            ctl_rx_rsfec_enable_correction_r;
    reg            ctl_rx_rsfec_enable_indication_r;
    reg            gt_lock_led, rx_aligned_led_c, rx_core_busy_led;
    reg            rx_gt_locked_led_1d, stat_rx_aligned_led_1d, rx_done_led_1d, rx_data_fail_led_1d, rx_core_busy_led_1d;
    reg            rx_gt_locked_led_2d, stat_rx_aligned_led_2d, rx_done_led_2d, rx_data_fail_led_2d, rx_core_busy_led_2d;
    reg            rx_gt_locked_led_3d, stat_rx_aligned_led_3d, rx_done_led_3d, rx_data_fail_led_3d, rx_core_busy_led_3d;
    reg  [8:0]     init_cntr;
    reg            init_done;
    reg            init_cntr_en;
    reg            send_continuous_pkts_1d, send_continuous_pkts_2d, send_continuous_pkts_3d;


    ////----------------------------------------RX Module -----------------------//
    //////////////////////////////////////////////////
    ////registering input signal generation
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            reset_done             <= 1'b0;
            stat_rx_aligned_1d     <= 1'b0;
            rx_restart_1d          <= 1'b0;
            rx_restart_2d          <= 1'b0;
            rx_restart_3d          <= 1'b0;
            rx_restart_4d          <= 1'b0;
        end
        else
        begin
            reset_done             <= 1'b1;
            stat_rx_aligned_1d     <= stat_rx_aligned;
            rx_restart_1d          <= lbus_tx_rx_restart_in;
            rx_restart_2d          <= rx_restart_1d;
            rx_restart_3d          <= rx_restart_2d;
            rx_restart_4d          <= rx_restart_3d;
        end
    end

    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_axis_tdata_d  <= 0;
            rx_axis_tvalid_d <= 0;
            rx_axis_tlast_d  <= 0;
            rx_axis_tkeep_d  <= 0;
            rx_axis_tuser_d  <= 0;
        end
        else
        begin
            if (wait_to_restart == 1'b1)
            begin
               rx_axis_tdata_d  <= 0;
               rx_axis_tvalid_d <= 0;
               rx_axis_tlast_d  <= 0;
               rx_axis_tkeep_d  <= 0;
               rx_axis_tuser_d  <= 0;
            end
            else
            begin
               rx_axis_tdata_d  <= rx_axis_tdata;
               rx_axis_tvalid_d <= rx_axis_tvalid;
               rx_axis_tlast_d  <= rx_axis_tlast;
               rx_axis_tkeep_d  <= rx_axis_tkeep;
               rx_axis_tuser_d  <= rx_axis_tuser;
            end
        end
    end

    //////////////////////////////////////////////////
    ////generating the rx_restart_rise_edge signal 
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if  ( reset == 1'b1 )
            rx_restart_rise_edge  <= 1'b0; 
        else
        begin
            if  (( rx_restart_3d == 1'b1) && ( rx_restart_4d == 1'b0))
                rx_restart_rise_edge  <= 1'b1;
            else
                rx_restart_rise_edge  <= 1'b0;
        end
    end    

    //////////////////////////////////////////////////
    ////RX State Machine
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_prestate            <= STATE_RX_IDLE;
            rcv_data               <= 512'd0;
            rcv_datain             <= 512'd0;
            exp_data               <= 512'd0;
            exp_datain             <= 512'd0;
            rx_payload_16byte      <= 512'd0;
            rx_payload_16byte_new  <= 512'd0;
            check_seg              <= 1'b0;
            valid_bytes            <= 64'd0;
            number_pkt_rx          <= 16'd0;
            lbus_number_pkt_proc   <= 16'd0;
            rx_payload_1           <= 8'd0;
            rx_payload_2           <= 8'd0;
            rx_payload_new         <= 8'd0;
            rx_fsm_en              <= 1'b0;
            gt_lock_led            <= 1'b0;
            rx_aligned_led_c       <= 1'b0;
            rx_core_busy_led       <= 1'b0;
            ctl_rx_enable_r        <= 1'b0;
            ctl_rx_force_resync_r  <= 1'b0;
            ctl_rx_test_pattern_r  <= 1'b0;
            ctl_rsfec_ieee_error_indication_mode_r     <= 1'b0;
            ctl_rx_rsfec_enable_r             <= 1'b0;
            ctl_rx_rsfec_enable_correction_r  <= 1'b0;
            ctl_rx_rsfec_enable_indication_r  <= 1'b0;
            wait_to_restart        <= 1'b0;
            init_cntr_en           <= 1'b0;
            init_done              <= 1'b0;
        end
        else
        begin
            case (rx_prestate)
                STATE_RX_IDLE            :
                                         begin
                                             rcv_data               <= 512'd0;
                                             rcv_datain             <= 512'd0;
                                             exp_data               <= 512'd0;
                                             exp_datain             <= 512'd0;
                                             number_pkt_rx          <= 16'd0;
                                             lbus_number_pkt_proc   <= 16'd0;
                                             check_seg              <= 1'b0;
                                             valid_bytes            <= 64'd0;
                                             rx_fsm_en              <= 1'b0;
                                             gt_lock_led            <= 1'b0;
                                             rx_aligned_led_c       <= 1'b0;
                                             rx_core_busy_led       <= 1'b0;
                                             ctl_rx_enable_r        <= 1'b0;
                                             ctl_rx_force_resync_r  <= 1'b0;
                                             ctl_rx_test_pattern_r  <= 1'b0;
                                             ctl_rsfec_ieee_error_indication_mode_r     <= 1'b0;
                                             ctl_rx_rsfec_enable_r             <= 1'b0;
                                             ctl_rx_rsfec_enable_correction_r  <= 1'b0;
                                             ctl_rx_rsfec_enable_indication_r  <= 1'b0;
                                             wait_to_restart        <= 1'b0;
                                             init_cntr_en           <= 1'b0;
                                             init_done              <= 1'b0;
                                             //// State transition
                                             if  (reset_done == 1'b1)
                                                 rx_prestate <= STATE_GT_LOCKED;
                                             else
                                                 rx_prestate <= STATE_RX_IDLE;
                                         end
                STATE_GT_LOCKED          : 
                                         begin
                                             gt_lock_led            <= 1'b1;
                                             rx_core_busy_led       <= 1'b0;
                                             rx_aligned_led_c       <= 1'b0;
                                             ctl_rx_enable_r        <= 1'b1;
                                             ctl_rx_force_resync_r  <= 1'b0;
                                             ctl_rx_test_pattern_r  <= 1'b0;
                                             ctl_rsfec_ieee_error_indication_mode_r     <= 1'b1;
                                             ctl_rx_rsfec_enable_r             <= 1'b1;
                                             ctl_rx_rsfec_enable_correction_r  <= 1'b1;
                                             ctl_rx_rsfec_enable_indication_r  <= 1'b1;

                                             //// State transition
                                             rx_prestate <= STATE_WAIT_RX_ALIGNED;
                                         end
                STATE_WAIT_RX_ALIGNED    : 
                                         begin
                                             wait_to_restart       <= 1'b0;
                                             rx_aligned_led_c      <= 1'b0;
                                             rx_core_busy_led      <= 1'b0;

                                             //// State transition
                                             if  (stat_rx_aligned_1d == 1'b1)
                                                 rx_prestate <= STATE_PKT_TRANSFER_INIT;
                                             else 
                                                 rx_prestate <= STATE_WAIT_RX_ALIGNED;
                                         end
                STATE_PKT_TRANSFER_INIT  : 
                                         begin
                                             wait_to_restart       <= 1'b0;
                                             rx_aligned_led_c      <= 1'b1;
                                             rx_core_busy_led      <= 1'b1;

                                             rcv_data              <= 512'd0;
                                             rcv_datain            <= 512'd0;
                                             exp_data              <= 512'd0;
                                             exp_datain            <= 512'd0;
                                             number_pkt_rx         <= 16'd0;
                                             lbus_number_pkt_proc  <= PKT_NUM;
                                             rx_payload_1          <= 8'd6;
                                             rx_payload_2          <= rx_payload_1 + 8'd1;
                                             rx_payload_new        <= rx_payload_1 + 8'd2;
                                             rx_payload_16byte     <= {64{rx_payload_1}};
                                             rx_payload_16byte_new <= {64{rx_payload_2}};
                                             check_seg             <= 1'b0;
                                             valid_bytes           <= 64'd0;
                                             rx_fsm_en             <= 1'b0;

                                             //// State transition
                                             if  (stat_rx_aligned_1d == 1'b0)
                                                 rx_prestate <= STATE_RX_IDLE;
                                             else if  (rx_axis_tvalid == 1'b1)
                                                 rx_prestate <= STATE_LBUS_RX_ENABLE;
                                             else 
                                                 rx_prestate <= STATE_PKT_TRANSFER_INIT;
                                         end
                STATE_LBUS_RX_ENABLE     : 
                                         begin
                                             rx_fsm_en         <= 1'b1;
                                             if((rx_axis_tlast_d == 1'd1) && (rx_axis_tvalid_d == 1'd1))
                                             begin
                                                 number_pkt_rx      <= number_pkt_rx + 16'd1;
                                                 rx_payload_16byte  <= rx_payload_16byte_new;
                                                 if  ( rx_payload_new == 8'd255)
                                                 begin
                                                     rx_payload_new        <= 8'd6;
                                                     rx_payload_16byte_new <= {64{rx_payload_1}};
                                                 end
                                                 else
                                                 begin
                                                     rx_payload_new        <= rx_payload_new + 8'd1;
                                                     rx_payload_16byte_new <= {64{rx_payload_new}};
                                                 end
                                             end

                                             if((rx_axis_tlast_d == 1'd1) && (rx_axis_tvalid_d == 1'd1))
                                             begin
                                                 check_seg          <= 1'b0;
                                                 rcv_data           <= rx_axis_tdata_d; 
                                                 exp_data           <= rx_payload_16byte; 
                                                 valid_bytes        <= rx_axis_tkeep_d;
                                             end
                                             else if(rx_axis_tvalid_d == 1'd1)
                                             begin
                                                 rcv_datain         <= rx_axis_tdata_d;
                                                 exp_datain         <= rx_payload_16byte;
                                                 check_seg          <= 1'b1;
                                             end
                                             else
                                             begin
                                                 check_seg          <= 1'b0;
                                             end

                                             //// State transition
                                             if  (stat_rx_aligned_1d == 1'b0)
                                                 rx_prestate <= STATE_RX_IDLE;
                                             else if (rx_done_reg== 1'b1 && send_continuous_pkts_3d == 1'b0)
                                                 rx_prestate <= STATE_LBUS_RX_DONE;
                                             else
                                                 rx_prestate <= STATE_LBUS_RX_ENABLE;
                                         end
            STATE_LBUS_RX_DONE           :
                                         begin
                                             wait_to_restart        <= 1'b0;
                                             valid_bytes            <= 64'd0;
                                             rx_fsm_en              <= 1'b0;
                                             rcv_data               <= 512'd0;
                                             rcv_datain             <= 512'd0;
                                             exp_data               <= 512'd0;
                                             exp_datain             <= 512'd0;
                                             check_seg              <= 1'b0;
                                             init_cntr_en           <= 1'b0;
                                             init_done              <= 1'b0;


                                             //// State transition
                                             if  (stat_rx_aligned_1d == 1'b0)
                                                 rx_prestate <= STATE_RX_IDLE;
                                             else
                                                 rx_prestate <= STATE_WAIT_FOR_RESTART;
                                         end
              STATE_WAIT_FOR_RESTART     : 
                                         begin
                                             number_pkt_rx          <= 16'd0;
                                             wait_to_restart        <= 1'b1;
                                             if ( init_done == 1'b1)
                                             begin
                                                 rx_core_busy_led   <= 1'b0;
                                                 init_cntr_en       <= 1'b0;
                                             end
                                             else
                                             begin 
                                                 init_done          <= init_cntr[6];
                                                 init_cntr_en       <= 1'b1;
                                             end


                                             //// State transition
                                             if  ((rx_core_busy_led == 1'b0) && (rx_restart_rise_edge == 1'b1) && (stat_rx_aligned_1d == 1'b1))
                                                 rx_prestate <= STATE_PKT_TRANSFER_INIT;
                                             else if  (stat_rx_aligned_1d == 1'b0)
                                                 rx_prestate <= STATE_RX_IDLE;
                                             else 
                                                 rx_prestate <= STATE_WAIT_FOR_RESTART;
                                         end
              default                    :
                                         begin
                                             wait_to_restart        <= 1'b0;
                                             rx_fsm_en              <= 1'b0;
                                             rcv_data               <= 512'd0;
                                             rcv_datain             <= 512'd0;
                                             exp_data               <= 512'd0;
                                             exp_datain             <= 512'd0;
                                             check_seg              <= 1'b0;
                                             number_pkt_rx          <= 16'd0;
                                             lbus_number_pkt_proc   <= 16'd0;
                                             rx_payload_1           <= 8'd0;
                                             rx_payload_2           <= 8'd0;
                                             rx_payload_new         <= 8'd0;
                                             rx_payload_16byte      <= 512'd0;
                                             gt_lock_led            <= 1'b0;
                                             rx_aligned_led_c       <= 1'b0;
                                             rx_core_busy_led       <= 1'b0;
                                             ctl_rx_enable_r        <= 1'b0;
                                             ctl_rx_force_resync_r  <= 1'b0;
                                             ctl_rx_test_pattern_r  <= 1'b0;
                                             ctl_rsfec_ieee_error_indication_mode_r     <= 1'b0;
                                             ctl_rx_rsfec_enable_r             <= 1'b0;
                                             ctl_rx_rsfec_enable_correction_r  <= 1'b0;
                                             ctl_rx_rsfec_enable_indication_r  <= 1'b0;
                                             init_cntr_en           <= 1'b0;
                                             init_done              <= 1'b0;
                                             rx_prestate            <= STATE_RX_IDLE;
                                         end
            endcase
        end
    end

    //////////////////////////////////////////////////
    ////registering the send_continuous_pkts signal
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            send_continuous_pkts_1d     <= 1'b0;
            send_continuous_pkts_2d     <= 1'b0;
            send_continuous_pkts_3d     <= 1'b0;
        end
        else
        begin
            send_continuous_pkts_1d  <= send_continuous_pkts;
            send_continuous_pkts_2d  <= send_continuous_pkts_1d;
            send_continuous_pkts_3d  <= send_continuous_pkts_2d;
        end
    end

    //////////////////////////////////////////////////
    ////Checker Module
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_data_chk_fail   <= 1'b0;
        end
        else 
        begin
            if ((check_seg == 1'b1) && (rx_done_reg == 1'b0))
                if (rcv_datain == exp_datain)
                    rx_data_chk_fail <=1'b0;
                else
                    rx_data_chk_fail <=1'b1;
        end
    end

    //////////////////////////////////////////////////
    ////rx_done_reg signal generation
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_done_reg <= 1'b0;
        end
        else
            if  ( ((rx_restart_rise_edge == 1'b1) && (wait_to_restart == 1'b1)) || (stat_rx_aligned_1d == 1'b0) )
                rx_done_reg <= 1'b0;    
            else if  ((number_pkt_rx == lbus_number_pkt_proc) && (rx_fsm_en == 1'b1))
                rx_done_reg <= 1'b1;
    end
    
    //////////////////////////////////////////////////
    ////rx_data_fail signal generation
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_data_fail <= 1'b0;
        end
        else
        begin
            if  ((rx_restart_rise_edge == 1'b1) && (wait_to_restart == 1'b1))
                 rx_data_fail <= 1'b0;
             else if ((rx_fsm_en ==1'b1) && ((rx_data_chk_fail == 1'b1) || (byte_cmp_fail == 1'b1)))
                rx_data_fail <= 1'b1;
        end
    end

    //////////////////////////////////////////////////////////////////////////////
    ////rcv_data_cmp and exp_data_cmp generation according to valid_bytes
    //////////////////////////////////////////////////////////////////////////////

    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rcv_data_cmp <=  512'd0;
            exp_data_cmp <=  512'd0;
        end
        else
        begin
            if ((rx_done_reg == 1'b0) && ( rx_fsm_en == 1'b1 ))
            begin 
                case (valid_bytes)
                     64'hFFFF_FFFF_FFFF_FFFF  : begin
                                                    rcv_data_cmp <=  rcv_data;
                                                    exp_data_cmp <=  exp_data;
                                                end
                     64'hFFFF_FFFF_FFFF_FFFE  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:8],8'd0};
                                                   exp_data_cmp <=  {exp_data[511:8],8'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FFFC  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:16],16'd0};
                                                   exp_data_cmp <=  {exp_data[511:16],16'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FFF8  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:24],24'd0};
                                                   exp_data_cmp <=  {exp_data[511:24],24'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FFF0  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:32],32'd0};
                                                   exp_data_cmp <=  {exp_data[511:32],32'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FFE0  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:40],40'd0};
                                                   exp_data_cmp <=  {exp_data[511:40],40'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FFC0  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:48],48'd0};
                                                   exp_data_cmp <=  {exp_data[511:48],48'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FF80  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:56],56'd0};
                                                   exp_data_cmp <=  {exp_data[511:56],56'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FF00  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:64],64'd0};
                                                   exp_data_cmp <=  {exp_data[511:64],64'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FE00  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:72],72'd0};
                                                   exp_data_cmp <=  {exp_data[511:72],72'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_FC00  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:80],80'd0};
                                                   exp_data_cmp <=  {exp_data[511:80],80'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_F800  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:88],88'd0};
                                                   exp_data_cmp <=  {exp_data[511:88],88'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_F000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:96],96'd0};
                                                   exp_data_cmp <=  {exp_data[511:96],96'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_E000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:104],104'd0};
                                                   exp_data_cmp <=  {exp_data[511:104],104'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_C000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:112],112'd0};
                                                   exp_data_cmp <=  {exp_data[511:112],112'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_8000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:120],120'd0};
                                                   exp_data_cmp <=  {exp_data[511:120],120'd0};
                                                end
                     64'hFFFF_FFFF_FFFF_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:128],128'd0};
                                                   exp_data_cmp <=  {exp_data[511:128],128'd0};
                                                end
                     64'hFFFF_FFFF_FFFE_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:136],136'd0};
                                                   exp_data_cmp <=  {exp_data[511:136],136'd0};
                                                end
                     64'hFFFF_FFFF_FFFC_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:144],144'd0};
                                                   exp_data_cmp <=  {exp_data[511:144],144'd0};
                                                end
                     64'hFFFF_FFFF_FFF8_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:152],152'd0};
                                                   exp_data_cmp <=  {exp_data[511:152],152'd0};
                                                end
                     64'hFFFF_FFFF_FFF0_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:160],160'd0};
                                                   exp_data_cmp <=  {exp_data[511:160],160'd0};
                                                end
                     64'hFFFF_FFFF_FFE0_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:168],168'd0};
                                                   exp_data_cmp <=  {exp_data[511:168],168'd0};
                                                end
                     64'hFFFF_FFFF_FFC0_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:176],176'd0};
                                                   exp_data_cmp <=  {exp_data[511:176],176'd0};
                                                end
                     64'hFFFF_FFFF_FF80_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:184],184'd0};
                                                   exp_data_cmp <=  {exp_data[511:184],184'd0};
                                                end
                     64'hFFFF_FFFF_FF00_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:192],192'd0};
                                                   exp_data_cmp <=  {exp_data[511:192],192'd0};
                                                end
                     64'hFFFF_FFFF_FE00_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:200],200'd0};
                                                   exp_data_cmp <=  {exp_data[511:200],200'd0};
                                                end
                     64'hFFFF_FFFF_FC00_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:208],208'd0};
                                                   exp_data_cmp <=  {exp_data[511:208],208'd0};
                                                end
                     64'hFFFF_FFFF_F800_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:216],216'd0};
                                                   exp_data_cmp <=  {exp_data[511:216],216'd0};
                                                end
                     64'hFFFF_FFFF_F000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:224],224'd0};
                                                   exp_data_cmp <=  {exp_data[511:224],224'd0};
                                                end
                     64'hFFFF_FFFF_E000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:232],232'd0};
                                                   exp_data_cmp <=  {exp_data[511:232],232'd0};
                                                end
                     64'hFFFF_FFFF_C000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:240],240'd0};
                                                   exp_data_cmp <=  {exp_data[511:240],240'd0};
                                                end
                     64'hFFFF_FFFF_8000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:248],248'd0};
                                                   exp_data_cmp <=  {exp_data[511:248],248'd0};
                                                end
                     64'hFFFF_FFFF_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:256],256'd0};
                                                   exp_data_cmp <=  {exp_data[511:256],256'd0};
                                                end
                     64'hFFFF_FFFE_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:264],264'd0};
                                                   exp_data_cmp <=  {exp_data[511:264],264'd0};
                                                end
                     64'hFFFF_FFFC_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:272],272'd0};
                                                   exp_data_cmp <=  {exp_data[511:272],272'd0};
                                                end
                     64'hFFFF_FFF8_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:280],280'd0};
                                                   exp_data_cmp <=  {exp_data[511:280],280'd0};
                                                end
                     64'hFFFF_FFF0_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:288],288'd0};
                                                   exp_data_cmp <=  {exp_data[511:288],288'd0};
                                                end
                     64'hFFFF_FFE0_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:296],296'd0};
                                                   exp_data_cmp <=  {exp_data[511:296],296'd0};
                                                end
                     64'hFFFF_FFC0_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:304],304'd0};
                                                   exp_data_cmp <=  {exp_data[511:304],304'd0};
                                                end
                     64'hFFFF_FF80_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:312],312'd0};
                                                   exp_data_cmp <=  {exp_data[511:312],312'd0};
                                                end
                     64'hFFFF_FF00_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:320],320'd0};
                                                   exp_data_cmp <=  {exp_data[511:320],320'd0};
                                                end
                     64'hFFFF_FE00_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:328],328'd0};
                                                   exp_data_cmp <=  {exp_data[511:328],328'd0};
                                                end
                     64'hFFFF_FC00_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:336],336'd0};
                                                   exp_data_cmp <=  {exp_data[511:336],336'd0};
                                                end
                     64'hFFFF_F800_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:344],344'd0};
                                                   exp_data_cmp <=  {exp_data[511:344],344'd0};
                                                end
                     64'hFFFF_F000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:352],352'd0};
                                                   exp_data_cmp <=  {exp_data[511:352],352'd0};
                                                end
                     64'hFFFF_E000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:360],360'd0};
                                                   exp_data_cmp <=  {exp_data[511:360],360'd0};
                                                end
                     64'hFFFF_C000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:368],368'd0};
                                                   exp_data_cmp <=  {exp_data[511:368],368'd0};
                                                end
                     64'hFFFF_8000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:376],376'd0};
                                                   exp_data_cmp <=  {exp_data[511:376],376'd0};
                                                end
                     64'hFFFF_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:384],384'd0};
                                                   exp_data_cmp <=  {exp_data[511:384],384'd0};
                                                end
                     64'hFFFE_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:392],392'd0};
                                                   exp_data_cmp <=  {exp_data[511:392],392'd0};
                                                end
                     64'hFFFC_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:400],400'd0};
                                                   exp_data_cmp <=  {exp_data[511:400],400'd0};
                                                end
                     64'hFFF8_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:408],408'd0};
                                                   exp_data_cmp <=  {exp_data[511:408],408'd0};
                                                end
                     64'hFFF0_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:416],416'd0};
                                                   exp_data_cmp <=  {exp_data[511:416],416'd0};
                                                end
                     64'hFFE0_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:424],424'd0};
                                                   exp_data_cmp <=  {exp_data[511:424],424'd0};
                                                end
                     64'hFFC0_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:432],432'd0};
                                                   exp_data_cmp <=  {exp_data[511:432],432'd0};
                                                end
                     64'hFF80_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:440],440'd0};
                                                   exp_data_cmp <=  {exp_data[511:440],440'd0};
                                                end
                     64'hFF00_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:448],448'd0};
                                                   exp_data_cmp <=  {exp_data[511:448],448'd0};
                                                end
                     64'hFE00_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:456],456'd0};
                                                   exp_data_cmp <=  {exp_data[511:456],456'd0};
                                                end
                     64'hFC00_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:464],464'd0};
                                                   exp_data_cmp <=  {exp_data[511:464],464'd0};
                                                end
                     64'hF800_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:472],472'd0};
                                                   exp_data_cmp <=  {exp_data[511:472],472'd0};
                                                end
                     64'hF000_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:480],480'd0};
                                                   exp_data_cmp <=  {exp_data[511:480],480'd0};
                                                end
                     64'hE000_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:488],488'd0};
                                                   exp_data_cmp <=  {exp_data[511:488],488'd0};
                                                end
                     64'hC000_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:496],496'd0};
                                                   exp_data_cmp <=  {exp_data[511:496],496'd0};
                                                end
                     64'h8000_0000_0000_0000  : begin
                                                   rcv_data_cmp <=  {rcv_data[511:504],504'd0};
                                                   exp_data_cmp <=  {exp_data[511:504],504'd0};
                                                end
                     default : begin
                                 rcv_data_cmp <=  512'd0;
                                 exp_data_cmp <=  512'd0;
                             end 
                endcase
            end
            else 
            begin 
                rcv_data_cmp <=  512'd0;
                exp_data_cmp <=  512'd0;
            end
        end
    end  

    //////////////////////////////////////////////////
    ////byte_cmp_fail signal generation
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            byte_cmp_fail <= 1'b0;
        end
        else
        begin
            if (rcv_data_cmp == exp_data_cmp)
                byte_cmp_fail <= 1'b0;
            else 
                byte_cmp_fail <= 1'b1;
        end
    end
    
    //////////////////////////////////////////////////
    ////Assign RX LED Output ports with ASYN sys_reset
    //////////////////////////////////////////////////
    always @( posedge clk, posedge sys_reset  )
    begin
        if ( sys_reset == 1'b1 )
        begin
            rx_gt_locked_led     <= 1'b0;
            rx_aligned_led       <= 1'b0;
            rx_done_led          <= 1'b0;
            rx_data_fail_led     <= 1'b0;
            rx_busy_led          <= 1'b0;
        end
        else
        begin
            rx_gt_locked_led     <= rx_gt_locked_led_3d;
            rx_aligned_led       <= stat_rx_aligned_led_3d;
            rx_done_led          <= rx_done_led_3d;
            rx_data_fail_led     <= rx_data_fail_led_3d;
            rx_busy_led          <= rx_core_busy_led_3d;
        end
    end

    //////////////////////////////////////////////////
    ////init_cntr signal generation 
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            init_cntr <= 0;
        end
        else
        begin
            if (init_cntr_en == 1'b1)
               init_cntr <= init_cntr + 1;
            else 
               init_cntr <= 0;
        end
    end

    //////////////////////////////////////////////////
    ////Registering the LED ports
    //////////////////////////////////////////////////
    always @( posedge clk )
    begin
        if ( reset == 1'b1 )
        begin
            rx_gt_locked_led_1d     <= 1'b0;
            rx_gt_locked_led_2d     <= 1'b0;
            rx_gt_locked_led_3d     <= 1'b0;
            stat_rx_aligned_led_1d  <= 1'b0;
            stat_rx_aligned_led_2d  <= 1'b0;
            stat_rx_aligned_led_3d  <= 1'b0;
            rx_done_led_1d          <= 1'b0;
            rx_done_led_2d          <= 1'b0;
            rx_done_led_3d          <= 1'b0;
            rx_data_fail_led_1d     <= 1'b0;
            rx_data_fail_led_2d     <= 1'b0;
            rx_data_fail_led_3d     <= 1'b0;
            rx_core_busy_led_1d     <= 1'b0;
            rx_core_busy_led_2d     <= 1'b0;
            rx_core_busy_led_3d     <= 1'b0;
        end
        else
        begin
            rx_gt_locked_led_1d     <= gt_lock_led;
            rx_gt_locked_led_2d     <= rx_gt_locked_led_1d;
            rx_gt_locked_led_3d     <= rx_gt_locked_led_2d;
            stat_rx_aligned_led_1d  <= rx_aligned_led_c;
            stat_rx_aligned_led_2d  <= stat_rx_aligned_led_1d;
            stat_rx_aligned_led_3d  <= stat_rx_aligned_led_2d;
            rx_done_led_1d          <= rx_done_reg & (~send_continuous_pkts_3d);
            rx_done_led_2d          <= rx_done_led_1d;
            rx_done_led_3d          <= rx_done_led_2d;
            rx_data_fail_led_1d     <= rx_data_fail;
            rx_data_fail_led_2d     <= rx_data_fail_led_1d;
            rx_data_fail_led_3d     <= rx_data_fail_led_2d;
            rx_core_busy_led_1d     <= rx_core_busy_led;
            rx_core_busy_led_2d     <= rx_core_busy_led_1d;
            rx_core_busy_led_3d     <= rx_core_busy_led_2d;
        end
    end




assign ctl_rx_enable            = ctl_rx_enable_r;
assign ctl_rx_force_resync      = ctl_rx_force_resync_r;
assign ctl_rx_test_pattern      = ctl_rx_test_pattern_r;
assign ctl_rsfec_ieee_error_indication_mode      = ctl_rsfec_ieee_error_indication_mode_r;
assign ctl_rx_rsfec_enable                       = ctl_rx_rsfec_enable_r;
assign ctl_rx_rsfec_enable_correction            = ctl_rx_rsfec_enable_correction_r;
assign ctl_rx_rsfec_enable_indication            = ctl_rx_rsfec_enable_indication_r;
assign rx_reset                 = 1'b0;                          //// Used to Reset the CMAC RX Core
 ////----------------------------------------END RX Module-----------------------//

endmodule



