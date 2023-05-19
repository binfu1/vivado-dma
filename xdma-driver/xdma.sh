# set parameter
xdma_path=$(cd $(dirname $0);pwd)
driver_path=$xdma_path/xdma
tools_path=$xdma_path/tools
tests_path=$xdma_path/tests

case $1 in
  install)
    cd $driver_path
    make install
  ;;
  load)
    cd $tests_path
    ./load_driver.sh
  ;;
  test)
    cd $tests_path
    ./run_test.sh
  ;;
  bypass_write)
    cd $tools_path
    ./reg_rw /dev/xdma0_bypass 0x4 w 0x11223344
  ;;
  bypass_read)
    cd $tools_path
    ./reg_rw /dev/xdma0_bypass 0x4 w
  ;;
  axi_write)
    cd $tools_path
    ./dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile0_4K.bin -s 4 -a 0x4 -c 1
  ;;
  axi_read)
    cd $tools_path
    ./dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile0_4K.bin -s 4 -a 0x4 -c 1
  ;;
  axi_rw)
    cd $tools_path
    ./dma_from_device -d /dev/xdma0_c2h_0 -f $tests_path/data/output_datafile0_4K.bin -s 1024 -c 1 &
    ./dma_to_device -d /dev/xdma0_h2c_0 -f $tests_path/data/datafile0_4K.bin -s 1024 -c 1 &
  ;;
  axil_write)
    cd $tools_path
    ./reg_rw /dev/xdma0_user 0x4 w 0x11223344
  ;;
  axil_read)
    cd $tools_path
    ./reg_rw /dev/xdma0_user 0x4 w
  ;;
  *)
    echo "Error: no parameter matched"
  ;;
esac