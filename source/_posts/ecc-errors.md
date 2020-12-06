---
title: ECC错误提示
tags:
  - Debian
id: '2844'
categories:
  - - GNU/Linux
date: 2013-01-30 14:10:12
---

一台服务器出现内存故障提示
<!-- more -->
Message from syslogd@patchsvr at Jan 30 10:24:02 ...
 kernel:\[171000.744035\] \[Hardware Error\]: CPU:6 MC4_STATUS\[OverCEMiscV-AddrVCECC\]: 0xdc04400032080a13

Message from syslogd@patchsvr at Jan 30 10:24:02 ...
 kernel:\[171000.744097\] \[Hardware Error\]: MC4_ADDR: 0x00000001f3f37860

Message from syslogd@patchsvr at Jan 30 10:24:02 ...
 kernel:\[171000.744128\] \[Hardware Error\]: Northbridge Error (node 3): DRAM ECC error detected on the NB.

Message from syslogd@patchsvr at Jan 30 10:24:02 ...
 kernel:\[171000.744224\] \[Hardware Error\]: cache level: L3/GEN, mem/io: MEM, mem-tx: RD, part-proc: RES (no timeout)

MC4_STATUS为MSR(Model Specific Registers)模型相关寄存器之一,主要用于记录cpu L3 cache和前端总线FSB(Front Side Bus)错误,MC为Machine Check之意，还有其他的MCx_STATUS寄存器

MC4_ADDR与MC4_STATUS对应，用来记录引起MC4_STATUS所记载错误的线性地址或物理地址。

此处有提示北桥错误，检查到DRAM ECC校验错误，看来ECC内存出问题了。
服务器有4颗双核Opteron 8218 HE处理器，CPU 6报错误，是第三颗CPU的本地内存出故障了吗？？
系统仍然正常运行，抽时间memtest下，老服务器了。
不知道多CPU硬件环境下，去掉某个CPU的本地内存系统能不能启动呢？

**P.S.**用memtest86+检测了一下内存，内存竟然没有问题！难道是北桥出问题了？？？