# DDR difference clock 300MHz
create_clock -period 3.332 -name ddr4_clk_1_clk_p -waveform {0.000 1.666} [get_ports ddr4_clk_1_clk_p]
set_property PACKAGE_PIN E13 [get_ports ddr4_clk_1_clk_p]
set_property PACKAGE_PIN D12 [get_ports ddr4_clk_1_clk_n]
set_property IOSTANDARD LVDS [get_ports ddr4_clk_1_clk_p]
set_property IOSTANDARD LVDS [get_ports ddr4_clk_1_clk_n]

set_property PACKAGE_PIN J15  [get_ports ddr4_1_act_n]
set_property PACKAGE_PIN F13  [get_ports ddr4_1_adr[0]]
set_property PACKAGE_PIN J11  [get_ports ddr4_1_adr[1]]
set_property PACKAGE_PIN G11  [get_ports ddr4_1_adr[2]]
set_property PACKAGE_PIN E11  [get_ports ddr4_1_adr[3]]
set_property PACKAGE_PIN D11  [get_ports ddr4_1_adr[4]]
set_property PACKAGE_PIN G13  [get_ports ddr4_1_adr[5]]
set_property PACKAGE_PIN H12  [get_ports ddr4_1_adr[6]]
set_property PACKAGE_PIN E12  [get_ports ddr4_1_adr[7]]
set_property PACKAGE_PIN F9   [get_ports ddr4_1_adr[8]]
set_property PACKAGE_PIN A15  [get_ports ddr4_1_adr[9]]
set_property PACKAGE_PIN K14  [get_ports ddr4_1_adr[10]]
set_property PACKAGE_PIN D9   [get_ports ddr4_1_adr[11]]
set_property PACKAGE_PIN K13  [get_ports ddr4_1_adr[12]]
set_property PACKAGE_PIN D10  [get_ports ddr4_1_adr[13]]
set_property PACKAGE_PIN F15  [get_ports ddr4_1_adr[14]]
set_property PACKAGE_PIN J12  [get_ports ddr4_1_adr[15]]
set_property PACKAGE_PIN F14  [get_ports ddr4_1_adr[16]]
set_property PACKAGE_PIN D14  [get_ports ddr4_1_ba[0]]
set_property PACKAGE_PIN B15  [get_ports ddr4_1_ba[1]]
set_property PACKAGE_PIN E9   [get_ports ddr4_1_bg[0]]
set_property PACKAGE_PIN F11  [get_ports ddr4_1_bg[1]]
set_property PACKAGE_PIN G15  [get_ports ddr4_1_ck_c[0]]
set_property PACKAGE_PIN H15  [get_ports ddr4_1_ck_t[0]]
set_property PACKAGE_PIN F10  [get_ports ddr4_1_cke[0]]
set_property PACKAGE_PIN H14  [get_ports ddr4_1_cs_n[0]]
set_property PACKAGE_PIN A10  [get_ports ddr4_1_dq[0]]
set_property PACKAGE_PIN B11  [get_ports ddr4_1_dq[1]]
set_property PACKAGE_PIN A9   [get_ports ddr4_1_dq[2]]
set_property PACKAGE_PIN B10  [get_ports ddr4_1_dq[3]]
set_property PACKAGE_PIN A11  [get_ports ddr4_1_dq[4]]
set_property PACKAGE_PIN B12  [get_ports ddr4_1_dq[5]]
set_property PACKAGE_PIN A8   [get_ports ddr4_1_dq[6]]
set_property PACKAGE_PIN C12  [get_ports ddr4_1_dq[7]]
set_property PACKAGE_PIN BL6  [get_ports ddr4_1_dq[8]]
set_property PACKAGE_PIN BM4  [get_ports ddr4_1_dq[9]]
set_property PACKAGE_PIN BM5  [get_ports ddr4_1_dq[10]]
set_property PACKAGE_PIN BN5  [get_ports ddr4_1_dq[11]]
set_property PACKAGE_PIN BN4  [get_ports ddr4_1_dq[12]]
set_property PACKAGE_PIN BN6  [get_ports ddr4_1_dq[13]]
set_property PACKAGE_PIN BM3  [get_ports ddr4_1_dq[14]]
set_property PACKAGE_PIN BN7  [get_ports ddr4_1_dq[15]]
set_property PACKAGE_PIN BK3  [get_ports ddr4_1_dq[16]]
set_property PACKAGE_PIN BH2  [get_ports ddr4_1_dq[17]]
set_property PACKAGE_PIN BK4  [get_ports ddr4_1_dq[18]]
set_property PACKAGE_PIN BJ1  [get_ports ddr4_1_dq[19]]
set_property PACKAGE_PIN BK5  [get_ports ddr4_1_dq[20]]
set_property PACKAGE_PIN BH1  [get_ports ddr4_1_dq[21]]
set_property PACKAGE_PIN BJ4  [get_ports ddr4_1_dq[22]]
set_property PACKAGE_PIN BK1  [get_ports ddr4_1_dq[23]]
set_property PACKAGE_PIN BK8  [get_ports ddr4_1_dq[24]]
set_property PACKAGE_PIN BF7  [get_ports ddr4_1_dq[25]]
set_property PACKAGE_PIN BG7  [get_ports ddr4_1_dq[26]]
set_property PACKAGE_PIN BH5  [get_ports ddr4_1_dq[27]]
set_property PACKAGE_PIN BG8  [get_ports ddr4_1_dq[28]]
set_property PACKAGE_PIN BH4  [get_ports ddr4_1_dq[29]]
set_property PACKAGE_PIN BJ8  [get_ports ddr4_1_dq[30]]
set_property PACKAGE_PIN BF8  [get_ports ddr4_1_dq[31]]
set_property PACKAGE_PIN BG3  [get_ports ddr4_1_dq[32]]
set_property PACKAGE_PIN BE3  [get_ports ddr4_1_dq[33]]
set_property PACKAGE_PIN BF1  [get_ports ddr4_1_dq[34]]
set_property PACKAGE_PIN BE1  [get_ports ddr4_1_dq[35]]
set_property PACKAGE_PIN BG2  [get_ports ddr4_1_dq[36]]
set_property PACKAGE_PIN BE4  [get_ports ddr4_1_dq[37]]
set_property PACKAGE_PIN BF2  [get_ports ddr4_1_dq[38]]
set_property PACKAGE_PIN BF3  [get_ports ddr4_1_dq[39]]
set_property PACKAGE_PIN BP14 [get_ports ddr4_1_dq[40]]
set_property PACKAGE_PIN BP13 [get_ports ddr4_1_dq[41]]
set_property PACKAGE_PIN BN12 [get_ports ddr4_1_dq[42]]
set_property PACKAGE_PIN BM14 [get_ports ddr4_1_dq[43]]
set_property PACKAGE_PIN BM13 [get_ports ddr4_1_dq[44]]
set_property PACKAGE_PIN BL15 [get_ports ddr4_1_dq[45]]
set_property PACKAGE_PIN BM12 [get_ports ddr4_1_dq[46]]
set_property PACKAGE_PIN BM15 [get_ports ddr4_1_dq[47]]
set_property PACKAGE_PIN BK9  [get_ports ddr4_1_dq[48]]
set_property PACKAGE_PIN BN10 [get_ports ddr4_1_dq[49]]
set_property PACKAGE_PIN BL10 [get_ports ddr4_1_dq[50]]
set_property PACKAGE_PIN BM10 [get_ports ddr4_1_dq[51]]
set_property PACKAGE_PIN BJ9  [get_ports ddr4_1_dq[52]]
set_property PACKAGE_PIN BN9  [get_ports ddr4_1_dq[53]]
set_property PACKAGE_PIN BK10 [get_ports ddr4_1_dq[54]]
set_property PACKAGE_PIN BM9  [get_ports ddr4_1_dq[55]]
set_property PACKAGE_PIN BH14 [get_ports ddr4_1_dq[56]]
set_property PACKAGE_PIN BJ12 [get_ports ddr4_1_dq[57]]
set_property PACKAGE_PIN BK15 [get_ports ddr4_1_dq[58]]
set_property PACKAGE_PIN BJ13 [get_ports ddr4_1_dq[59]]
set_property PACKAGE_PIN BH15 [get_ports ddr4_1_dq[60]]
set_property PACKAGE_PIN BL12 [get_ports ddr4_1_dq[61]]
set_property PACKAGE_PIN BK14 [get_ports ddr4_1_dq[62]]
set_property PACKAGE_PIN BL13 [get_ports ddr4_1_dq[63]]
set_property PACKAGE_PIN BG10 [get_ports ddr4_1_dq[64]]
set_property PACKAGE_PIN BG13 [get_ports ddr4_1_dq[65]]
set_property PACKAGE_PIN BF10 [get_ports ddr4_1_dq[66]]
set_property PACKAGE_PIN BE9  [get_ports ddr4_1_dq[67]]
set_property PACKAGE_PIN BG9  [get_ports ddr4_1_dq[68]]
set_property PACKAGE_PIN BE10 [get_ports ddr4_1_dq[69]]
set_property PACKAGE_PIN BG12 [get_ports ddr4_1_dq[70]]
set_property PACKAGE_PIN BE11 [get_ports ddr4_1_dq[71]]
set_property PACKAGE_PIN C10  [get_ports ddr4_1_dm_n[0]]
set_property PACKAGE_PIN BP7  [get_ports ddr4_1_dm_n[1]]
set_property PACKAGE_PIN BL3  [get_ports ddr4_1_dm_n[2]]
set_property PACKAGE_PIN BH6  [get_ports ddr4_1_dm_n[3]]
set_property PACKAGE_PIN BG5  [get_ports ddr4_1_dm_n[4]]
set_property PACKAGE_PIN BP12 [get_ports ddr4_1_dm_n[5]]
set_property PACKAGE_PIN BP9  [get_ports ddr4_1_dm_n[6]]
set_property PACKAGE_PIN BJ11 [get_ports ddr4_1_dm_n[7]]
set_property PACKAGE_PIN BH10 [get_ports ddr4_1_dm_n[8]]
set_property PACKAGE_PIN A13  [get_ports ddr4_1_dqs_c[0]]
set_property PACKAGE_PIN B13  [get_ports ddr4_1_dqs_t[0]]
set_property PACKAGE_PIN BM7  [get_ports ddr4_1_dqs_c[1]]
set_property PACKAGE_PIN BL7  [get_ports ddr4_1_dqs_t[1]]
set_property PACKAGE_PIN BJ2  [get_ports ddr4_1_dqs_c[2]]
set_property PACKAGE_PIN BJ3  [get_ports ddr4_1_dqs_t[2]]
set_property PACKAGE_PIN BJ7  [get_ports ddr4_1_dqs_c[3]]
set_property PACKAGE_PIN BH7  [get_ports ddr4_1_dqs_t[3]]
set_property PACKAGE_PIN BE5  [get_ports ddr4_1_dqs_c[4]]
set_property PACKAGE_PIN BE6  [get_ports ddr4_1_dqs_t[4]]
set_property PACKAGE_PIN BN14 [get_ports ddr4_1_dqs_c[5]]
set_property PACKAGE_PIN BN15 [get_ports ddr4_1_dqs_t[5]]
set_property PACKAGE_PIN BM8  [get_ports ddr4_1_dqs_c[6]]
set_property PACKAGE_PIN BL8  [get_ports ddr4_1_dqs_t[6]]
set_property PACKAGE_PIN BK13 [get_ports ddr4_1_dqs_c[7]]
set_property PACKAGE_PIN BJ14 [get_ports ddr4_1_dqs_t[7]]
set_property PACKAGE_PIN BF11 [get_ports ddr4_1_dqs_c[8]]
set_property PACKAGE_PIN BF12 [get_ports ddr4_1_dqs_t[8]]
set_property PACKAGE_PIN D15  [get_ports ddr4_1_odt[0]]
set_property PACKAGE_PIN H13  [get_ports ddr4_1_reset_n]
#set_property PACKAGE_PIN A14  [get_ports ddr4_1_par]