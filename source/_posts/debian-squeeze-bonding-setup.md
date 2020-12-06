---
title: Debian Squeeze 多网卡bonding设置
tags:
  - Debian
id: '1446'
categories:
  - - GNU/Linux
date: 2011-05-09 21:36:36
---

通过多网卡bonding可以提供负载均衡,或者网卡热备(hot standby)
<!-- more -->
**介绍**

先来看下官方文档/usr/src/linux/Documentation/networking/bonding.txt对bonding的介绍

The Linux bonding driver provides a method for aggregating multiple network interfaces into a single logical "bonded" interface.The behavior of the bonded interfaces depends upon the mode; generally speaking, modes provide either hot standby or load balancing services.Additionally, link integrity monitoring may be performed.

linux bonding驱动提供了聚合多个网络接口成为一个单一逻辑绑定网络接口的方法。绑定网络接口的行为依赖于绑定模式，一般来说，绑定模式不外乎网卡热备(hot standby)或者负载均衡(load balancing)。此外，bonding驱动还会监视链路的完整性。

也就是说bonding通过绑定多个网络接口为一个逻辑网络接口来提供网络可靠性或均衡网络流量，这对于服务器来讲是很重要的。对于重要的应用bonding可以通过hot standby来提供failover特性，提高系统的可靠性。而对于像文件服务器这样的对网络要求很高的场合,bonding可以极大的提高网络IO性能。

**配置**

bonding并不需要网络接口卡型号完全一致,我绑定了两块物理网卡，一块是intel 82574L,另一个块是intel 82576，配置完成后没有任何问题。

1、安装ifenslave-2.6
$sudo apt-get install ifenslave-2.6

2、修改网络接口配置文件/etc/network/interfaces
 1 \# This file describes the network interfaces available on your system  
 2 \# and how to activate them. For more information, see interfaces(5).  
 3   
 4 \# The loopback network interface  
 5 auto lo  
 6 iface lo inet loopback  
 7   
 8 \# The primary network interface  
 9 auto bond0  
10 iface bond0 inet static  
11     address 192.168.0.18  
12     netmask 255.255.255.0  
13     network 192.168.0.0  
14     broadcast 192.168.0.255  
15     gateway 192.168.0.1  
16     slaves eth0 eth1  
17     bond-mode balance-rr  
18     bond-miimon 100  

第16行 slaves eth0 eth1，说明绑定两个“从网卡”eth0和eth1到bond0逻辑接口,如果要绑定多个网络接口,继续在该行附加网络接口名字即可。

第17行 bond-mode balance-rr，指定绑定模式为采用Round-robin策略的负载均衡模式,两个网络接口会均匀分担网络负载，另一个常用模式为active-backup，也就是hot standby模式，支持网络接口failover

3、重新启动网络

$sudo /etc/init.d/networking restart

如果重新启动网络时有bonding: Warning:字样的提示，则需要在/etc/modprobe.d目录下新建文件aliases-bond.conf,内容为
alias bond0 bonding
为bonding模块建立一个别名bond0,通过别名bonding模块可以支持多个bonding逻辑接口。

配置完成。

**UPDATE:**

在Debian Squeezy(kernel 2.6.32-5-amd64,kvm 0.12.5)上配置bonding曾经遇到问题,[网络极度不稳定](https://twitter.com/#!/openwares/status/75503003687337984),怀疑是兼容性问题。今天刚好发现有个家伙也遇到[bonding后速度极其缓慢](http://www.spinics.net/lists/kvm/msg54612.html),和我一样的系统环境。这家伙说关闭网卡的LRO([Large receive offload](https://openwares.net/internet/lro_intro.html))特性后恢复正常。不过查看两块网卡接口的LRO特性都是关闭的,怀疑中,抽空实验一下。

**UPDATE:**在debian wheezy(kernel 3.2.0.2-amd64,kvm 1.0)上bonding问题依旧,active-backup模式,从外部根本无法ping通客户机,去掉bonding就没由任何问题,而且网卡的LRO特性都是关闭的。基本可以确认KVM与bonding加桥接网络存在兼容性问题。