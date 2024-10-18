namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]
set coeDir ${script_folder}/../../py/data

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init0
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init0.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init0]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init1
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init1.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init1]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init2
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init2.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init2]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init3
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init3.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init3]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init4
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init4.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init4]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init5
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init5.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init5]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init6
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init6.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init6]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init7
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init7.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init7]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init8
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init8.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init8]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init9
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init9.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init9]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init10
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init10.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init10]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init11
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init11.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init11]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init12
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init12.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init12]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init13
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init13.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init13]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init14
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init14.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init14]

create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name bram_init15
set_property -dict [list \
  CONFIG.Interface_Type {AXI4} \
  CONFIG.Use_AXI_ID {true} \
  CONFIG.Memory_Type {Simple_Dual_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Assume_Synchronous_Clk {true} \
  CONFIG.Write_Width_A {256} \
  CONFIG.Write_Depth_A {32768} \
  CONFIG.Read_Width_A {256} \
  CONFIG.Operating_Mode_A {READ_FIRST} \
  CONFIG.Write_Width_B {256} \
  CONFIG.Read_Width_B {256} \
  CONFIG.Operating_Mode_B {READ_FIRST} \
  CONFIG.Enable_B {Use_ENB_Pin} \
  CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
  CONFIG.Load_Init_File {true} \
  CONFIG.Coe_File $coeDir/init15.coe  \
  CONFIG.Use_RSTB_Pin {true} \
  CONFIG.Reset_Type {ASYNC} \
  CONFIG.Port_B_Clock {100} \
  CONFIG.Port_B_Enable_Rate {100} \
  CONFIG.EN_SAFETY_CKT {true} \
  CONFIG.EN_SAFETY_CKT {false} \
] [get_ips bram_init15]