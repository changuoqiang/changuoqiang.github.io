---
title: debian testing桌面安装手记
tags:
  - Debian
id: '1534'
categories:
  - - GNU/Linux
date: 2011-06-24 20:05:15
---

Ubuntu越来越蛋疼,用的越来越不爽,还是用回debian吧,其实testing做桌面也是很爽的
<!-- more -->
刚好办公室新换电脑,带的OEM的windows 7 home basic 32bits,只启动了一次就惨遭毒手,换成了debian testing单系统。

下载[debian testing netinst iso amd64 daily build](http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/iso-cd/debian-testing-amd64-netinst.iso)或[debian testing iso amd64 cd1 weekly build](http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-CD-1.iso),当然首选netinst。

使用netinst安装基本系统。1T硬盘,分三个主分区,/dev/sda1分配给根文件系统/,/dev/sda2分配给home文件系统/home,/dev/sda3分配给swap分区,因为有4G内存,所以swap分了8G,其余都给了home。一步步按提示安装即可。只是现在的testing有点儿问题,grub-pc会安装失败,解决方法见[debian testing grub-pc安装失败解决方法](https://openwares.net/linux/debian_grub_install_fail.html)

安装完基本系统后,安装AMD显卡官方驱动,开源驱动3D性能还是差了不少,这里选择安装debian打包好的驱动,当然也可以去AMD官方下载驱动安装。

安装方法如下:

1、为/etc/apt/source.list增加non-free安装源
deb http://ftp.debian.org/debian testing main contrib non-free
更新源
#apt-get update

2、安装内核对应的linux-header包及驱动包
#apt-get install linux-headers-2.6-$(uname -r) fglrx-control fglrx-driver

3、卸载radeon和drm模块
#modprobe -r radeon drm

4、配置驱动
#aticonfig --initial 

最后安装xorg,gnome和gdm
#apt-get install xserver-xorg-core gnome-core gdm3

这样就安装好了基本的gnome桌面,本来想用fvwm做桌面,折腾了两天后发现这玩意儿一时半会儿上不了手,以后有时间再搞吧。