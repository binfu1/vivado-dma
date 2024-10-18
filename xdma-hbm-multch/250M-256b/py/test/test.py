from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import numpy as np
import os
import ctypes

########################################
def h2f(s):
  cp = ctypes.pointer(ctypes.c_long(s))
  fp = ctypes.cast(cp, ctypes.POINTER(ctypes.c_float))
  return fp.contents.value
def f2h(s):
  fp = ctypes.pointer(ctypes.c_float(s))
  cp = ctypes.cast(fp, ctypes.POINTER(ctypes.c_long))
  return hex(cp.contents.value)

#print(round(h2f(0x406c24c6),5))

######################### 读取结果 #########################
N = 128 #采样点数
area = int(N/4) #每个平面分区存储的数量
bram = 16 #bram数量
flag_stop = '0100000'
f_real = []
f_real1 = np.zeros((N,N,N),float)

for c in range(bram):
  filename = 'result'+str(c)
  with open(filename, 'r') as file:
    lines = file.readlines()
    for line in lines:
      value = line.split()
      if value[0] == flag_stop:
        continue
      f_real.append(int(value[2]+value[1],16))
      f_real.append(int(value[6]+value[5],16))

cnt = 0
pattern = np.zeros((area,int(N/area)),int)
pattern[0] = [0,1,2,3]
for i in range(1,area):
  pattern[i] = pattern[i-1] + 4
for c in range(bram):
  for i in range(N):
    for m in range(int(area/bram*c),int(area/bram*(c+1))):
      for k in range(N):
        for j in pattern[m]:
          f_real1[i,j,k] = round(h2f(f_real[cnt]),8)
          cnt = cnt + 1

filename = 'f3p'
os.remove(filename)
with open(filename, 'w') as file:
  for i in range(N):
    for j in range(N):
      for k in range(N):
        if k == N-1 and j == N-1:
          file.write(str(f_real1[i,j,k])+'\n\n')
        elif k == N-1:
          file.write(str(f_real1[i,j,k])+'\n')
        else:
          file.write(str(f_real1[i,j,k])+' ')

######################### 对比结果 #########################
f_real2 = np.zeros((N,N,N),float)
f_imag2 = np.zeros((N,N,N),float)
filename = 'f3'
with open(filename, 'r') as file:
  lines = file.readlines()
  i = j = cnt = 0
  for line in lines:
    j = int(cnt / N)
    if cnt >= N**2:
      i = i + 1
      cnt = 0
    else:
      cnt = cnt + N
    if line == '\n':
      continue
    value = line.split()
    #print(line)
    for k in range(N):
      #print('i=%d, j=%d, k=%d, cnt=%d' %(i, j, k, cnt))
      f_real2[i,j,k] = value[k]

dif_real_relative = np.zeros((N,N,N))
max_dif_real_relative = 0
for i in range(N):
  for j in range(N):
    for k in range(N):
      dif_real_relative[i,j,k] = dif_real_relative[i,j,k] - 1
      #if (abs(f_real2[i,j,k]) > 10000): #去除数值较小的数
      if (abs(f_real2[i,j,k]) > 0): #去除数值较小的数
        dif_real = abs(f_real2[i,j,k]-f_real1[i,j,k])
        dif_real_relative[i,j,k] = dif_real / abs(f_real2[i,j,k]) 
        if (dif_real_relative[i,j,k] > max_dif_real_relative):
          max_dif_real_relative = dif_real_relative[i,j,k]
          max_val_real1 = f_real1[i,j,k]
          max_val_real2 = f_real2[i,j,k]
          max_real_i = i
          max_real_j = j
          max_real_k = k

print('实部计算误差最大的点: i=%d, j=%d, k=%d' %(max_real_i, max_real_j, max_real_k))
print('最大误差: max_dif_real_relative=%.8f' %(max_dif_real_relative))
print('原始数值: max_val_real1=%.8f, max_val_real2=%.8f' %(max_val_real1, max_val_real2))

relative = np.zeros(10,int)
for i in range(N):
  for j in range(N):
    for k in range(N):
      if   (dif_real_relative[i,j,k] < 0):
        continue #不统计数据较小的相对误差
      elif (dif_real_relative[i,j,k] < 0.0001):
        relative[0] = relative[0] + 1
      elif (dif_real_relative[i,j,k] < 0.0005):
        relative[1] = relative[1] + 1
      elif (dif_real_relative[i,j,k] < 0.001):
        relative[2] = relative[2] + 1
      elif (dif_real_relative[i,j,k] < 0.005):
        relative[3] = relative[3] + 1
      elif (dif_real_relative[i,j,k] < 0.01):
        relative[4] = relative[4] + 1
      elif (dif_real_relative[i,j,k] < 0.05):
        relative[5] = relative[5] + 1
      elif (dif_real_relative[i,j,k] < 0.1):
        relative[6] = relative[6] + 1
      elif (dif_real_relative[i,j,k] < 0.5):
        relative[7] = relative[7] + 1
      elif (dif_real_relative[i,j,k] < 1):
        relative[8] = relative[8] + 1
      elif (dif_real_relative[i,j,k] >= 1):
        relative[9] = relative[9] + 1
print(relative)
sum = 0
for i in range(len(relative)):
  sum = sum + relative[i]
print('sum = %d' %sum)