# set directory
set launchDir [file dirname [file normalize [info script]]]
set srcDir ${launchDir}/src
set xdcDir ${launchDir}/xdc
set projName "proj"
set projDir "./$projName"
set projPart "xcvu37p-fsvh2892-2L-e"

# create project
create_project $projName $projDir -part $projPart

# add source files
add_files -norecurse ${srcDir}/hdl/top.v
add_files -norecurse ${srcDir}/hdl/cmac0.v
add_files -norecurse ${srcDir}/hdl/cmac1.v
add_files -norecurse ${srcDir}/hdl/cmac_usplus_0_exdes.v
add_files -norecurse ${srcDir}/hdl/cmac_usplus_1_exdes.v
add_files -norecurse ${srcDir}/hdl/cmac_usplus_pkt_gen_mon.v
add_files -norecurse ${srcDir}/hdl/cmac_usplus_axis_pkt_gen.v
add_files -norecurse ${srcDir}/hdl/cmac_usplus_axis_pkt_mon.v
add_files -norecurse ${srcDir}/hdl/frequency_counter.v

# create block design
set bdName xdma
source ${srcDir}/tcl/xdma.tcl
source ${srcDir}/tcl/cmac.tcl
source ${srcDir}/tcl/ila.tcl
make_wrapper -files [get_files ${projDir}/${projName}.srcs/sources_1/bd/${bdName}/${bdName}.bd] -top
add_files -norecurse ${projDir}/${projName}.gen/sources_1/bd/${bdName}/hdl/${bdName}_wrapper.v

# add constrains
add_files -fileset constrs_1 -norecurse ${xdcDir}/cmac0.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/cmac1.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/ddr0.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/ddr1.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/ddr2.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/xdma.xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/flash.xdc
update_compile_order -fileset sources_1
set_property top top [current_fileset]

## synth
#launch_runs synth_1 -jobs 20
#wait_on_run synth_1
## impl
#launch_runs impl_1 -jobs 20
#wait_on_run impl_1
## generate bitstream
#launch_runs impl_1 -to_step write_bitstream -jobs 20