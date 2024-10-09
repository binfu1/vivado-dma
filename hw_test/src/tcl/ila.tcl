create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_cmac
set_property -dict [list \
  CONFIG.C_PROBE12_WIDTH {32} \
  CONFIG.C_NUM_OF_PROBES {13} \
] [get_ips ila_cmac]