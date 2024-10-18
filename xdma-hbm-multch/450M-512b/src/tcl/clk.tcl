create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clkwiz
set_property -dict [list \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {450.000} \
  CONFIG.USE_LOCKED {false} \
  CONFIG.USE_RESET {false} \
  CONFIG.MMCM_DIVCLK_DIVIDE {2} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {23.625} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {2.625} \
  CONFIG.CLKOUT1_JITTER {106.361} \
  CONFIG.CLKOUT1_PHASE_ERROR {153.873} \
] [get_ips clkwiz]