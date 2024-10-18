
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
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:util_ds_buf:2.1\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:hbm:1.0\
xilinx.com:ip:ila:6.2\
xilinx.com:ip:proc_sys_reset:5.0\
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
  set cu_axi0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi0 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {1} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi0

  set cu_axi1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi1 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi1

  set cu_axi2 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi2 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi2

  set cu_axi3 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi3 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi3

  set cu_axi4 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi4 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi4

  set cu_axi5 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi5 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi5

  set cu_axi6 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi6 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi6

  set cu_axi7 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi7 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi7

  set cu_axi8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi8 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi8

  set cu_axi9 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi9 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi9

  set cu_axi10 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi10 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi10

  set cu_axi11 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi11 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi11

  set cu_axi12 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi12 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi12

  set cu_axi13 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi13 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi13

  set cu_axi14 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi14 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi14

  set cu_axi15 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 cu_axi15 ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {33} \
   CONFIG.ARUSER_WIDTH {0} \
   CONFIG.AWUSER_WIDTH {0} \
   CONFIG.BUSER_WIDTH {0} \
   CONFIG.DATA_WIDTH {256} \
   CONFIG.FREQ_HZ {450000000} \
   CONFIG.HAS_BRESP {1} \
   CONFIG.HAS_BURST {1} \
   CONFIG.HAS_CACHE {1} \
   CONFIG.HAS_LOCK {1} \
   CONFIG.HAS_PROT {1} \
   CONFIG.HAS_QOS {1} \
   CONFIG.HAS_REGION {0} \
   CONFIG.HAS_RRESP {1} \
   CONFIG.HAS_WSTRB {1} \
   CONFIG.ID_WIDTH {0} \
   CONFIG.MAX_BURST_LENGTH {16} \
   CONFIG.NUM_READ_OUTSTANDING {2} \
   CONFIG.NUM_READ_THREADS {1} \
   CONFIG.NUM_WRITE_OUTSTANDING {2} \
   CONFIG.NUM_WRITE_THREADS {1} \
   CONFIG.PROTOCOL {AXI4} \
   CONFIG.READ_WRITE_MODE {READ_WRITE} \
   CONFIG.RUSER_BITS_PER_BYTE {0} \
   CONFIG.RUSER_WIDTH {0} \
   CONFIG.SUPPORTS_NARROW_BURST {1} \
   CONFIG.WUSER_BITS_PER_BYTE {0} \
   CONFIG.WUSER_WIDTH {0} \
   ] $cu_axi15

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]

  set sys_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {100000000} \
   ] $sys_clk


  # Create ports
  set gpio [ create_bd_port -dir O -from 31 -to 0 gpio ]
  set hbm_aclk [ create_bd_port -dir O -type clk hbm_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {cu_axi4:cu_axi2:cu_axi3:cu_axi5:cu_axi6:cu_axi1:cu_axi7:cu_axi8:cu_axi9:cu_axi10:cu_axi11:cu_axi12:cu_axi13:cu_axi14:cu_axi0:cu_axi15} \
   CONFIG.FREQ_HZ {450000000} \
 ] $hbm_aclk
  set hbm_refclk [ create_bd_port -dir I -type clk hbm_refclk ]
  set irq_req [ create_bd_port -dir I -from 0 -to 0 irq_req ]
  set msi_enable [ create_bd_port -dir O msi_enable ]
  set sys_rstn [ create_bd_port -dir I -type rst sys_rstn ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $sys_rstn
  set xdma_aclk [ create_bd_port -dir O -type clk xdma_aclk ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {} \
   CONFIG.FREQ_HZ {250000000} \
 ] $xdma_aclk
  set xdma_rstn [ create_bd_port -dir O -from 0 -to 0 xdma_rstn ]

  # Create instance: axi_gpio_pme, and set properties
  set axi_gpio_pme [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_pme ]
  set_property -dict [ list \
   CONFIG.C_ALL_OUTPUTS {1} \
   CONFIG.C_ALL_OUTPUTS_2 {0} \
   CONFIG.C_GPIO_WIDTH {32} \
   CONFIG.C_IS_DUAL {0} \
 ] $axi_gpio_pme

  # Create instance: bram_axil, and set properties
  set bram_axil [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 bram_axil ]
  set_property -dict [ list \
   CONFIG.EN_SAFETY_CKT {false} \
 ] $bram_axil

  # Create instance: bram_ctrl_axil, and set properties
  set bram_ctrl_axil [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 bram_ctrl_axil ]
  set_property -dict [ list \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.ECC_TYPE {0} \
   CONFIG.PROTOCOL {AXI4LITE} \
   CONFIG.SINGLE_PORT_BRAM {1} \
 ] $bram_ctrl_axil

  # Create instance: buf_sysclk, and set properties
  set buf_sysclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 buf_sysclk ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $buf_sysclk

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {40.0} \
   CONFIG.CLKOUT1_JITTER {121.297} \
   CONFIG.CLKOUT1_PHASE_ERROR {142.582} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLKOUT2_JITTER {94.370} \
   CONFIG.CLKOUT2_PHASE_ERROR {142.582} \
   CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {450.000} \
   CONFIG.CLKOUT2_USED {true} \
   CONFIG.CLKOUT3_JITTER {167.067} \
   CONFIG.CLKOUT3_PHASE_ERROR {161.613} \
   CONFIG.CLKOUT3_USED {false} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {27.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {4.000} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {13.500} \
   CONFIG.MMCM_CLKOUT1_DIVIDE {3} \
   CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
   CONFIG.MMCM_DIVCLK_DIVIDE {5} \
   CONFIG.NUM_OUT_CLKS {2} \
   CONFIG.RESET_PORT {resetn} \
   CONFIG.RESET_TYPE {ACTIVE_LOW} \
   CONFIG.USE_LOCKED {false} \
 ] $clk_wiz

  # Create instance: hbm_inst, and set properties
  set hbm_inst [ create_bd_cell -type ip -vlnv xilinx.com:ip:hbm:1.0 hbm_inst ]
  set_property -dict [ list \
   CONFIG.HBM_MMCM1_FBOUT_MULT0 {9} \
   CONFIG.HBM_MMCM_FBOUT_MULT0 {9} \
   CONFIG.USER_APB_EN {false} \
   CONFIG.USER_AXI_CLK1_FREQ {450} \
   CONFIG.USER_AXI_CLK_FREQ {450} \
   CONFIG.USER_CLK_SEL_LIST0 {AXI_07_ACLK} \
   CONFIG.USER_CLK_SEL_LIST1 {AXI_16_ACLK} \
   CONFIG.USER_DIS_REF_CLK_BUFG {FALSE} \
   CONFIG.USER_HBM_CP_1 {6} \
   CONFIG.USER_HBM_DENSITY {8GB} \
   CONFIG.USER_HBM_FBDIV_1 {36} \
   CONFIG.USER_HBM_HEX_CP_RES_1 {0x0000A600} \
   CONFIG.USER_HBM_HEX_FBDIV_CLKOUTDIV_1 {0x00000902} \
   CONFIG.USER_HBM_HEX_LOCK_FB_REF_DLY_1 {0x00001f1f} \
   CONFIG.USER_HBM_LOCK_FB_DLY_1 {31} \
   CONFIG.USER_HBM_LOCK_REF_DLY_1 {31} \
   CONFIG.USER_HBM_RES_1 {10} \
   CONFIG.USER_HBM_STACK {2} \
   CONFIG.USER_INIT_TIMEOUT_VAL {0} \
   CONFIG.USER_MC0_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC0_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC0_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC0_EN_DATA_MASK {false} \
   CONFIG.USER_MC0_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC0_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC10_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC10_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC10_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC10_EN_DATA_MASK {false} \
   CONFIG.USER_MC10_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC10_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC11_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC11_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC11_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC11_EN_DATA_MASK {false} \
   CONFIG.USER_MC11_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC11_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC12_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC12_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC12_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC12_EN_DATA_MASK {false} \
   CONFIG.USER_MC12_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC12_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC13_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC13_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC13_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC13_EN_DATA_MASK {false} \
   CONFIG.USER_MC13_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC13_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC14_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC14_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC14_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC14_EN_DATA_MASK {false} \
   CONFIG.USER_MC14_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC14_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC15_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC15_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC15_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC15_EN_DATA_MASK {false} \
   CONFIG.USER_MC15_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC15_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC1_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC1_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC1_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC1_EN_DATA_MASK {false} \
   CONFIG.USER_MC1_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC1_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC2_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC2_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC2_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC2_EN_DATA_MASK {false} \
   CONFIG.USER_MC2_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC2_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC3_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC3_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC3_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC3_EN_DATA_MASK {false} \
   CONFIG.USER_MC3_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC3_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC4_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC4_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC4_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC4_EN_DATA_MASK {false} \
   CONFIG.USER_MC4_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC4_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC5_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC5_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC5_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC5_EN_DATA_MASK {false} \
   CONFIG.USER_MC5_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC5_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC6_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC6_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC6_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC6_EN_DATA_MASK {false} \
   CONFIG.USER_MC6_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC6_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC7_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC7_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC7_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC7_EN_DATA_MASK {false} \
   CONFIG.USER_MC7_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC7_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC8_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC8_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC8_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC8_EN_DATA_MASK {false} \
   CONFIG.USER_MC8_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC8_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC9_ECC_SCRUB_PERIOD {0x0032} \
   CONFIG.USER_MC9_ENABLE_ECC_CORRECTION {true} \
   CONFIG.USER_MC9_ENABLE_ECC_SCRUBBING {true} \
   CONFIG.USER_MC9_EN_DATA_MASK {false} \
   CONFIG.USER_MC9_INITILIZE_MEM_USING_ECC_SCRUB {true} \
   CONFIG.USER_MC9_TEMP_CTRL_SELF_REF_INTVL {true} \
   CONFIG.USER_MC_ENABLE_00 {TRUE} \
   CONFIG.USER_MC_ENABLE_01 {TRUE} \
   CONFIG.USER_MC_ENABLE_02 {TRUE} \
   CONFIG.USER_MC_ENABLE_03 {TRUE} \
   CONFIG.USER_MC_ENABLE_04 {TRUE} \
   CONFIG.USER_MC_ENABLE_05 {TRUE} \
   CONFIG.USER_MC_ENABLE_06 {TRUE} \
   CONFIG.USER_MC_ENABLE_07 {TRUE} \
   CONFIG.USER_MC_ENABLE_08 {TRUE} \
   CONFIG.USER_MC_ENABLE_09 {TRUE} \
   CONFIG.USER_MC_ENABLE_10 {TRUE} \
   CONFIG.USER_MC_ENABLE_11 {TRUE} \
   CONFIG.USER_MC_ENABLE_12 {TRUE} \
   CONFIG.USER_MC_ENABLE_13 {TRUE} \
   CONFIG.USER_MC_ENABLE_14 {TRUE} \
   CONFIG.USER_MC_ENABLE_15 {TRUE} \
   CONFIG.USER_MC_ENABLE_APB_01 {TRUE} \
   CONFIG.USER_MEMORY_DISPLAY {8192} \
   CONFIG.USER_PHY_ENABLE_08 {TRUE} \
   CONFIG.USER_PHY_ENABLE_09 {TRUE} \
   CONFIG.USER_PHY_ENABLE_10 {TRUE} \
   CONFIG.USER_PHY_ENABLE_11 {TRUE} \
   CONFIG.USER_PHY_ENABLE_12 {TRUE} \
   CONFIG.USER_PHY_ENABLE_13 {TRUE} \
   CONFIG.USER_PHY_ENABLE_14 {TRUE} \
   CONFIG.USER_PHY_ENABLE_15 {TRUE} \
   CONFIG.USER_SAXI_00 {true} \
   CONFIG.USER_SAXI_01 {true} \
   CONFIG.USER_SAXI_02 {true} \
   CONFIG.USER_SAXI_03 {true} \
   CONFIG.USER_SAXI_04 {true} \
   CONFIG.USER_SAXI_05 {true} \
   CONFIG.USER_SAXI_06 {true} \
   CONFIG.USER_SAXI_07 {true} \
   CONFIG.USER_SAXI_08 {true} \
   CONFIG.USER_SAXI_09 {true} \
   CONFIG.USER_SAXI_10 {true} \
   CONFIG.USER_SAXI_11 {true} \
   CONFIG.USER_SAXI_12 {true} \
   CONFIG.USER_SAXI_13 {true} \
   CONFIG.USER_SAXI_14 {true} \
   CONFIG.USER_SAXI_15 {true} \
   CONFIG.USER_SAXI_16 {true} \
   CONFIG.USER_SAXI_17 {false} \
   CONFIG.USER_SAXI_18 {false} \
   CONFIG.USER_SAXI_19 {false} \
   CONFIG.USER_SAXI_20 {false} \
   CONFIG.USER_SAXI_21 {false} \
   CONFIG.USER_SAXI_22 {false} \
   CONFIG.USER_SAXI_23 {false} \
   CONFIG.USER_SAXI_24 {false} \
   CONFIG.USER_SAXI_25 {false} \
   CONFIG.USER_SAXI_26 {false} \
   CONFIG.USER_SAXI_27 {false} \
   CONFIG.USER_SAXI_28 {false} \
   CONFIG.USER_SAXI_29 {false} \
   CONFIG.USER_SAXI_30 {false} \
   CONFIG.USER_SAXI_31 {false} \
   CONFIG.USER_SWITCH_ENABLE_01 {TRUE} \
 ] $hbm_inst

  # Create instance: ila_cu0, and set properties
  set ila_cu0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_cu0 ]

  # Create instance: ila_cu15, and set properties
  set ila_cu15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_cu15 ]

  # Create instance: interconnect_axi_cu0, and set properties
  set interconnect_axi_cu0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu0

  # Create instance: interconnect_axi_cu1, and set properties
  set interconnect_axi_cu1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu1 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu1

  # Create instance: interconnect_axi_cu2, and set properties
  set interconnect_axi_cu2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu2 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu2

  # Create instance: interconnect_axi_cu3, and set properties
  set interconnect_axi_cu3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu3 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu3

  # Create instance: interconnect_axi_cu4, and set properties
  set interconnect_axi_cu4 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu4 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu4

  # Create instance: interconnect_axi_cu5, and set properties
  set interconnect_axi_cu5 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu5 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu5

  # Create instance: interconnect_axi_cu6, and set properties
  set interconnect_axi_cu6 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu6 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu6

  # Create instance: interconnect_axi_cu7, and set properties
  set interconnect_axi_cu7 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu7 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu7

  # Create instance: interconnect_axi_cu8, and set properties
  set interconnect_axi_cu8 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu8 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu8

  # Create instance: interconnect_axi_cu9, and set properties
  set interconnect_axi_cu9 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu9 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu9

  # Create instance: interconnect_axi_cu10, and set properties
  set interconnect_axi_cu10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu10 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu10

  # Create instance: interconnect_axi_cu11, and set properties
  set interconnect_axi_cu11 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu11 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu11

  # Create instance: interconnect_axi_cu12, and set properties
  set interconnect_axi_cu12 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu12 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu12

  # Create instance: interconnect_axi_cu13, and set properties
  set interconnect_axi_cu13 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu13 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu13

  # Create instance: interconnect_axi_cu14, and set properties
  set interconnect_axi_cu14 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu14 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu14

  # Create instance: interconnect_axi_cu15, and set properties
  set interconnect_axi_cu15 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_cu15 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
   CONFIG.S00_HAS_REGSLICE {0} \
 ] $interconnect_axi_cu15

  # Create instance: interconnect_axi_xdma, and set properties
  set interconnect_axi_xdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axi_xdma ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.S00_HAS_DATA_FIFO {0} \
 ] $interconnect_axi_xdma

  # Create instance: interconnect_axil, and set properties
  set interconnect_axil [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 interconnect_axil ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
 ] $interconnect_axil

  # Create instance: proc_sys_reset_100m, and set properties
  set proc_sys_reset_100m [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_100m ]

  # Create instance: proc_sys_reset_450m, and set properties
  set proc_sys_reset_450m [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_450m ]

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
   CONFIG.axilite_master_size {256} \
   CONFIG.axist_bypass_en {false} \
   CONFIG.axisten_freq {250} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.coreclk_freq {500} \
   CONFIG.pcie_blk_locn {PCIE4C_X1Y0} \
   CONFIG.pf0_device_id {903F} \
   CONFIG.pf0_msi_cap_multimsgcap {1_vector} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_3:2} \
   CONFIG.pf0_msix_cap_table_bir {BAR_3:2} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X16} \
   CONFIG.plltype {QPLL1} \
   CONFIG.select_quad {GTY_Quad_227} \
   CONFIG.vendor_id {1BD4} \
   CONFIG.xdma_num_usr_irq {1} \
   CONFIG.xdma_pcie_64bit_en {true} \
   CONFIG.xdma_pcie_prefetchable {true} \
 ] $xdma

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_0_1 [get_bd_intf_ports cu_axi0] [get_bd_intf_pins interconnect_axi_cu0/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets S00_AXI_0_1] [get_bd_intf_ports cu_axi0] [get_bd_intf_pins ila_cu0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_2 [get_bd_intf_ports cu_axi1] [get_bd_intf_pins interconnect_axi_cu1/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_3 [get_bd_intf_ports cu_axi2] [get_bd_intf_pins interconnect_axi_cu2/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_4 [get_bd_intf_ports cu_axi11] [get_bd_intf_pins interconnect_axi_cu11/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_5 [get_bd_intf_ports cu_axi12] [get_bd_intf_pins interconnect_axi_cu12/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_6 [get_bd_intf_ports cu_axi10] [get_bd_intf_pins interconnect_axi_cu10/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_7 [get_bd_intf_ports cu_axi13] [get_bd_intf_pins interconnect_axi_cu13/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_8 [get_bd_intf_ports cu_axi14] [get_bd_intf_pins interconnect_axi_cu14/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_9 [get_bd_intf_ports cu_axi15] [get_bd_intf_pins interconnect_axi_cu15/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets S00_AXI_0_9] [get_bd_intf_ports cu_axi15] [get_bd_intf_pins ila_cu15/SLOT_0_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_10 [get_bd_intf_ports cu_axi4] [get_bd_intf_pins interconnect_axi_cu4/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_11 [get_bd_intf_ports cu_axi3] [get_bd_intf_pins interconnect_axi_cu3/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_12 [get_bd_intf_ports cu_axi7] [get_bd_intf_pins interconnect_axi_cu7/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_13 [get_bd_intf_ports cu_axi8] [get_bd_intf_pins interconnect_axi_cu8/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_14 [get_bd_intf_ports cu_axi5] [get_bd_intf_pins interconnect_axi_cu5/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_15 [get_bd_intf_ports cu_axi6] [get_bd_intf_pins interconnect_axi_cu6/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_0_16 [get_bd_intf_ports cu_axi9] [get_bd_intf_pins interconnect_axi_cu9/S00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins interconnect_axil/S00_AXI] [get_bd_intf_pins xdma/M_AXI_LITE]
  connect_bd_intf_net -intf_net bram_ctrl_axil_BRAM_PORTA [get_bd_intf_pins bram_axil/BRAM_PORTA] [get_bd_intf_pins bram_ctrl_axil/BRAM_PORTA]
  connect_bd_intf_net -intf_net interconnect_axi_cu0_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_00] [get_bd_intf_pins interconnect_axi_cu0/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu10_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_10] [get_bd_intf_pins interconnect_axi_cu10/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu11_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_11] [get_bd_intf_pins interconnect_axi_cu11/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu12_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_12] [get_bd_intf_pins interconnect_axi_cu12/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu13_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_13] [get_bd_intf_pins interconnect_axi_cu13/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu14_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_14] [get_bd_intf_pins interconnect_axi_cu14/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu15_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_15] [get_bd_intf_pins interconnect_axi_cu15/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu1_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_01] [get_bd_intf_pins interconnect_axi_cu1/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu2_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_02] [get_bd_intf_pins interconnect_axi_cu2/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu3_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_03] [get_bd_intf_pins interconnect_axi_cu3/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu4_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_04] [get_bd_intf_pins interconnect_axi_cu4/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu5_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_05] [get_bd_intf_pins interconnect_axi_cu5/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu6_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_06] [get_bd_intf_pins interconnect_axi_cu6/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu7_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_07] [get_bd_intf_pins interconnect_axi_cu7/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu8_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_08] [get_bd_intf_pins interconnect_axi_cu8/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_cu9_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_09] [get_bd_intf_pins interconnect_axi_cu9/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axi_xdma_M00_AXI [get_bd_intf_pins hbm_inst/SAXI_16] [get_bd_intf_pins interconnect_axi_xdma/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axil_M00_AXI [get_bd_intf_pins bram_ctrl_axil/S_AXI] [get_bd_intf_pins interconnect_axil/M00_AXI]
  connect_bd_intf_net -intf_net interconnect_axil_M01_AXI [get_bd_intf_pins axi_gpio_pme/S_AXI] [get_bd_intf_pins interconnect_axil/M01_AXI]
  connect_bd_intf_net -intf_net sys_clk_1 [get_bd_intf_ports sys_clk] [get_bd_intf_pins buf_sysclk/CLK_IN_D]
  connect_bd_intf_net -intf_net xdma_M_AXI [get_bd_intf_pins interconnect_axi_xdma/S00_AXI] [get_bd_intf_pins xdma/M_AXI]
  connect_bd_intf_net -intf_net xdma_soc_pcie_mgt [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma/pcie_mgt]

  # Create port connections
  connect_bd_net -net axi_gpio_pme_gpio_io_o [get_bd_ports gpio] [get_bd_pins axi_gpio_pme/gpio_io_o]
  connect_bd_net -net buf_sysclk_IBUF_DS_ODIV2 [get_bd_pins buf_sysclk/IBUF_DS_ODIV2] [get_bd_pins xdma/sys_clk]
  connect_bd_net -net buf_sysclk_IBUF_OUT [get_bd_pins buf_sysclk/IBUF_OUT] [get_bd_pins xdma/sys_clk_gt]
  connect_bd_net -net clk_wiz_clk_out1 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins hbm_inst/APB_0_PCLK] [get_bd_pins hbm_inst/APB_1_PCLK] [get_bd_pins proc_sys_reset_100m/slowest_sync_clk]
  connect_bd_net -net clk_wiz_clk_out2 [get_bd_ports hbm_aclk] [get_bd_pins clk_wiz/clk_out2] [get_bd_pins hbm_inst/AXI_00_ACLK] [get_bd_pins hbm_inst/AXI_01_ACLK] [get_bd_pins hbm_inst/AXI_02_ACLK] [get_bd_pins hbm_inst/AXI_03_ACLK] [get_bd_pins hbm_inst/AXI_04_ACLK] [get_bd_pins hbm_inst/AXI_05_ACLK] [get_bd_pins hbm_inst/AXI_06_ACLK] [get_bd_pins hbm_inst/AXI_07_ACLK] [get_bd_pins hbm_inst/AXI_08_ACLK] [get_bd_pins hbm_inst/AXI_09_ACLK] [get_bd_pins hbm_inst/AXI_10_ACLK] [get_bd_pins hbm_inst/AXI_11_ACLK] [get_bd_pins hbm_inst/AXI_12_ACLK] [get_bd_pins hbm_inst/AXI_13_ACLK] [get_bd_pins hbm_inst/AXI_14_ACLK] [get_bd_pins hbm_inst/AXI_15_ACLK] [get_bd_pins ila_cu0/clk] [get_bd_pins ila_cu15/clk] [get_bd_pins interconnect_axi_cu0/ACLK] [get_bd_pins interconnect_axi_cu0/M00_ACLK] [get_bd_pins interconnect_axi_cu0/S00_ACLK] [get_bd_pins interconnect_axi_cu1/ACLK] [get_bd_pins interconnect_axi_cu1/M00_ACLK] [get_bd_pins interconnect_axi_cu1/S00_ACLK] [get_bd_pins interconnect_axi_cu10/ACLK] [get_bd_pins interconnect_axi_cu10/M00_ACLK] [get_bd_pins interconnect_axi_cu10/S00_ACLK] [get_bd_pins interconnect_axi_cu11/ACLK] [get_bd_pins interconnect_axi_cu11/M00_ACLK] [get_bd_pins interconnect_axi_cu11/S00_ACLK] [get_bd_pins interconnect_axi_cu12/ACLK] [get_bd_pins interconnect_axi_cu12/M00_ACLK] [get_bd_pins interconnect_axi_cu12/S00_ACLK] [get_bd_pins interconnect_axi_cu13/ACLK] [get_bd_pins interconnect_axi_cu13/M00_ACLK] [get_bd_pins interconnect_axi_cu13/S00_ACLK] [get_bd_pins interconnect_axi_cu14/ACLK] [get_bd_pins interconnect_axi_cu14/M00_ACLK] [get_bd_pins interconnect_axi_cu14/S00_ACLK] [get_bd_pins interconnect_axi_cu15/ACLK] [get_bd_pins interconnect_axi_cu15/M00_ACLK] [get_bd_pins interconnect_axi_cu15/S00_ACLK] [get_bd_pins interconnect_axi_cu2/ACLK] [get_bd_pins interconnect_axi_cu2/M00_ACLK] [get_bd_pins interconnect_axi_cu2/S00_ACLK] [get_bd_pins interconnect_axi_cu3/ACLK] [get_bd_pins interconnect_axi_cu3/M00_ACLK] [get_bd_pins interconnect_axi_cu3/S00_ACLK] [get_bd_pins interconnect_axi_cu4/ACLK] [get_bd_pins interconnect_axi_cu4/M00_ACLK] [get_bd_pins interconnect_axi_cu4/S00_ACLK] [get_bd_pins interconnect_axi_cu5/ACLK] [get_bd_pins interconnect_axi_cu5/M00_ACLK] [get_bd_pins interconnect_axi_cu5/S00_ACLK] [get_bd_pins interconnect_axi_cu6/ACLK] [get_bd_pins interconnect_axi_cu6/M00_ACLK] [get_bd_pins interconnect_axi_cu6/S00_ACLK] [get_bd_pins interconnect_axi_cu7/ACLK] [get_bd_pins interconnect_axi_cu7/M00_ACLK] [get_bd_pins interconnect_axi_cu7/S00_ACLK] [get_bd_pins interconnect_axi_cu8/ACLK] [get_bd_pins interconnect_axi_cu8/M00_ACLK] [get_bd_pins interconnect_axi_cu8/S00_ACLK] [get_bd_pins interconnect_axi_cu9/ACLK] [get_bd_pins interconnect_axi_cu9/M00_ACLK] [get_bd_pins interconnect_axi_cu9/S00_ACLK] [get_bd_pins proc_sys_reset_450m/slowest_sync_clk]
  connect_bd_net -net hbm_refclk_1 [get_bd_ports hbm_refclk] [get_bd_pins hbm_inst/HBM_REF_CLK_0] [get_bd_pins hbm_inst/HBM_REF_CLK_1]
  connect_bd_net -net proc_sys_reset_100m_interconnect_aresetn [get_bd_pins hbm_inst/APB_0_PRESET_N] [get_bd_pins hbm_inst/APB_1_PRESET_N] [get_bd_pins proc_sys_reset_100m/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_450m_interconnect_aresetn [get_bd_pins hbm_inst/AXI_00_ARESET_N] [get_bd_pins hbm_inst/AXI_01_ARESET_N] [get_bd_pins hbm_inst/AXI_02_ARESET_N] [get_bd_pins hbm_inst/AXI_03_ARESET_N] [get_bd_pins hbm_inst/AXI_04_ARESET_N] [get_bd_pins hbm_inst/AXI_05_ARESET_N] [get_bd_pins hbm_inst/AXI_06_ARESET_N] [get_bd_pins hbm_inst/AXI_07_ARESET_N] [get_bd_pins hbm_inst/AXI_08_ARESET_N] [get_bd_pins hbm_inst/AXI_09_ARESET_N] [get_bd_pins hbm_inst/AXI_10_ARESET_N] [get_bd_pins hbm_inst/AXI_11_ARESET_N] [get_bd_pins hbm_inst/AXI_12_ARESET_N] [get_bd_pins hbm_inst/AXI_13_ARESET_N] [get_bd_pins hbm_inst/AXI_14_ARESET_N] [get_bd_pins hbm_inst/AXI_15_ARESET_N] [get_bd_pins interconnect_axi_cu0/ARESETN] [get_bd_pins interconnect_axi_cu0/M00_ARESETN] [get_bd_pins interconnect_axi_cu0/S00_ARESETN] [get_bd_pins interconnect_axi_cu1/ARESETN] [get_bd_pins interconnect_axi_cu1/M00_ARESETN] [get_bd_pins interconnect_axi_cu1/S00_ARESETN] [get_bd_pins interconnect_axi_cu10/ARESETN] [get_bd_pins interconnect_axi_cu10/M00_ARESETN] [get_bd_pins interconnect_axi_cu10/S00_ARESETN] [get_bd_pins interconnect_axi_cu11/ARESETN] [get_bd_pins interconnect_axi_cu11/M00_ARESETN] [get_bd_pins interconnect_axi_cu11/S00_ARESETN] [get_bd_pins interconnect_axi_cu12/ARESETN] [get_bd_pins interconnect_axi_cu12/M00_ARESETN] [get_bd_pins interconnect_axi_cu12/S00_ARESETN] [get_bd_pins interconnect_axi_cu13/ARESETN] [get_bd_pins interconnect_axi_cu13/M00_ARESETN] [get_bd_pins interconnect_axi_cu13/S00_ARESETN] [get_bd_pins interconnect_axi_cu14/ARESETN] [get_bd_pins interconnect_axi_cu14/M00_ARESETN] [get_bd_pins interconnect_axi_cu14/S00_ARESETN] [get_bd_pins interconnect_axi_cu15/ARESETN] [get_bd_pins interconnect_axi_cu15/M00_ARESETN] [get_bd_pins interconnect_axi_cu15/S00_ARESETN] [get_bd_pins interconnect_axi_cu2/ARESETN] [get_bd_pins interconnect_axi_cu2/M00_ARESETN] [get_bd_pins interconnect_axi_cu2/S00_ARESETN] [get_bd_pins interconnect_axi_cu3/ARESETN] [get_bd_pins interconnect_axi_cu3/M00_ARESETN] [get_bd_pins interconnect_axi_cu3/S00_ARESETN] [get_bd_pins interconnect_axi_cu4/ARESETN] [get_bd_pins interconnect_axi_cu4/M00_ARESETN] [get_bd_pins interconnect_axi_cu4/S00_ARESETN] [get_bd_pins interconnect_axi_cu5/ARESETN] [get_bd_pins interconnect_axi_cu5/M00_ARESETN] [get_bd_pins interconnect_axi_cu5/S00_ARESETN] [get_bd_pins interconnect_axi_cu6/ARESETN] [get_bd_pins interconnect_axi_cu6/M00_ARESETN] [get_bd_pins interconnect_axi_cu6/S00_ARESETN] [get_bd_pins interconnect_axi_cu7/ARESETN] [get_bd_pins interconnect_axi_cu7/M00_ARESETN] [get_bd_pins interconnect_axi_cu7/S00_ARESETN] [get_bd_pins interconnect_axi_cu8/ARESETN] [get_bd_pins interconnect_axi_cu8/M00_ARESETN] [get_bd_pins interconnect_axi_cu8/S00_ARESETN] [get_bd_pins interconnect_axi_cu9/ARESETN] [get_bd_pins interconnect_axi_cu9/M00_ARESETN] [get_bd_pins interconnect_axi_cu9/S00_ARESETN] [get_bd_pins proc_sys_reset_450m/interconnect_aresetn]
  connect_bd_net -net sys_rstn_1 [get_bd_ports sys_rstn] [get_bd_pins xdma/sys_rst_n]
  connect_bd_net -net xdma_axi_aclk [get_bd_ports xdma_aclk] [get_bd_pins axi_gpio_pme/s_axi_aclk] [get_bd_pins bram_ctrl_axil/s_axi_aclk] [get_bd_pins clk_wiz/clk_in1] [get_bd_pins hbm_inst/AXI_16_ACLK] [get_bd_pins interconnect_axi_xdma/ACLK] [get_bd_pins interconnect_axi_xdma/M00_ACLK] [get_bd_pins interconnect_axi_xdma/S00_ACLK] [get_bd_pins interconnect_axil/ACLK] [get_bd_pins interconnect_axil/M00_ACLK] [get_bd_pins interconnect_axil/M01_ACLK] [get_bd_pins interconnect_axil/S00_ACLK] [get_bd_pins xdma/axi_aclk]
  connect_bd_net -net xdma_axi_aresetn [get_bd_ports xdma_rstn] [get_bd_pins axi_gpio_pme/s_axi_aresetn] [get_bd_pins bram_ctrl_axil/s_axi_aresetn] [get_bd_pins clk_wiz/resetn] [get_bd_pins hbm_inst/AXI_16_ARESET_N] [get_bd_pins interconnect_axi_xdma/ARESETN] [get_bd_pins interconnect_axi_xdma/M00_ARESETN] [get_bd_pins interconnect_axi_xdma/S00_ARESETN] [get_bd_pins interconnect_axil/ARESETN] [get_bd_pins interconnect_axil/M00_ARESETN] [get_bd_pins interconnect_axil/M01_ARESETN] [get_bd_pins interconnect_axil/S00_ARESETN] [get_bd_pins proc_sys_reset_100m/ext_reset_in] [get_bd_pins proc_sys_reset_450m/ext_reset_in] [get_bd_pins xdma/axi_aresetn]
  connect_bd_net -net xdma_msi_enable [get_bd_ports msi_enable] [get_bd_pins xdma/msi_enable]
  connect_bd_net -net xlconcat_dout [get_bd_ports irq_req] [get_bd_pins xdma/usr_irq_req]

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs axi_gpio_pme/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs bram_ctrl_axil/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM00] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM01] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM02] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM03] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM04] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM05] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM06] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM07] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM08] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM09] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM10] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM11] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM12] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM13] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM14] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM15] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM16] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM17] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM18] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM19] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM20] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM21] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM22] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM23] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM24] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM25] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM26] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM27] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM28] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM29] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM30] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs hbm_inst/SAXI_16/HBM_MEM31] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM00] -force
  assign_bd_address -offset 0x00000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM00] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM01] -force
  assign_bd_address -offset 0x10000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM01] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM02] -force
  assign_bd_address -offset 0x20000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM02] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM03] -force
  assign_bd_address -offset 0x30000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM03] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM04] -force
  assign_bd_address -offset 0x40000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM04] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM05] -force
  assign_bd_address -offset 0x50000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM05] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM06] -force
  assign_bd_address -offset 0x60000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM06] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM07] -force
  assign_bd_address -offset 0x70000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM07] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM08] -force
  assign_bd_address -offset 0x80000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM08] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM09] -force
  assign_bd_address -offset 0x90000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM09] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM10] -force
  assign_bd_address -offset 0xA0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM10] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM11] -force
  assign_bd_address -offset 0xB0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM11] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM12] -force
  assign_bd_address -offset 0xC0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM12] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM13] -force
  assign_bd_address -offset 0xD0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM13] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM14] -force
  assign_bd_address -offset 0xE0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM14] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM15] -force
  assign_bd_address -offset 0xF0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM15] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM16] -force
  assign_bd_address -offset 0x000100000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM16] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM17] -force
  assign_bd_address -offset 0x000110000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM17] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM18] -force
  assign_bd_address -offset 0x000120000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM18] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM19] -force
  assign_bd_address -offset 0x000130000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM19] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM20] -force
  assign_bd_address -offset 0x000140000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM20] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM21] -force
  assign_bd_address -offset 0x000150000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM21] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM22] -force
  assign_bd_address -offset 0x000160000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM22] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM23] -force
  assign_bd_address -offset 0x000170000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM23] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM24] -force
  assign_bd_address -offset 0x000180000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM24] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM25] -force
  assign_bd_address -offset 0x000190000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM25] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM26] -force
  assign_bd_address -offset 0x0001A0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM26] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM27] -force
  assign_bd_address -offset 0x0001B0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM27] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM28] -force
  assign_bd_address -offset 0x0001C0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM28] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM29] -force
  assign_bd_address -offset 0x0001D0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM29] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM30] -force
  assign_bd_address -offset 0x0001E0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM30] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi15] [get_bd_addr_segs hbm_inst/SAXI_15/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi9] [get_bd_addr_segs hbm_inst/SAXI_09/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi0] [get_bd_addr_segs hbm_inst/SAXI_00/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi14] [get_bd_addr_segs hbm_inst/SAXI_14/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi1] [get_bd_addr_segs hbm_inst/SAXI_01/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi13] [get_bd_addr_segs hbm_inst/SAXI_13/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi2] [get_bd_addr_segs hbm_inst/SAXI_02/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi3] [get_bd_addr_segs hbm_inst/SAXI_03/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi12] [get_bd_addr_segs hbm_inst/SAXI_12/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi4] [get_bd_addr_segs hbm_inst/SAXI_04/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi5] [get_bd_addr_segs hbm_inst/SAXI_05/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi11] [get_bd_addr_segs hbm_inst/SAXI_11/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi6] [get_bd_addr_segs hbm_inst/SAXI_06/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi7] [get_bd_addr_segs hbm_inst/SAXI_07/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi10] [get_bd_addr_segs hbm_inst/SAXI_10/HBM_MEM31] -force
  assign_bd_address -offset 0x0001F0000000 -range 0x10000000 -target_address_space [get_bd_addr_spaces cu_axi8] [get_bd_addr_segs hbm_inst/SAXI_08/HBM_MEM31] -force


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


