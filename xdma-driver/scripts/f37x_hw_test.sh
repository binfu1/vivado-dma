scripts_path=$(cd $(dirname $0);pwd)
xdma_path=$scripts_path/..
driver_path=$xdma_path/xdma
tools_path=$xdma_path/tools
tests_path=$xdma_path/tests

# Test three DDRs
echo "########################################"
echo "Info: Test three DDRs"
$tools_path/dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile0_4K.bin -s 4096 -a 0x0 > f37x_hw_test.log
$tools_path/dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile0_4K.bin -s 4096 -a 0x0 > f37x_hw_test.log
cmp $tests_path/data/output_datafile0_4K.bin $tests_path/data/datafile0_4K.bin -n 4096
returnVal=$?
if [ ! $returnVal == 0 ]; then
	echo "Error: The test of DDR0 is failed."
else
	echo "Info: The test of DDR0 is succeeded."
fi

$tools_path/dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile0_4K.bin -s 4096 -a 0x200000000 > f37x_hw_test.log
$tools_path/dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile0_4K.bin -s 4096 -a 0x200000000 > f37x_hw_test.log
cmp $tests_path/data/output_datafile0_4K.bin $tests_path/data/datafile0_4K.bin -n 4096
returnVal=$?
if [ ! $returnVal == 0 ]; then
	echo "Error: The test of DDR1 is failed."
else
	echo "Info: The test of DDR1 is succeeded."
fi

$tools_path/dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile0_4K.bin -s 4096 -a 0x400000000 > f37x_hw_test.log
$tools_path/dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile0_4K.bin -s 4096 -a 0x400000000 > f37x_hw_test.log
cmp $tests_path/data/output_datafile0_4K.bin $tests_path/data/datafile0_4K.bin -n 4096
returnVal=$?
if [ ! $returnVal == 0 ]; then
	echo "Error: The test of DDR2 is failed."
else
	echo "Info: The test of DDR2 is succeeded."
fi

# Test two QSFPs
echo "########################################"
echo "Info: Test two QSFPs."
echo "Info: MAC loopback test."
$tools_path/reg_rw /dev/xdma0_user 0x0 w 0x00050005 > f37x_hw_test.log
sleep 1
$tools_path/reg_rw /dev/xdma0_user 0x0 w 0x00010001 > f37x_hw_test.log
sleep 1 #等待复位完成再读状态，否则读出的状态不对
# 将读取结果写入f37x_hw_test.log文件
$tools_path/reg_rw /dev/xdma0_user 0x8 w > f37x_hw_test.log
# 读取文件f37x_hw_test.log第五行第八列的内容
results=$(sed -n '5p' f37x_hw_test.log | awk '{print $8}')
#echo $results
# 从results的第6个字符开始截取4个字符
result0=${results:6:4}
#echo $result0
if [ $result0 == '000f' ]; then
  echo "Info: The test of QSFP0 is succeeded."
else
  echo "Error: The test of QSFP0 is failed."
fi
result1=${results:2:4}
#echo $result1
if [ $result1 == '000f' ]; then
  echo "Info: The test of QSFP1 is succeeded."
else
  echo "Error: The test of QSFP1 is failed."
fi

echo "Info: QSFP loopback test."
$tools_path/reg_rw /dev/xdma0_user 0x0 w 0x00040004 > f37x_hw_test.log
sleep 1
$tools_path/reg_rw /dev/xdma0_user 0x0 w 0x00000000 > f37x_hw_test.log
sleep 1 #等待复位完成再读状态，否则读出的状态不对
# 将读取结果写入f37x_hw_test.log文件
$tools_path/reg_rw /dev/xdma0_user 0x8 w > f37x_hw_test.log
# 读取文件f37x_hw_test.log第五行第八列的内容
results=$(sed -n '5p' f37x_hw_test.log | awk '{print $8}')
#echo $results
# 从results的第6个字符开始截取4个字符
result0=${results:6:4}
#echo $result0
if [ $result0 == '000f' ]; then
  echo "Info: The test of QSFP0 is succeeded."
else
  echo "Error: The test of QSFP0 is failed."
fi
result1=${results:2:4}
#echo $result1
if [ $result1 == '000f' ]; then
  echo "Info: The test of QSFP1 is succeeded."
else
  echo "Error: The test of QSFP1 is failed."
fi
echo "########################################"