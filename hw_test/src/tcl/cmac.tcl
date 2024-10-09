# cmac_0
create_ip -name cmac_usplus -vendor xilinx.com -library ip -version 3.1 -module_name cmac_usplus_0
set_property -dict [list \
  CONFIG.CMAC_CAUI4_MODE {1} \
  CONFIG.NUM_LANES {4x25} \
  CONFIG.GT_REF_CLK_FREQ {322.265625} \
  CONFIG.USER_INTERFACE {AXIS} \
  CONFIG.TX_FLOW_CONTROL {0} \
  CONFIG.RX_FLOW_CONTROL {0} \
  CONFIG.INCLUDE_RS_FEC {1} \
  CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y1} \
  CONFIG.GT_GROUP_SELECT {X0Y8~X0Y11} \
  CONFIG.LANE1_GT_LOC {X0Y8} \
  CONFIG.LANE2_GT_LOC {X0Y9} \
  CONFIG.LANE3_GT_LOC {X0Y10} \
  CONFIG.LANE4_GT_LOC {X0Y11} \
  CONFIG.LANE5_GT_LOC {NA} \
  CONFIG.LANE6_GT_LOC {NA} \
  CONFIG.LANE7_GT_LOC {NA} \
  CONFIG.LANE8_GT_LOC {NA} \
  CONFIG.LANE9_GT_LOC {NA} \
  CONFIG.LANE10_GT_LOC {NA}] \
  [get_ips cmac_usplus_0]
  
# cmac_1
create_ip -name cmac_usplus -vendor xilinx.com -library ip -version 3.1 -module_name cmac_usplus_1
set_property -dict [list \
  CONFIG.CMAC_CAUI4_MODE {1} \
  CONFIG.NUM_LANES {4x25} \
  CONFIG.GT_REF_CLK_FREQ {322.265625} \
  CONFIG.USER_INTERFACE {AXIS} \
  CONFIG.TX_FLOW_CONTROL {0} \
  CONFIG.RX_FLOW_CONTROL {0} \
  CONFIG.INCLUDE_RS_FEC {1} \
  CONFIG.CMAC_CORE_SELECT {CMACE4_X0Y3} \
  CONFIG.GT_GROUP_SELECT {X0Y24~X0Y27} \
  CONFIG.LANE1_GT_LOC {X0Y24} \
  CONFIG.LANE2_GT_LOC {X0Y25} \
  CONFIG.LANE3_GT_LOC {X0Y26} \
  CONFIG.LANE4_GT_LOC {X0Y27} \
  CONFIG.LANE5_GT_LOC {NA} \
  CONFIG.LANE6_GT_LOC {NA} \
  CONFIG.LANE7_GT_LOC {NA} \
  CONFIG.LANE8_GT_LOC {NA} \
  CONFIG.LANE9_GT_LOC {NA} \
  CONFIG.LANE10_GT_LOC {NA}] \
  [get_ips cmac_usplus_1]