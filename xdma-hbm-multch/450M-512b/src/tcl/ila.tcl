create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila
set_property -dict [list \
  CONFIG.C_PROBE30_WIDTH {16} \
  CONFIG.C_PROBE28_WIDTH {512} \
  CONFIG.C_PROBE25_WIDTH {32} \
  CONFIG.C_PROBE21_WIDTH {64} \
  CONFIG.C_PROBE20_WIDTH {512} \
  CONFIG.C_PROBE17_WIDTH {32} \
  CONFIG.C_PROBE13_WIDTH {512} \
  CONFIG.C_PROBE10_WIDTH {32} \
  CONFIG.C_PROBE6_WIDTH {64} \
  CONFIG.C_PROBE5_WIDTH {512} \
  CONFIG.C_PROBE2_WIDTH {32} \
  CONFIG.C_NUM_OF_PROBES {31} \
] [get_ips ila]