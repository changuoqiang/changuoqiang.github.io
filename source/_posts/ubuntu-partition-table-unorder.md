---
title: 'Ubuntu:Partition table entries are not in disk order'
tags:
  - Ubuntu
id: '31'
categories:
  - - GNU/Linux
date: 2009-05-01 19:59:00
---

前几天刚安装了ubuntu 9.04，在分区的时候，先从磁盘的最后面划出大约2G的空间做了swap,然后再分的/，/var，/tmp,/home。安装好了才发现，虽然swap在磁盘的最后面，其设备号却为/dev/sda6,排在其他分区的前面，sda1和sda5为XP使用的分区。虽然看着有些不爽，但是不影响使用，也就没管它。

今天用sudo fdisk -l查看分区表的时，在打印的分区列表最后面有一句话：Partition table entries are not in disk order，又勾起了我的洁癖，决定把分区表顺序调整过来。

sudo fdisk /dev/sda进入fdisk的shell,然后输入f回车就可以把分区顺序调整过来了，然后输入w保存退出。因为root分区的设备号从(hd0,6)变成了(hd0,5)，所以grub就会无法找到root分区,从而无法进行引导。

用ubuntu 9.04的livecd引导进入系统，进入grub,然后root (hd0,5),setup (hd0) 就可以了。
ubuntu9.04是用uuid来标示分区的，所以/etc/fstab和/boot/grub/menu.lst不用更改就可以顺利的启动系统了。