---
title: Debian安装P1008打印机
tags:
  - Debian
id: '4711'
categories:
  - - GNU/Linux
date: 2014-01-06 17:01:00
---


<!-- more -->
直接连上打印机虽然看起来好像是安装成功了，但是不能打印的，因为缺少firmware。

printer-driver-foo2zjs带了应用程序getweb可以用来下载对应的firmware并转换到linux可以使用的格式:

# getweb P1008
sihpP1006.img

(c) Copyright Hewlett-Packard 2009

这样/lib/firmware/hp下会安装了P1008可以使用的firmware文件sihpP1006.dl

这样就可以正常使用P1008了。