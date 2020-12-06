---
title: debian添加静态路由
tags:
  - Debian
id: '2777'
categories:
  - - GNU/Linux
date: 2013-01-20 19:52:42
---

有线和无线分属不同网络,添加静态路由以使网络各行其道
<!-- more -->
debianx系统添加静态路由最简单的办法就是在/etc/network/interfaces文件里添加静态路由表项,路由表项经过那个接口就将其写在那个接口下面,比如在eth0接口下添加一条静态路由
```js
auto eth0
iface eth0 inet dhcp
 up route add -net 10.100.0.0/24 gateway 192.168.0.1 dev eth0
 down route del -net 10.100.0.0/24 gateway 192.168.0.1 dev eth0
```
route命令的[详细用法](https://openwares.net/linux/linux_route_intro.html)。

在接口eth0激活时添加一条静态路由,路由目的为网络10.100.0.0/24,网关为192.168.0.1,该条路由使用eth0接口。当接口eth0关闭时删除该条静态路由。

路由表项以下写法也是一样的：
```js
route add -net 10.100.0.0 netmask 255.255.255.0 gateway 192.168.0.1 dev eth0
```
也可以将route命令添加到/etc/rc.local文件中使其成为永久静态路由。

**\===
\[erq\]**