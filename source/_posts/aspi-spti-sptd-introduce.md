---
title: 'ASPI,SPTI,SPTD简介'
tags: []
id: '790'
categories:
  - - Misc
date: 2010-04-03 23:27:39
---

这三个东西都是用来支持主机与外围SCSI或ATAPI接口存储设备通讯的编程接口。ASPI(Advanced SCSI Programming Interface)是由存储领域大名鼎鼎的Adaptec于1990年代初期开发的，最初是为了支持SCSI驱动器，后来加入了ATAPI驱动器的支持。MS获取授权在windows 9x系列使用这个开发接口。后来MS在NT系列开发了自己的接口，这就是SPTI(SCSI Pass Through Interface)用以取代ASPI。NT系统默认是没有安装ASPI驱动的，不过有些存储应用程序还在使用ASPI接口，可以从Adaptec下载[此驱动](http://www.adaptec.com/en-US/speed/software_pc/aspi/aspi_471a2_exe.htm)安装。而SPTD则是由Duplex Secure Ltd.开发的同类接口。

此外，Nero也开发了自己的ASPI驱动。其他比较有名的还有ASAPI等。