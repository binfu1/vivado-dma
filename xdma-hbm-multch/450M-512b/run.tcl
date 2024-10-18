####################################################################################
# 1.create project and add files
####################################################################################
set launchDir [file dirname [file normalize [info script]]]
set srcDir ${launchDir}/src
set xdcDir ${launchDir}/xdc
set projName "proj"
set projDir "./${projName}"
set projPart "xcvu37p-fsvh2892-2L-e"
create_project ${projName} ${projDir} -part ${projPart}

####################################################################################
# 2.create design
####################################################################################
# create block design
source ${srcDir}/tcl/ila.tcl
source ${srcDir}/tcl/ram.tcl
source ${srcDir}/tcl/itct.tcl
source ${srcDir}/tcl/xdma.tcl
set bdName xdma
regenerate_bd_layout
validate_bd_design
save_bd_design
make_wrapper -files [get_files ${projDir}/${projName}.srcs/sources_1/bd/${bdName}/${bdName}.bd] -top
add_files -norecurse ${projDir}/${projName}.gen/sources_1/bd/${bdName}/hdl/${bdName}_wrapper.v
# add verilog file
add_files -norecurse ${srcDir}/hdl/top.v
add_files -norecurse ${srcDir}/hdl/mem.v
add_files -norecurse ${srcDir}/hdl/load.v
add_files -norecurse ${srcDir}/hdl/inte.v
# add constrain file
add_files -fileset constrs_1 -norecurse ${xdcDir}/xdma.xdc
# add simulation file
add_files -fileset sim_1 -norecurse ${srcDir}/sim/top_tb.v
set_property top top_tb [get_filesets sim_1]

####################################################################################
# 3.synth, impl and generate bitstream
####################################################################################
set_property strategy Performance_Explore [get_runs impl_1]
