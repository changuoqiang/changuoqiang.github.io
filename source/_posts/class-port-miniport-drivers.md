---
title: '磁盘类,端口,小端口驱动(Class,Port,Miniport Drivers)'
tags: []
id: '796'
categories:
  - - Misc
date: 2010-04-08 20:23:44
---

During initialization, the Windows I/O manager starts the disk storage drivers. Storage drivers in Windows follow a class/port/miniport architecture, in which Microsoft supplies a storage class driver that implements functionality common to all storage devices and a storage port driver that implements functionality common to a particular bus—such as a Small Computer System Interface (SCSI) bus or an Integrated Device Electronics (IDE) system—and OEMs supply miniport drivers that plug into the port driver to interface Windows to a particular controller implementation.

系统初始化期间,windows I/O管理器开始装载磁盘存储驱动.windows中的存储驱动遵循类/端口/小端口(class/port/miniport)架构,MS提供一个存储类驱动实现与具体设备无关的、所有存储设备共同的功能特性和一个存储端口驱动实现一类特殊总线共同的功能---比如SCSI(Small Computer System Interface)总线或者IDE(Integrated Device Electronics)总线---然后OEM(Original Equipment Manufacturer)制造商提供挂接到端口驱动的小端口驱动来为windows提供到一个特殊控制器实现的访问接口。

\---译自《windows internals》(5th)