---
title: ECC 内存故障
tags:
  - Debian
id: '8292'
categories:
  - - GNU/Linux
date: 2019-06-01 16:18:08
---


<!-- more -->
一台很老旧的服务器terminal不断吐出一些错误提示：
```js
\[ 1250.944486\] mce: \[Hardware Error\]: Machine check events logged
\[ 1250.944493\] \[Hardware Error\]: Corrected error, no action required.
\[ 1250.948666\] \[Hardware Error\]: CPU:24 (10:9:1) MC4_STATUS\[OverCEMiscV-AddrVCECC\]: 0xdc0a400079080a13
\[ 1250.952631\] \[Hardware Error\]: Error Addr: 0x00000004abffce80
\[ 1250.952633\] \[Hardware Error\]: MC4 Error (node 6): DRAM ECC error detected on the NB.
\[ 1250.952654\] EDAC MC6: 1 CE on mc#6csrow#3channel#0 (csrow:3 channel:0 page:0x4abffc offset:0xe80 grain:0 syndrome:0x7914)
\[ 1250.952656\] \[Hardware Error\]: cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: RES (no timeout)
```

可以看到是内存出现了错误，不过错误被纠正了，但内存显然是出现故障了。

先看看系统cpu节点信息
```js
$ lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Byte Order: Little Endian
Address sizes: 48 bits physical, 48 bits virtual
CPU(s): 32
On-line CPU(s) list: 0-31
Thread(s) per core: 1
Core(s) per socket: 8
Socket(s): 4
NUMA node(s): 8
Vendor ID: AuthenticAMD
CPU family: 16
Model: 9
Model name: AMD Opteron(tm) Processor 6128
Stepping: 1
CPU MHz: 800.000
CPU max MHz: 2000.0000
CPU min MHz: 800.0000
BogoMIPS: 4000.04
Virtualization: AMD-V
L1d cache: 64K
L1i cache: 64K
L2 cache: 512K
L3 cache: 5118K
NUMA node0 CPU(s): 0-3
NUMA node1 CPU(s): 4-7
NUMA node2 CPU(s): 8-11
NUMA node3 CPU(s): 12-15
NUMA node4 CPU(s): 16-19
NUMA node5 CPU(s): 20-23
NUMA node6 CPU(s): 24-27
NUMA node7 CPU(s): 28-31
Flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm 3dnowext 3dnow constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid amd_dcm pni monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt nodeid_msr hw_pstate vmmcall npt lbrv svm_lock nrip_save pausefilter
```

共有四个socket，四颗cpu，每颗CPU有八个核心，总共是32核心，对于NUMA结构的机器，一般来讲每颗CPU应该至少有一个本地的内存控制器

安装edac-util，查看内存控制器信息
```js
$ sudo apt install edac-utils
$ edac-util -vs
edac-util: EDAC drivers are loaded. 4 MCs detected:
 mc0:F10h
 mc2:F10h
 mc4:F10h
 mc6:F10h
```
可以看到有四个内存控制器，再查看每个内存控制器可能存在的错误
```js

$ edac-util -v
mc0: 0 Uncorrected Errors with no DIMM info
mc0: 0 Corrected Errors with no DIMM info
mc0: csrow2: 0 Uncorrected Errors
mc0: csrow2: mc#0csrow#2channel#0: 0 Corrected Errors
mc0: csrow3: 0 Uncorrected Errors
mc0: csrow3: mc#0csrow#3channel#0: 0 Corrected Errors
mc2: 0 Uncorrected Errors with no DIMM info
mc2: 0 Corrected Errors with no DIMM info
mc2: csrow2: 0 Uncorrected Errors
mc2: csrow2: mc#2csrow#2channel#0: 0 Corrected Errors
mc2: csrow3: 0 Uncorrected Errors
mc2: csrow3: mc#2csrow#3channel#0: 0 Corrected Errors
mc4: 0 Uncorrected Errors with no DIMM info
mc4: 0 Corrected Errors with no DIMM info
mc4: csrow2: 0 Uncorrected Errors
mc4: csrow2: mc#4csrow#2channel#0: 0 Corrected Errors
mc4: csrow3: 0 Uncorrected Errors
mc4: csrow3: mc#4csrow#3channel#0: 0 Corrected Errors
mc6: 0 Uncorrected Errors with no DIMM info
mc6: 0 Corrected Errors with no DIMM info
mc6: csrow2: 0 Uncorrected Errors
mc6: csrow2: mc#6csrow#2channel#0: 2 Corrected Errors
mc6: csrow3: 0 Uncorrected Errors
mc6: csrow3: mc#6csrow#3channel#0: 4 Corrected Errors
```

或者这样查看:
```js
$ grep \[0-9\] /sys/devices/system/edac/mc/mc*/csrow*/*ce_count
/sys/devices/system/edac/mc/mc0/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc0/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc2/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc2/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc2/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc2/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc4/csrow2/ce_count:0
/sys/devices/system/edac/mc/mc4/csrow2/ch0_ce_count:0
/sys/devices/system/edac/mc/mc4/csrow3/ce_count:0
/sys/devices/system/edac/mc/mc4/csrow3/ch0_ce_count:0
/sys/devices/system/edac/mc/mc6/csrow2/ce_count:3
/sys/devices/system/edac/mc/mc6/csrow2/ch0_ce_count:3
/sys/devices/system/edac/mc/mc6/csrow3/ce_count:6
/sys/devices/system/edac/mc/mc6/csrow3/ch0_ce_count:6
```

可以看到出现错误的内存位于MC6,csrow2和csrow3，也就是问题出现在第四个(CPU的)内存控制器的0通道DIMM0内存这里。

References:
\[1\][How to identify defective DIMM from EDAC error on Linux](http://fibrevillage.com/sysadmin/240-how-to-identify-defective-dimm-from-edac-error-on-linux-2)
\[2\][内存条物理结构分析](http://lzz5235.github.io/2015/04/21/memory.html)