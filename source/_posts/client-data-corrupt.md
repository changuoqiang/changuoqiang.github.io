---
title: VirtualBox主机(host)I/O负载过重导致客户机数据破坏(corruption)
tags:
  - Virtualbox
id: '620'
categories:
  - - GNU/Linux
date: 2009-11-16 13:03:04
---

先说一下主机和客户机配置
主机：4颗双核AMD 8218HE CPU,16G内存,windows 2003 R2 server x86
客户机：单颗CPU,1500MB内存,debian lenny amd64

最近经常能遇到客户机运行迟缓(lag)，无法正常提供服务的情况，客户机的控制台一般有这样的提示：
end_request: I/O error,dev hda,sector xxxxxxxx(扇区号)
Buffer I/O error on device hda6,logical block xxx(块号)
...
日志文件/var/log/messages中有这样的消息：
Nov 16 10:54:06 debian kernel: \[255938.816139\] hda: dma_timer_expiry: dma status == 0x21
Nov 16 10:54:16 debian kernel: \[255948.816121\] hda: DMA timeout error
Nov 16 10:54:16 debian kernel: \[255948.816174\] hda: dma timeout error: status=0x48 { DriveReady DataRequest }
Nov 16 10:54:16 debian kernel: \[255948.816183\] ide: failed opcode was: unknown
Nov 16 10:54:16 debian kernel: \[255948.816199\] hda: DMA disabled
Nov 16 10:54:16 debian kernel: \[255948.965023\] ide0: reset: master: error (0x00?)
<!-- more -->
最早出现这个问题的时候客户机使用的是SATA硬盘，本来以为是这个接口还不成熟，就又换回了最原始的IDE(PIIX4)，但是问题依旧。隔一段时间客户机仍然会崩溃，而且错误提示基本一样，可以排除是硬盘接口层的问题。
每次出现这种问题基本上都是在主机进行大文件拷贝的时候，host有一个脚本，定期拷贝大约120G的数据,每个文件大约30G。
经过搜索，发现virtualbox官方打开了一个[ticket(#2524)](http://www.virtualbox.org/ticket/2524)就是描述的这个问题，看来这是virtualbox的一个bug无疑了。
这个bug在最新的virtualbox 3.0.10上仍然存在，看来只有祈祷了。