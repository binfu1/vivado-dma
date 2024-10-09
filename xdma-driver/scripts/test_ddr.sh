scripts_path=$(cd $(dirname $0);pwd)
xdma_path=$scripts_path/..
driver_path=$xdma_path/xdma
tools_path=$xdma_path/tools
tests_path=$xdma_path/tests
transferSz=32768 #每次测试传输的字节数，32MB，0x8000
transferLp=2 #传输的次数
#addrStart=0
addrStart=8589934592 #每次传输的起始地址，8G，0x200000000
addrStart=17179869184 #每次传输的起始地址，16G，0x400000000
addrStart=8589901824 #0x1FFFF8000

cnt_succeed=0 #读写成功次数
for ((i=0; i<$transferLp; i++)); do
	addrOffset=$(($transferSz * $i + $addrStart))
	$tools_path/dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile_32M.bin -s $transferSz -a $addrOffset > f37x_hw_test.log
	$tools_path/dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile_32M.bin -s $transferSz -a $addrOffset > f37x_hw_test.log
	cmp $tests_path/data/output_datafile_32M.bin $tests_path/data/datafile_32M.bin -n $transferSz
	returnVal=$?
	if [ $returnVal == 0 ]; then
		((cnt_succeed=cnt_succeed+1))
	fi
done
if [ $cnt_succeed == $transferLp ]; then
  echo "Info: The test is succeeded."
else
  echo "Error: The test is failed."
fi