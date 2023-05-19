####################################################################################
# 1.create project and add files
####################################################################################
set launchDir [file dirname [file normalize [info script]]]
set srcDir ${launchDir}/src
set xdcDir ${launchDir}/xdc
set projName "proj"
set projDir ${launchDir}/${projName}
set projPart "xcvu37p-fsvh2892-2L-e"
create_project ${projName} ${projDir} -part ${projPart}

####################################################################################
# 2.create block design
####################################################################################
# rtl
add_files -norecurse ${srcDir}/rtl/qdma_stm_h2c_stub.sv
add_files -norecurse ${srcDir}/rtl/qdma_qsts.sv
add_files -norecurse ${srcDir}/rtl/dsc_byp_c2h.sv
add_files -norecurse ${srcDir}/rtl/qdma_fifo_lut.sv
add_files -norecurse ${srcDir}/rtl/dsc_byp_h2c.sv
add_files -norecurse ${srcDir}/rtl/st_h2c.sv
add_files -norecurse ${srcDir}/rtl/user_control.sv
add_files -norecurse ${srcDir}/rtl/xilinx_qdma_pcie_ep.sv
add_files -norecurse ${srcDir}/rtl/st_c2h.sv
add_files -norecurse ${srcDir}/rtl/qdma_ecc_enc.sv
add_files -norecurse ${srcDir}/rtl/axi_st_module.sv
add_files -norecurse ${srcDir}/rtl/qdma_lpbk.sv
add_files -norecurse ${srcDir}/rtl/qdma_stm_lpbk.sv
add_files -norecurse ${srcDir}/rtl/qdma_app.sv
add_files -norecurse ${srcDir}/rtl/qdma_stm_c2h_stub.sv
add_files -norecurse ${srcDir}/rtl/qdma_stm_defines.svh
# ip
import_files -norecurse ${srcDir}/ip/ila_axi.xci
import_files -norecurse ${srcDir}/ip/ila_axil.xci
import_files -norecurse ${srcDir}/ip/ila_axis.xci
import_files -norecurse ${srcDir}/ip/blk_mem_gen_0.xci
import_files -norecurse ${srcDir}/ip/axi_bram_ctrl_1.xci
import_files -norecurse ${srcDir}/ip/qdma_0.xci
# xdc
add_files -fileset constrs_1 -norecurse ${xdcDir}/qdma.xdc

####################################################################################
# 3.synth, impl and generate bitstream
####################################################################################
launch_runs synth_1 -jobs 20
wait_on_run synth_1
launch_runs impl_1 -jobs 20
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 20