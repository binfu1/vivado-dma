#../reg_rw /dev/xdma0_user 0x0 w 0x0
../dma_to_device -d /dev/xdma0_h2c_0 -f init0.bin -s 4194304 -a 0x00000000
../dma_to_device -d /dev/xdma0_h2c_0 -f init1.bin -s 4194304 -a 0x10000000
../dma_to_device -d /dev/xdma0_h2c_0 -f init2.bin -s 4194304 -a 0x20000000
../dma_to_device -d /dev/xdma0_h2c_0 -f init3.bin -s 4194304 -a 0x30000000
../reg_rw /dev/xdma0_user 0x0 w 0x1
../reg_rw /dev/xdma0_user 0x0 w 0x3
../dma_from_device -d /dev/xdma0_c2h_0 -f result0.bin -s 4194304 -a 0x00000000
../dma_from_device -d /dev/xdma0_c2h_0 -f result1.bin -s 4194304 -a 0x10000000
../dma_from_device -d /dev/xdma0_c2h_0 -f result2.bin -s 4194304 -a 0x20000000
../dma_from_device -d /dev/xdma0_c2h_0 -f result3.bin -s 4194304 -a 0x30000000
hexdump result0.bin -v > result0
hexdump result1.bin -v > result1
hexdump result2.bin -v > result2
hexdump result3.bin -v > result3
