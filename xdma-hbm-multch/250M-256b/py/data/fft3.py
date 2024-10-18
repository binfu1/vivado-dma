#! /usr/bin/python3
# -*- encoding:utf-8 -*-

import matplotlib.pyplot as plt
from matplotlib.pylab import mpl
import numpy as np
import os
import ctypes
import struct

########################################
def h2f(s):
  cp = ctypes.pointer(ctypes.c_long(s))
  fp = ctypes.cast(cp, ctypes.POINTER(ctypes.c_float))
  return fp.contents.value
def f2h(s):
  fp = ctypes.pointer(ctypes.c_float(s))
  cp = ctypes.cast(fp, ctypes.POINTER(ctypes.c_long))
  return hex(cp.contents.value)

N = 128  #采样点数
area = int(N/4) #每个平面分区存储的数量
bram = 16 #bram数量
data_width = 32 #静电势能实部、虚部、系数位宽
hbm_width = 256 #全局HBM或BRAM位宽
bram_width = 64 #本地静电势能矩阵BRAM位宽为512，系数矩阵为256

######################### 计算内存 #########################
#全局内存的深度
depth_global = N**(3)*data_width*2/hbm_width
print('位宽为%dbit的全局内存深度为%d' %(hbm_width,depth_global))
depth_global_byte = N**(3)*data_width*2/(8*1024)
print('全局内存的存储容量为%dK' %(depth_global_byte))
depth_bram = depth_global/bram
print('仿真时每个内存深度为%d' %(depth_bram))
#本地内存的深度
depth_local_fft = N**(2)*data_width*2/bram_width
print('位宽为%dbit的FFT本地内存深度为%d' %(bram_width,depth_local_fft))
#地址范围
addr_global = N**(3)*data_width*2/8
print('总的地址空间大小为%s(%d)' %(hex(int(addr_global)), addr_global))
addr_core = N*4*data_width*2/8
print('每个区域的地址空间大小为%s(%d)' %(hex(int(addr_core)), addr_core))
addr_bram = N**(3)*data_width*2/8/bram
print('每个BRAM的地址空间大小为%s(%d)' %(hex(int(addr_bram)), addr_bram))

######################### 原始信号 #########################
filename = 'f3'
f3_real = np.zeros((128,128,128),float)
with open(filename, 'r') as file:
  lines = file.readlines()
  i = j = cnt = 0
  for line in lines:
    j = int(cnt / 128)
    if cnt >= 128**2:
      i = i + 1
      cnt = 0
    else:
      cnt = cnt + 128
    if line == '\n':
      continue
    value = line.split()
    for k in range(128):
      f3_real[i,j,k] = float(value[k])
file.close

f3 = np.zeros((N,N,N),complex)
for i in range(N):
  for j in range(N):
    for k in range(N):
        f3[i,j,k] = complex(f3_real[i,j,k],0)

fhex = np.zeros((N,N,N),object)
filename = 'f3hex'
os.remove(filename)
with open(filename, 'w') as file:
  for i in range(N):
    for j in range(N):
      for k in range(N):
        fhex_real = f2h(f3[i,j,k].real)
        fhex_real_len = len(fhex_real)
        fhex_real = fhex_real[2:fhex_real_len]
        for m in range(int(data_width/4+2-fhex_real_len)):
          fhex_real = '0'+fhex_real
        #print(fhex_real)
        fhex_imag = f2h(f3[i,j,k].imag)
        fhex_imag_len = len(fhex_imag)
        fhex_imag = fhex_imag[2:fhex_imag_len]
        for m in range(int(data_width/4+2-fhex_imag_len)):
          fhex_imag = '0'+fhex_imag

        fhex[i,j,k] = fhex_imag+fhex_real
        if k == N-1 and j == N-1:
          file.write(fhex[i,j,k]+'\n\n')
        elif k == N-1:
          file.write(fhex[i,j,k]+'\n')
        else:
          file.write(fhex[i,j,k]+' ')
file.close

# 写入数据，8个通道的32bit数组成一个256bit的数
# 写到全局内存中
pattern = np.zeros((area,int(N/area)),int)
pattern[0] = [3,2,1,0]
for i in range(1,area):
  pattern[i] = pattern[i-1] + 4
for c in range(bram):
  filename = 'init'+str(c)+'.coe'
  os.remove(filename)
  with open(filename, 'w') as file:
    file.write('memory_initialization_radix=16;\n')
    file.write('memory_initialization_vector=')
    cnt = 0
    for i in range(N):
      for m in range(int(area/bram*c),int(area/bram*(c+1))):
        for k in range(N):
          for j in pattern[m]:
            cnt = cnt + 1
            if (cnt==hbm_width/data_width/2):
              file.write(fhex[i,j,k]+' ')
              cnt = 0
            else:
              file.write(fhex[i,j,k])
  file.close

pattern[0] = [0,1,2,3]
for i in range(1,area):
  pattern[i] = pattern[i-1] + 4
for c in range(bram):
  filename = 'init'+str(c)+'.bin'
  os.remove(filename)
  with open(filename, 'wb') as file:
    for i in range(N):
      for m in range(int(area/bram*c),int(area/bram*(c+1))):
        for k in range(N):
          for j in pattern[m]:
            data = f3[i,j,k].real
            data1 = struct.pack('f',data) #按32位浮点转换
            file.write(data1)
            data1 = struct.pack('f',0) #按32位浮点转换
            file.write(data1)
  file.close