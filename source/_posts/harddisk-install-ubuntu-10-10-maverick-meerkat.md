---
title: 硬盘最小安装Ubuntu 10.10(Maverick MeerKat)
tags:
  - Ubuntu
id: '954'
categories:
  - - GNU/Linux
date: 2010-10-16 12:02:25
---

一、下载配置grub4dos
下载[grub4dos](http://sourceforge.net/projects/grub4dos/),解压后将grldr文件拷贝到C分区根目录,在c:\\boot.ini文件末尾增加一行c:\\grldr="grub4dos"
<!-- more -->
在C分区根目录下新建grub4dos配置文件menu.lst,内容如下:

title Ubuntu 10.10
find --set-root /ubuntu-10.10-alternate-amd64.iso
kernel /vmlinuz noacpi iso-scan/filename=/ubuntu-10.10-alternate-amd64.iso ro quiet splash
initrd /initrd.gz

二、下载Ubuntu 10.10硬盘安装映像
从官方下载[Maverick的硬盘安装映像](http://archive.ubuntu.com/ubuntu/dists/maverick/main/installer-amd64/current/images/hd-media/)vmlinux和initrd.gz,将这两个文件拷贝到C分区根目录

三、下载Ubuntu 10.10并开始安装
最小化安装要下载Alternate版本的iso镜像,从官方下载[Ubuntu 10.10 AMD64安装镜像种子](http://releases.ubuntu.com/maverick/ubuntu-10.10-alternate-amd64.iso.torrent)文件,下载后将ubuntu-10.10-alternate-amd64.iso放置到C分区根目录下.

重新启动机器,选择启动菜单的grub4dos项即可开始硬盘安装ubuntu,装完基本系统(base system)后不要选择安装其他组件即可完成最小化安装.