---
title: USB stick安装debian
tags:
  - Debian
id: '1582'
categories:
  - - GNU/Linux
date: 2011-07-04 16:19:28
---

一直以来基本上都是刻录光盘来安装debian,但是这样还是比较浪费的,刻过好多光盘了
<!-- more -->
最初也用硬盘安装过，但是起码要有一个系统存在才可以从硬盘安装。新换的PC上带有8合1读卡器,通过lsusb可以看到读卡器是USB接口，那应该是可以通过读卡器来安装系统。正好手上有一个sony的256M记忆棒memory stick pro,正好可以废物利用了。

现在debian的ISO镜像都是hybrid格式,可以方便的直接写入USB stick,制作起来特别简单。因为记忆棒只有256M，刚好能容下netinst网络安装镜像。下载安装镜像，插入记忆棒

#fdisk -l

可以看到记忆棒的设备名为/dev/sdc,不同的机器设备名会不同,一般为/dev/sdX,X是从a到z的字母,一般/dev/sda为第一块硬盘。有一点要明白，写入光盘镜像后，记忆棒里面原有的内容会全部被覆盖，丢失，所以一定要先把记忆棒里面重要的东西备份出来。通过以下命令来制作usb启动设备

#cat debian.iso > /dev/sdc 
#sync

这样就制作完成了。进入BIOS选择启动设备，可以发现一个可引导的设备，名字叫USB KEY1:GENERIC STORAGE DEVICE 9744，就是它了，让它做第一个引导设备，重新启动机器，顺利进入debian安装界面。

dd命令应该也没问题,不过我没试
#dd if=debian.iso of=/dev/sdc

看来如果再安装系统就可以不用刻录光盘了。