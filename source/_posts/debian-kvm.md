---
title: 'Debian Squeeze KVM虚拟机安装笔记(1):基础'
tags:
  - KVM
id: '1466'
categories:
  - - GNU/Linux
date: 2011-05-11 10:58:47
---

基于内核的虚拟机KVM(Kernel-based Virtual Machine)是linux平台上的全虚拟化解决方案
<!-- more -->
KVM需要包含虚拟化支持的x86硬件,intel VT或者AMD-V。KVM使用修改后的QEMU作为前端工具,QEMU通过/dev/kvm设备与KVM交互。自kernel版本2.6.20 KVM随主线内核一起发行。

**前提条件(prerequisite)**

可以使用KVM的前提条件是CPU支持虚拟化技术,Intel VT或者AMD-V
```js
$ egrep '(svmvmx)' /proc/cpuinfo
```
如果有输出则说明CPU支持硬件虚拟化,SVM(Secure Virtual Machine)是AMD CPU支持硬件虚拟化的标志,VMX是INTEL CPU支持硬件虚拟化的标志

**KVM安装**
```js
$sudo apt-get insall qemu-kvm
```
从squeeze开始KVM的包名改为qemu-kvm,kvm只是个占位dummy包

**创建vdisk**
```js
$qemu-img create -f qcow2 client.qcow2 60G
```
创建一个60G的qcow2格式的虚拟磁盘文件,更多参数见man qemu-img

**桥接网络**

KVM支持很多网络类型,但是使用最方便的还是桥接网络,设置桥接网络,系统中必须存在以下三个命令
/sbin/ip
/usr/sbin/brctl
/usr/sbin/tunctl
所以需要安装一下包
```js
$sudo apt-get install bridge-utils uml-utilities
```

编辑/etc/network/interfaces文件增加网络桥,增加的网络桥接口名字为br0,将主机网络接口桥接到此网络桥
 1 \# This file describes the network interfaces available on your system  
 2 \# and how to activate them. For more information, see interfaces(5).  
 3   
 4 \# The loopback network interface  
 5 auto lo  
 6 iface lo inet loopback  
 7   
 8 \# The primary network interface  
 9 #allow-hotplug eth0  
10 #iface eth0 inet static  
11 #   address 192.168.0.18  
12 #   netmask 255.255.255.0  
13 #   network 192.168.0.0  
14 #   broadcast 192.168.0.255  
15 #   gateway 192.168.0.1  
16 #   # dns-* options are implemented by the resolvconf package, if installed  
17 #   dns-nameservers 211.137.191.26  
18 #   dns-search localdomain  
19   
20 auto bond0  
21 iface bond0 inet manual  
22 #    address 192.168.0.18  
23 #    netmask 255.255.255.0  
24 #    network 192.168.0.0  
25 #    broadcast 192.168.0.255  
26 #    gateway 192.168.0.1  
27     slaves eth0 eth1  
28     bond-mode balance-rr  
29     bond-miimon 100  
30   
31 auto br0  
32 iface br0 inet static  
33     address 192.168.0.18  
34     netmask 255.255.255.0  
35     network 192.168.0.0  
36     broadcast 192.168.0.255  
37     gateway 192.168.0.1  
38     bridge_ports    bond0  
39     bridge_stp  off  
40     bridge_maxwait  0  
41     bridge_fd   0     
42   
43 #auto tap0  
44 #iface tap0 inet manual  
45 #up ifconfig $IFACE 0.0.0.0 up  
46 #down ifconfig $IFACE down  
47 #tunctl_user yourusername  

第38行 bridge_ports bond0,此处将主机的bonding接口bond0加入网络桥,如果没有网络接口聚合此处一般应为eth0
第47行将youeusername改为你登陆主机的用户名

使用桥接网络,客户机必须使用主机的一个tap设备将客户机的网络接口连接到主机的网络桥,tap设备可以用两种方式来设置

一种是静态方式，直接把tap设备的配置写道/etc/network/interfaces文件中，并将tap接口加入网络桥，将配置文件43-47行前的注释符#去掉，并将第38行改为如下
bridge_ports bond0 tap0
增加更多的tap接口依次类推

另一种为动态方式，网络配置文件中不写任何tap设备的配置，而由KVM的脚本/etc/kvm/kvm-ifup来动态完成tap接口的创建,以后创建客户机是会提到怎么用。

**半虚拟化驱动Virtio**

Virtio是KVM/Linux的I/O虚拟化框架，以增强KVM的IO效率,是与其他虚拟化平台的半虚拟化(Paravirtualized)类似的东西,主要应用于磁盘设备和网络接口设备。主流的linux发行版已经默认支持Virtio，如果客户机是linux则无需其他设置，直接可以使用Virtio设备，但是如果客户机是windows，则需要在客户机安装Virtio设备驱动，甚至在windows开始安装之前需要提前加载块设备驱动。windows Virtio驱动可从Fedora[下载](http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/)。

如何安装客户虚拟机下篇再议。