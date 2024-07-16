# DDR difference clock 300MHz
create_clock -period 3.332 -name ddr4_clk_2_clk_p -waveform {0.000 1.666} [get_ports ddr4_clk_2_clk_p]
set_property PACKAGE_PIN E31 [get_ports ddr4_clk_2_clk_p]
set_property PACKAGE_PIN E32 [get_ports ddr4_clk_2_clk_n]
set_property IOSTANDARD LVDS [get_ports ddr4_clk_2_clk_p]
set_property IOSTANDARD LVDS [get_ports ddr4_clk_2_clk_n]

set_property PACKAGE_PIN B32  [get_ports ddr4_2_act_n]
set_property PACKAGE_PIN A28  [get_ports ddr4_2_adr[0]]
set_property PACKAGE_PIN E28  [get_ports ddr4_2_adr[1]]
set_property PACKAGE_PIN B31  [get_ports ddr4_2_adr[2]]
set_property PACKAGE_PIN E29  [get_ports ddr4_2_adr[3]]
set_property PACKAGE_PIN A29  [get_ports ddr4_2_adr[4]]
set_property PACKAGE_PIN G30  [get_ports ddr4_2_adr[5]]
set_property PACKAGE_PIN C32  [get_ports ddr4_2_adr[6]]
set_property PACKAGE_PIN H29  [get_ports ddr4_2_adr[7]]
set_property PACKAGE_PIN C30  [get_ports ddr4_2_adr[8]]
set_property PACKAGE_PIN D30  [get_ports ddr4_2_adr[9]]
set_property PACKAGE_PIN A30  [get_ports ddr4_2_adr[10]]
set_property PACKAGE_PIN C28  [get_ports ddr4_2_adr[11]]
set_property PACKAGE_PIN B33  [get_ports ddr4_2_adr[12]]
set_property PACKAGE_PIN H30  [get_ports ddr4_2_adr[13]]
set_property PACKAGE_PIN C33  [get_ports ddr4_2_adr[14]]
set_property PACKAGE_PIN F31  [get_ports ddr4_2_adr[15]]
set_property PACKAGE_PIN G33  [get_ports ddr4_2_adr[16]]
set_property PACKAGE_PIN E33  [get_ports ddr4_2_ba[0]]
set_property PACKAGE_PIN F28  [get_ports ddr4_2_ba[1]]
set_property PACKAGE_PIN D32  [get_ports ddr4_2_bg[0]]
set_property PACKAGE_PIN H33  [get_ports ddr4_2_bg[1]]
set_property PACKAGE_PIN A31  [get_ports ddr4_2_ck_c[0]]
set_property PACKAGE_PIN B30  [get_ports ddr4_2_ck_t[0]]
set_property PACKAGE_PIN D31  [get_ports ddr4_2_cke[0]]
set_property PACKAGE_PIN C29  [get_ports ddr4_2_cs_n[0]]
set_property PACKAGE_PIN J29  [get_ports ddr4_2_dq[0]]
set_property PACKAGE_PIN L29  [get_ports ddr4_2_dq[1]]
set_property PACKAGE_PIN J30  [get_ports ddr4_2_dq[2]]
set_property PACKAGE_PIN K31  [get_ports ddr4_2_dq[3]]
set_property PACKAGE_PIN J31  [get_ports ddr4_2_dq[4]]
set_property PACKAGE_PIN L30  [get_ports ddr4_2_dq[5]]
set_property PACKAGE_PIN K29  [get_ports ddr4_2_dq[6]]
set_property PACKAGE_PIN L31  [get_ports ddr4_2_dq[7]]
set_property PACKAGE_PIN A35  [get_ports ddr4_2_dq[8]]
set_property PACKAGE_PIN B36  [get_ports ddr4_2_dq[9]]
set_property PACKAGE_PIN A34  [get_ports ddr4_2_dq[10]]
set_property PACKAGE_PIN C37  [get_ports ddr4_2_dq[11]]
set_property PACKAGE_PIN A36  [get_ports ddr4_2_dq[12]]
set_property PACKAGE_PIN B38  [get_ports ddr4_2_dq[13]]
set_property PACKAGE_PIN B35  [get_ports ddr4_2_dq[14]]
set_property PACKAGE_PIN C35  [get_ports ddr4_2_dq[15]]
set_property PACKAGE_PIN D36  [get_ports ddr4_2_dq[16]]
set_property PACKAGE_PIN F34  [get_ports ddr4_2_dq[17]]
set_property PACKAGE_PIN E37  [get_ports ddr4_2_dq[18]]
set_property PACKAGE_PIN E36  [get_ports ddr4_2_dq[19]]
set_property PACKAGE_PIN D37  [get_ports ddr4_2_dq[20]]
set_property PACKAGE_PIN E34  [get_ports ddr4_2_dq[21]]
set_property PACKAGE_PIN E38  [get_ports ddr4_2_dq[22]]
set_property PACKAGE_PIN D35  [get_ports ddr4_2_dq[23]]
set_property PACKAGE_PIN G37  [get_ports ddr4_2_dq[24]]
set_property PACKAGE_PIN H34  [get_ports ddr4_2_dq[25]]
set_property PACKAGE_PIN G36  [get_ports ddr4_2_dq[26]]
set_property PACKAGE_PIN H37  [get_ports ddr4_2_dq[27]]
set_property PACKAGE_PIN F38  [get_ports ddr4_2_dq[28]]
set_property PACKAGE_PIN H35  [get_ports ddr4_2_dq[29]]
set_property PACKAGE_PIN H38  [get_ports ddr4_2_dq[30]]
set_property PACKAGE_PIN G35  [get_ports ddr4_2_dq[31]]
set_property PACKAGE_PIN K36  [get_ports ddr4_2_dq[32]]
set_property PACKAGE_PIN K34  [get_ports ddr4_2_dq[33]]
set_property PACKAGE_PIN K37  [get_ports ddr4_2_dq[34]]
set_property PACKAGE_PIN J36  [get_ports ddr4_2_dq[35]]
set_property PACKAGE_PIN K39  [get_ports ddr4_2_dq[36]]
set_property PACKAGE_PIN L34  [get_ports ddr4_2_dq[37]]
set_property PACKAGE_PIN L39  [get_ports ddr4_2_dq[38]]
set_property PACKAGE_PIN J37  [get_ports ddr4_2_dq[39]]
set_property PACKAGE_PIN B41  [get_ports ddr4_2_dq[40]]
set_property PACKAGE_PIN A39  [get_ports ddr4_2_dq[41]]
set_property PACKAGE_PIN B42  [get_ports ddr4_2_dq[42]]
set_property PACKAGE_PIN A40  [get_ports ddr4_2_dq[43]]
set_property PACKAGE_PIN D41  [get_ports ddr4_2_dq[44]]
set_property PACKAGE_PIN C40  [get_ports ddr4_2_dq[45]]
set_property PACKAGE_PIN E41  [get_ports ddr4_2_dq[46]]
set_property PACKAGE_PIN D40  [get_ports ddr4_2_dq[47]]
set_property PACKAGE_PIN A44  [get_ports ddr4_2_dq[48]]
set_property PACKAGE_PIN C45  [get_ports ddr4_2_dq[49]]
set_property PACKAGE_PIN B46  [get_ports ddr4_2_dq[50]]
set_property PACKAGE_PIN A43  [get_ports ddr4_2_dq[51]]
set_property PACKAGE_PIN B45  [get_ports ddr4_2_dq[52]]
set_property PACKAGE_PIN C43  [get_ports ddr4_2_dq[53]]
set_property PACKAGE_PIN C44  [get_ports ddr4_2_dq[54]]
set_property PACKAGE_PIN D42  [get_ports ddr4_2_dq[55]]
set_property PACKAGE_PIN F46  [get_ports ddr4_2_dq[56]]
set_property PACKAGE_PIN F44  [get_ports ddr4_2_dq[57]]
set_property PACKAGE_PIN F45  [get_ports ddr4_2_dq[58]]
set_property PACKAGE_PIN D44  [get_ports ddr4_2_dq[59]]
set_property PACKAGE_PIN H45  [get_ports ddr4_2_dq[60]]
set_property PACKAGE_PIN E44  [get_ports ddr4_2_dq[61]]
set_property PACKAGE_PIN G45  [get_ports ddr4_2_dq[62]]
set_property PACKAGE_PIN D45  [get_ports ddr4_2_dq[63]]
set_property PACKAGE_PIN H42  [get_ports ddr4_2_dq[64]]
set_property PACKAGE_PIN G41  [get_ports ddr4_2_dq[65]]
set_property PACKAGE_PIN H43  [get_ports ddr4_2_dq[66]]
set_property PACKAGE_PIN J41  [get_ports ddr4_2_dq[67]]
set_property PACKAGE_PIN J42  [get_ports ddr4_2_dq[68]]
set_property PACKAGE_PIN J40  [get_ports ddr4_2_dq[69]]
set_property PACKAGE_PIN G43  [get_ports ddr4_2_dq[70]]
set_property PACKAGE_PIN G42  [get_ports ddr4_2_dq[71]]
set_property PACKAGE_PIN L33  [get_ports ddr4_2_dm_n[0]]
set_property PACKAGE_PIN D34  [get_ports ddr4_2_dm_n[1]]
set_property PACKAGE_PIN F35  [get_ports ddr4_2_dm_n[2]]
set_property PACKAGE_PIN J39  [get_ports ddr4_2_dm_n[3]]
set_property PACKAGE_PIN L35  [get_ports ddr4_2_dm_n[4]]
set_property PACKAGE_PIN F40  [get_ports ddr4_2_dm_n[5]]
set_property PACKAGE_PIN E42  [get_ports ddr4_2_dm_n[6]]
set_property PACKAGE_PIN J44  [get_ports ddr4_2_dm_n[7]]
set_property PACKAGE_PIN K41  [get_ports ddr4_2_dm_n[8]]
set_property PACKAGE_PIN J32  [get_ports ddr4_2_dqs_c[0]]
set_property PACKAGE_PIN K32  [get_ports ddr4_2_dqs_t[0]]
set_property PACKAGE_PIN A38  [get_ports ddr4_2_dqs_c[1]]
set_property PACKAGE_PIN B37  [get_ports ddr4_2_dqs_t[1]]
set_property PACKAGE_PIN D39  [get_ports ddr4_2_dqs_c[2]]
set_property PACKAGE_PIN E39  [get_ports ddr4_2_dqs_t[2]]
set_property PACKAGE_PIN F39  [get_ports ddr4_2_dqs_c[3]]
set_property PACKAGE_PIN G38  [get_ports ddr4_2_dqs_t[3]]
set_property PACKAGE_PIN K38  [get_ports ddr4_2_dqs_c[4]]
set_property PACKAGE_PIN L38  [get_ports ddr4_2_dqs_t[4]]
set_property PACKAGE_PIN A41  [get_ports ddr4_2_dqs_c[5]]
set_property PACKAGE_PIN B40  [get_ports ddr4_2_dqs_t[5]]
set_property PACKAGE_PIN A46  [get_ports ddr4_2_dqs_c[6]]
set_property PACKAGE_PIN A45  [get_ports ddr4_2_dqs_t[6]]
set_property PACKAGE_PIN D46  [get_ports ddr4_2_dqs_c[7]]
set_property PACKAGE_PIN E46  [get_ports ddr4_2_dqs_t[7]]
set_property PACKAGE_PIN G40  [get_ports ddr4_2_dqs_c[8]]
set_property PACKAGE_PIN H40  [get_ports ddr4_2_dqs_t[8]]
set_property PACKAGE_PIN A33  [get_ports ddr4_2_odt[0]]
set_property PACKAGE_PIN F33  [get_ports ddr4_2_reset_n]
#set_property PACKAGE_PIN B28  [get_ports ddr4_2_par]