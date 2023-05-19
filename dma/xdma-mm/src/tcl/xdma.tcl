
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
set scripts_vivado_version 2021.2
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
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:ila:6.2\
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

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]

  # Create instance: bram_axi, and set properties
  set bram_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bram_axi ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Read_Width_B {512} \
   CONFIG.Write_Width_B {512} \
 ] $bram_axi

  # Create instance: bram_axil1, and set properties
  set bram_axil1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bram_axil1 ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
 ] $bram_axil1

  # Create instance: bram_axil2, and set properties
  set bram_axil2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bram_axil2 ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
 ] $bram_axil2

  # Create instance: bram_bypass, and set properties
  set bram_bypass [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bram_bypass ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
 ] $bram_bypass

  # Create instance: bram_ctrl_axi, and set properties
  set bram_ctrl_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl_axi ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_ctrl_axi

  # Create instance: bram_ctrl_axil1, and set properties
  set bram_ctrl_axil1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl_axil1 ]
  set_property -dict [ list \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.SINGLE_PORT_BRAM {1} \
   CONFIG.SUPPORTS_NARROW_BURST {0} \
 ] $bram_ctrl_axil1

  # Create instance: bram_ctrl_axil2, and set properties
  set bram_ctrl_axil2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl_axil2 ]
  set_property -dict [ list \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_ctrl_axil2

  # Create instance: bram_ctrl_bypass, and set properties
  set bram_ctrl_bypass [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl_bypass ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {512} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_ctrl_bypass

  # Create instance: buf_sysclk, and set properties
  set buf_sysclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 buf_sysclk ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $buf_sysclk

  # Create instance: ila_axi, and set properties
  set ila_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_axi ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {true} \
   CONFIG.C_MONITOR_TYPE {AXI} \
   CONFIG.C_NUM_OF_PROBES {44} \
 ] $ila_axi

  # Create instance: ila_axil1, and set properties
  set ila_axil1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_axil1 ]
  set_property -dict [ list \
   CONFIG.C_ENABLE_ILA_AXI_MON {true} \
   CONFIG.C_MONITOR_TYPE {AXI} \
   CONFIG.C_NUM_OF_PROBES {19} \
 ] $ila_axil1

  # Create instance: ila_axil2, and set properties
  set ila_axil2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_axil2 ]

  # Create instance: ila_bypass, and set properties
  set ila_bypass [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_bypass ]

  # Create instance: xdma, and set properties
  set xdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma ]
  set_property -dict [ list \
   CONFIG.PF0_DEVICE_ID_mqdma {903F} \
   CONFIG.PF0_SRIOV_VF_DEVICE_ID {A03F} \
   CONFIG.PF1_SRIOV_VF_DEVICE_ID {A13F} \
   CONFIG.PF2_DEVICE_ID_mqdma {0007} \
   CONFIG.PF2_SRIOV_VF_DEVICE_ID {A23F} \
   CONFIG.PF3_DEVICE_ID_mqdma {933F} \
   CONFIG.PF3_SRIOV_VF_DEVICE_ID {A33F} \
   CONFIG.axi_bypass_64bit_en {true} \
   CONFIG.axi_bypass_prefetchable {true} \
   CONFIG.axi_data_width {512_bit} \
   CONFIG.axil_master_64bit_en {true} \
   CONFIG.axil_master_prefetchable {true} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axist_bypass_en {true} \
   CONFIG.axisten_freq {250} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.coreclk_freq {500} \
   CONFIG.en_axi_slave_if {false} \
   CONFIG.pcie_blk_locn {PCIE4C_X1Y0} \
   CONFIG.pf0_class_code {070001} \
   CONFIG.pf0_class_code_interface {01} \
   CONFIG.pf0_device_id {903F} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_3:2} \
   CONFIG.pf0_msix_cap_table_bir {BAR_3:2} \
   CONFIG.pf0_sub_class_interface_menu {16450_compatible_serial_controller} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X16} \
   CONFIG.plltype {QPLL1} \
   CONFIG.select_quad {GTY_Quad_227} \
   CONFIG.xdma_pcie_64bit_en {true} \
   CONFIG.xdma_pcie_prefetchable {true} \
 ] $xdma

  # Create interface connections
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports sys_clk] [get_bd_intf_pins buf_sysclk/CLK_IN_D]
  connect_bd_intf_net -intf_net axi_bram_ctrl_2_BRAM_PORTA [get_bd_intf_pins bram_axil1/BRAM_PORTA] [get_bd_intf_pins bram_ctrl_axil1/BRAM_PORTA]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins bram_ctrl_axil1/S_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M00_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins ila_axil1/SLOT_0_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M01_AXI [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins bram_ctrl_axil2/S_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets axi_interconnect_0_M01_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI] [get_bd_intf_pins ila_axil2/SLOT_0_AXI]
  connect_bd_intf_net -intf_net bram_ctrl_axi_BRAM_PORTA [get_bd_intf_pins bram_axi/BRAM_PORTA] [get_bd_intf_pins bram_ctrl_axi/BRAM_PORTA]
  connect_bd_intf_net -intf_net bram_ctrl_axil2_BRAM_PORTA [get_bd_intf_pins bram_axil2/BRAM_PORTA] [get_bd_intf_pins bram_ctrl_axil2/BRAM_PORTA]
  connect_bd_intf_net -intf_net bram_ctrl_bypass_BRAM_PORTA [get_bd_intf_pins bram_bypass/BRAM_PORTA] [get_bd_intf_pins bram_ctrl_bypass/BRAM_PORTA]
  connect_bd_intf_net -intf_net xdma_0_M_AXI [get_bd_intf_pins bram_ctrl_axi/S_AXI] [get_bd_intf_pins xdma/M_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_0_M_AXI] [get_bd_intf_pins ila_axi/SLOT_0_AXI] [get_bd_intf_pins xdma/M_AXI]
  connect_bd_intf_net -intf_net xdma_M_AXI_BYPASS [get_bd_intf_pins bram_ctrl_bypass/S_AXI] [get_bd_intf_pins xdma/M_AXI_BYPASS]
connect_bd_intf_net -intf_net [get_bd_intf_nets xdma_M_AXI_BYPASS] [get_bd_intf_pins ila_bypass/SLOT_0_AXI] [get_bd_intf_pins xdma/M_AXI_BYPASS]
  connect_bd_intf_net -intf_net xdma_M_AXI_LITE [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins xdma/M_AXI_LITE]
  connect_bd_intf_net -intf_net xdma_pcie_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma/pcie_mgt]

  # Create port connections
  connect_bd_net -net buf_sysclk_IBUF_DS_ODIV2 [get_bd_pins buf_sysclk/IBUF_DS_ODIV2] [get_bd_pins xdma/sys_clk]
  connect_bd_net -net buf_sysclk_IBUF_OUT [get_bd_pins buf_sysclk/IBUF_OUT] [get_bd_pins xdma/sys_clk_gt]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins bram_ctrl_axi/s_axi_aresetn] [get_bd_pins bram_ctrl_axil1/s_axi_aresetn] [get_bd_pins bram_ctrl_axil2/s_axi_aresetn] [get_bd_pins bram_ctrl_bypass/s_axi_aresetn] [get_bd_pins xdma/axi_aresetn]
  connect_bd_net -net sys_rstn_1 [get_bd_ports sys_rstn] [get_bd_pins xdma/sys_rst_n]
  connect_bd_net -net xdma_0_axi_aclk [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins bram_ctrl_axi/s_axi_aclk] [get_bd_pins bram_ctrl_axil1/s_axi_aclk] [get_bd_pins bram_ctrl_axil2/s_axi_aclk] [get_bd_pins bram_ctrl_bypass/s_axi_aclk] [get_bd_pins ila_axi/clk] [get_bd_pins ila_axil1/clk] [get_bd_pins ila_axil2/clk] [get_bd_pins ila_bypass/clk] [get_bd_pins xdma/axi_aclk]

  # Create address segments
  assign_bd_address -offset 0x00020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs bram_ctrl_axi/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs bram_ctrl_axil1/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00002000 -range 0x00002000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs bram_ctrl_axil2/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_BYPASS] [get_bd_addr_segs bram_ctrl_bypass/S_AXI/Mem0] -force


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


