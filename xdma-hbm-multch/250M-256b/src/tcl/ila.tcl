create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila
set_property -dict [list \
  CONFIG.C_PROBE28_WIDTH {256} \
  CONFIG.C_PROBE25_WIDTH {32} \
  CONFIG.C_PROBE21_WIDTH {32} \
  CONFIG.C_PROBE20_WIDTH {256} \
  CONFIG.C_PROBE17_WIDTH {32} \
  CONFIG.C_PROBE13_WIDTH {256} \
  CONFIG.C_PROBE10_WIDTH {32} \
  CONFIG.C_PROBE6_WIDTH {32} \
  CONFIG.C_PROBE5_WIDTH {256} \
  CONFIG.C_PROBE2_WIDTH {32} \
  CONFIG.C_NUM_OF_PROBES {30} \
] [get_ips ila]