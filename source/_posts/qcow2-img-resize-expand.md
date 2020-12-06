---
title: 扩大qcow2格式kvm虚拟镜像磁盘大小
tags:
  - Debian
  - KVM
id: '2871'
categories:
  - - GNU/Linux
date: 2013-03-14 09:59:56
---

缩写见以前的一篇文字"[缩小qcow2格式kvm虚拟镜像磁盘大小](https://openwares.net/linux/shrink_kvm_qcow2_disk.html)"
<!-- more -->
相对于缩写qcow2镜像文件大小，扩大则简单的多

首先，qemu-img resize 命令增加镜像文件的大小，如
#qemu-img resize origin.qcow2 +20G

此时，对于虚拟客户机来说，只是硬盘增大了，但其文件系统并未扩展以使用新的硬盘空间，所以还需要使用分区工具来扩展客户机的文件系统

然后，挂载gparted iso镜像为虚拟机的光驱，并从光驱启动，使用gparted扩展客户机的文件系统至硬盘的空闲部分即可。
扩展完毕，用客户机的镜像文件启动，不同的客户操作系统有不同的反应，linux客户机直接就可以使用了，windows客户机可能会有一些提示，并要求重新启动云云。