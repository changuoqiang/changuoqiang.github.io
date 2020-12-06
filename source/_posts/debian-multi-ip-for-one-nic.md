---
title: debian系统单网络接口绑定多IP地址
tags:
  - Debian
id: '2742'
categories:
  - - GNU/Linux
date: 2013-01-09 14:13:28
---

有时候需要一块网卡绑定多个IP
<!-- more -->
debian系统下只要简单的修改下/etc/network/interfaces文件就可以了,比如在eth0接口上绑定更多的IP地址,只需添加如下行:
auto eth0:0
iface eth0:0 inet static
 address 192.168.0.200
 netmask 255.255.255.0

auto eth0:1
iface eth0:1 inet static
 address 192.168.0.201
 netmask 255.255.255.0
这样就添加了另外两个IP,192.168.0.200和192.168.0.201,完整的interfaces文件看起来是这样的:

auto eth0
iface eth0 inet static
 address 192.168.0.203
 netmask 255.255.255.0
 network 192.168.0.0
 broadcast 192.168.0.255
 gateway 192.168.0.1
 # dns-* options are implemented by the resolvconf package, if installed
 dns-nameservers 8.8.8.8
 dns-search localdomain

auto eth0:0
iface eth0:0 inet static
 address 192.168.0.200
 netmask 255.255.255.0

auto eth0:1
iface eth0:1 inet static
 address 192.168.0.201
 netmask 255.255.255.0