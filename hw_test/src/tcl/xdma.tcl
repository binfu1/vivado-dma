
################################################################
# This is a generated script based on design: xdma
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2020.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source xdma_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu37p-fsvh2892-2L-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name xdma

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xdma:4.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set ddr0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr0 ]

  set ddr0_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr0_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $ddr0_clk

  set ddr1 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr1 ]

  set ddr1_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr1_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $ddr1_clk

  set ddr2 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 ddr2 ]

  set ddr2_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr2_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $ddr2_clk

  set gpio_i [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_i ]

  set gpio_o [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 gpio_o ]

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]

  set sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $sys_clk


  # Create ports
  set sys_rstn [ create_bd_port -dir I -type rst sys_rstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $sys_rstn

  # Create instance: axi_gpio, and set properties
  set axi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio ]
  set_property -dict [ list \
   CONFIG.C_ALL_INPUTS {0} \
   CONFIG.C_ALL_INPUTS_2 {1} \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio

  # Create instance: buf_sysclk, and set properties
  set buf_sysclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 buf_sysclk ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $buf_sysclk

  # Create instance: ddr0, and set properties
  set ddr0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr0 ]
  set_property -dict [ list \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.CS_WIDTH {2} \
   CONFIG.C0.DDR4_AxiAddressWidth {33} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {17} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_Clamshell {true} \
   CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
   CONFIG.C0.DDR4_DataWidth {72} \
   CONFIG.C0.DDR4_Ecc {true} \
   CONFIG.C0.DDR4_InputClockPeriod {3332} \
   CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
   CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr0

  # Create instance: ddr1, and set properties
  set ddr1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr1 ]
  set_property -dict [ list \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.CS_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {33} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {17} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_Clamshell {false} \
   CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
   CONFIG.C0.DDR4_DataWidth {72} \
   CONFIG.C0.DDR4_Ecc {true} \
   CONFIG.C0.DDR4_InputClockPeriod {3332} \
   CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
   CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr1

  # Create instance: ddr2, and set properties
  set ddr2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr2 ]
  set_property -dict [ list \
   CONFIG.C0.BANK_GROUP_WIDTH {1} \
   CONFIG.C0.CS_WIDTH {1} \
   CONFIG.C0.DDR4_AxiAddressWidth {33} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {17} \
   CONFIG.C0.DDR4_CasWriteLatency {12} \
   CONFIG.C0.DDR4_Clamshell {false} \
   CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
   CONFIG.C0.DDR4_DataWidth {72} \
   CONFIG.C0.DDR4_Ecc {true} \
   CONFIG.C0.DDR4_InputClockPeriod {3332} \
   CONFIG.C0.DDR4_MemoryPart {MT40A1G16RC-062E} \
   CONFIG.C0.DDR4_TimePeriod {833} \
 ] $ddr2

  # Create instance: ila_ddr_axi, and set properties
  set ila_ddr_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_ddr_axi ]

  # Create instance: ila_ddr_axil, and set properties
  set ila_ddr_axil [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_ddr_axil ]

  # Create instance: interconnect_axi, and set properties
  set interconnect_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi ]
  set_property -dict [ list \
   CONFIG.NUM_MI {3} \
 ] $interconnect_axi

  # Create instance: interconnect_axil, and set properties
  set interconnect_axil [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axil ]
  set_property -dict [ list \
   CONFIG.NUM_MI {4} \
 ] $interconnect_axil

  # Create instance: logic_not_sysrst, and set properties
  set logic_not_sysrst [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_not_sysrst ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $logic_not_sysrst

  # Create instance: logic_not_uirst_0, and set properties
  set logic_not_uirst_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_not_uirst_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $logic_not_uirst_0

  # Create instance: logic_not_uirst_1, and set properties
  set logic_not_uirst_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_not_uirst_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $logic_not_uirst_1

  # Create instance: logic_not_uirst_2, and set properties
  set logic_not_uirst_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 logic_not_uirst_2 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $logic_not_uirst_2

  # Create instance: xdma, and set properties
  set xdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma ]
  set_property -dict [ list \
   CONFIG.PF0_DEVICE_ID_mqdma {903F} \
   CONFIG.PF0_SRIOV_VF_DEVICE_ID {A03F} \
   CONFIG.PF1_SRIOV_VF_DEVICE_ID {0000} \
   CONFIG.PF2_DEVICE_ID_mqdma {903F} \
   CONFIG.PF2_SRIOV_VF_DEVICE_ID {0000} \
   CONFIG.PF3_DEVICE_ID_mqdma {903F} \
   CONFIG.PF3_SRIOV_VF_DEVICE_ID {0000} \
   CONFIG.axi_bypass_64bit_en {false} \
   CONFIG.axi_data_width {512_bit} \
   CONFIG.axil_master_64bit_en {true} \
   CONFIG.axil_master_prefetchable {true} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axist_bypass_en {false} \
   CONFIG.axisten_freq {250} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.coreclk_freq {500} \
   CONFIG.pcie_blk_locn {PCIE4C_X1Y0} \
   CONFIG.pf0_device_id {903F} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_3:2} \
   CONFIG.pf0_msix_cap_table_bir {BAR_3:2} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X16} \
   CONFIG.plltype {QPLL1} \
   CONFIG.select_quad {GTY_Quad_227} \
   CONFIG.vendor_id {1BD4} \
   CONFIG.xdma_pcie_64bit_en {true} \
   CONFIG.xdma_pcie_prefetchable {true} \
 ] $xdma

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports ddr0_clk] [get_bd_intf_pins ddr0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_2 [get_bd_intf_ports ddr1_clk] [get_bd_intf_pins ddr1/C0_SYS_CLK]
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_3 [get_bd_intf_ports ddr2_clk] [get_bd_intf_pins ddr2/C0_SYS_CLK]
  connect_bd_intf_net -intf_net axi_gpio_GPIO [get_bd_intf_ports gpio_o] [get_bd_intf_pins axi_gpio/GPIO]
  connect_bd_intf_net -intf_net axi_gpio_GPIO2 [get_bd_intf_ports gpio_i] [get_bd_intf_pins axi_gpio/GPIO2]
  connect_bd_intf_net -intf_net axi_interconnect_ddr_axi_M00_AXI [get_bd_intf_pins ddr0/C0_DDR4_S_AXI] [get_bd_intf_pins interconnect_axi/M00_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_ddr_axil_M01_AXI [get_bd_intf_pins ddr0/C0_DDR4_S_AXI_CTRL] [get_bd_intf_pins interconnect_axil/M00_AXI]
  connect_bd_intf_net -intf_net ddr4_1_C0_DDR4 [get_bd_intf_ports ddr1] [get_bd_intf_pins ddr1/C0_DDR4]
  connect_bd_intf_net -intf_net ddr4_2_C0_DDR4 [get_bd_intf_ports ddr2] [get_bd_intf_pins ddr2/C0_DDR4]
  connect_bd_intf_net -intf_net ddr4_C0_DDR4 [get_bd_intf_ports ddr0] [get_bd_intf_pins ddr0/C0_DDR4]
  connect_bd_intf_net -intf_net interconnect_axi_M01_AXI [get_bd_intf_pins ddr1/C0_DDR4_S_AXI] [get_bd_intf_pins interconnect_axi/M01_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_M02_AXI [get_bd_intf_pins ddr2/C0_DDR4_S_AXI] [get_bd_intf_pins interconnect_axi/M02_AXI]
  connect_bd_intf_net -intf_net interconnect_axil_M01_AXI [get_bd_intf_pins ddr1/C0_DDR4_S_AXI_CTRL] [get_bd_intf_pins interconnect_axil/M01_AXI]
  connect_bd_intf_net -intf_net interconnect_axil_M02_AXI [get_bd_intf_pins ddr2/C0_DDR4_S_AXI_CTRL] [get_bd_intf_pins interconnect_axil/M02_AXI]
  connect_bd_intf_net -intf_net interconnect_axil_M03_AXI [get_bd_intf_pins axi_gpio/S_AXI] [get_bd_intf_pins interconnect_axil/M03_AXI]
  connect_bd_intf_net -intf_net sys_clk_1 [get_bd_intf_ports sys_clk] [get_bd_intf_pins buf_sysclk/CLK_IN_D]
  connect_bd_intf_net -intf_net xdma_ddr_M_AXI [get_bd_intf_pins interconnect_axi/S00_AXI] [get_bd_intf_pins xdma/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_ddr_M_AXI] [get_bd_intf_pins ila_ddr_axi/SLOT_0_AXI] [get_bd_intf_pins xdma/M_AXI]
  connect_bd_intf_net -intf_net xdma_ddr_M_AXI_LITE [get_bd_intf_pins interconnect_axil/S00_AXI] [get_bd_intf_pins xdma/M_AXI_LITE]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_ddr_M_AXI_LITE] [get_bd_intf_pins ila_ddr_axil/SLOT_0_AXI] [get_bd_intf_pins xdma/M_AXI_LITE]
  connect_bd_intf_net -intf_net xdma_soc_pcie_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma/pcie_mgt]

  # Create port connections
  connect_bd_net -net buf_sysclk_IBUF_DS_ODIV2 [get_bd_pins buf_sysclk/IBUF_DS_ODIV2] [get_bd_pins xdma/sys_clk]
  connect_bd_net -net buf_sysclk_IBUF_OUT [get_bd_pins buf_sysclk/IBUF_OUT] [get_bd_pins xdma/sys_clk_gt]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk [get_bd_pins ddr1/c0_ddr4_ui_clk] [get_bd_pins interconnect_axi/M01_ACLK] [get_bd_pins interconnect_axil/M01_ACLK]
  connect_bd_net -net ddr4_1_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr1/c0_ddr4_ui_clk_sync_rst] [get_bd_pins logic_not_uirst_1/Op1]
  connect_bd_net -net ddr4_2_c0_ddr4_ui_clk [get_bd_pins ddr2/c0_ddr4_ui_clk] [get_bd_pins interconnect_axi/M02_ACLK] [get_bd_pins interconnect_axil/M02_ACLK]
  connect_bd_net -net ddr4_2_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr2/c0_ddr4_ui_clk_sync_rst] [get_bd_pins logic_not_uirst_2/Op1]
  connect_bd_net -net ddr4_c0_ddr4_ui_clk [get_bd_pins ddr0/c0_ddr4_ui_clk] [get_bd_pins interconnect_axi/M00_ACLK] [get_bd_pins interconnect_axil/M00_ACLK]
  connect_bd_net -net ddr4_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins logic_not_uirst_0/Op1]
  connect_bd_net -net logic_not_Res [get_bd_pins ddr0/sys_rst] [get_bd_pins ddr1/sys_rst] [get_bd_pins ddr2/sys_rst] [get_bd_pins logic_not_sysrst/Res]
  connect_bd_net -net logic_not_uirst_1_Res [get_bd_pins ddr1/c0_ddr4_aresetn] [get_bd_pins interconnect_axi/M01_ARESETN] [get_bd_pins interconnect_axil/M01_ARESETN] [get_bd_pins logic_not_uirst_1/Res]
  connect_bd_net -net logic_not_uirst_2_Res [get_bd_pins ddr2/c0_ddr4_aresetn] [get_bd_pins interconnect_axi/M02_ARESETN] [get_bd_pins interconnect_axil/M02_ARESETN] [get_bd_pins logic_not_uirst_2/Res]
  connect_bd_net -net logic_not_uirst_Res [get_bd_pins ddr0/c0_ddr4_aresetn] [get_bd_pins interconnect_axi/M00_ARESETN] [get_bd_pins interconnect_axil/M00_ARESETN] [get_bd_pins logic_not_uirst_0/Res]
  connect_bd_net -net sys_rstn_1 [get_bd_ports sys_rstn] [get_bd_pins logic_not_sysrst/Op1] [get_bd_pins xdma/sys_rst_n]
  connect_bd_net -net xdma_ddr_axi_aclk [get_bd_pins axi_gpio/s_axi_aclk] [get_bd_pins ila_ddr_axi/clk] [get_bd_pins ila_ddr_axil/clk] [get_bd_pins interconnect_axi/ACLK] [get_bd_pins interconnect_axi/S00_ACLK] [get_bd_pins interconnect_axil/ACLK] [get_bd_pins interconnect_axil/M03_ACLK] [get_bd_pins interconnect_axil/S00_ACLK] [get_bd_pins xdma/axi_aclk]
  connect_bd_net -net xdma_ddr_axi_aresetn [get_bd_pins axi_gpio/s_axi_aresetn] [get_bd_pins interconnect_axi/ARESETN] [get_bd_pins interconnect_axi/S00_ARESETN] [get_bd_pins interconnect_axil/ARESETN] [get_bd_pins interconnect_axil/M03_ARESETN] [get_bd_pins interconnect_axil/S00_ARESETN] [get_bd_pins xdma/axi_aresetn]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs axi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs ddr0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs ddr0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force
  assign_bd_address -offset 0x000200000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs ddr1/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80100000 -range 0x00100000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs ddr1/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force
  assign_bd_address -offset 0x000400000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs ddr2/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80200000 -range 0x00100000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs ddr2/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


