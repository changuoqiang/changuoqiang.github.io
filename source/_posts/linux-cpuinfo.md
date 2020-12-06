---
title: 'linux查看cpu型号,物理cpu个数,逻辑cpu个数,cpu核心数'
tags:
  - Debian
id: '5973'
categories:
  - - GNU/Linux
date: 2014-10-23 12:36:45
---


<!-- more -->
无需第三方工具,proc文件系统里面的/proc/cpuinfo提供了丰富的cpu信息。
其输出类似如下:
```js
processor : 0
vendor_id : AuthenticAMD
cpu family : 16
model : 4
model name : Quad-Core AMD Opteron(tm) Processor 8382
stepping : 2
microcode : 0x1000086
cpu MHz : 2611.977
cache size : 512 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 4
apicid : 4
initial apicid : 0
fpu : yes
fpu_exception : yes
cpuid level : 5
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc extd_apicid pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt hw_pstate npt lbrv svm_lock nrip_save
bogomips : 5223.95
TLB size : 1024 4K pages
clflush size : 64
cache_alignment : 64
address sizes : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate
```

**型号和逻辑CPU个数**
```js
$ cat /proc/cpuinfo grep 'model name' cut -f2 -d: uniq -c
32 Quad-Core AMD Opteron(tm) Processor 8382
```
可以看到有32个逻辑CPU，后面是型号

**物理CPU个数**
```js
$ cat /proc/cpuinfo grep 'physical id' uniq -d
physical id : 0
physical id : 1
physical id : 2
physical id : 3
physical id : 4
physical id : 5
physical id : 6
physical id : 7
```
或者
```js
$ cat /proc/cpuinfo grep 'physical id' uniq -d cut -f1 -d: uniq -c
8 physical id
```
可以看到有8颗物理CPU

**每颗CPU核心数**
```js
$ cat /proc/cpuinfo grep 'cpu cores' uniq
cpu cores : 4
```
或者
```js
$ cat /proc/cpuinfo grep 'core id' sort uniq
core id : 0
core id : 1
core id : 2
core id : 3
```
8*4刚好是32颗逻辑CPU,如果有超线程技术则不是简单的相乘就可以，还要乘以每个核心的线程数。

还有一个命令lscpu,可以总览系统cpu概况：
```js
$ lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Byte Order: Little Endian
CPU(s): 32
On-line CPU(s) list: 0-31
Thread(s) per core: 1
Core(s) per socket: 4
Socket(s): 8
NUMA node(s): 4
Vendor ID: AuthenticAMD
CPU family: 16
Model: 4
Stepping: 2
CPU MHz: 2611.977
BogoMIPS: 5224.55
Virtualization: AMD-V
L1d cache: 64K
L1i cache: 64K
L2 cache: 512K
L3 cache: 6144K
NUMA node0 CPU(s): 0-3
NUMA node1 CPU(s): 4-7
NUMA node2 CPU(s): 8-11
NUMA node3 CPU(s): 12-31
```
**\===
\[erq\]**