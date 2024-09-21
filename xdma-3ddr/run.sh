source /opt/Xilinx/Vitis/2020.2/settings64.sh
rm -rf proj .Xil
rm -f *.jou *.log
vivado 
#vivado -mode tcl -source ./run.tcl
#gen mcs
#write_cfgmem  -format mcs -size 128 -interface SPIx4 -loadbit {up 0x00000000 "./bit/xdma_wrapper.bit" } -file "./bit/f37x.mcs" -force
