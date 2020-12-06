---
title: auto与allow-hotplug的区别
tags:
  - Debian
id: '2469'
categories:
  - - GNU/Linux
date: 2012-09-14 20:55:57
---

/etc/network/interfaces文件中一般用auto或者allow-hotplug来定义接口的启动行为。
<!-- more -->
**auto**

语法：
auto <interface_name>
含义：
在系统启动的时候启动网络接口,无论网络接口有无连接(插入网线),如果该接口配置了DHCP,则无论有无网线,系统都会去执行DHCP,如果没有插入网线,则等该接口超时后才会继续。

**allow-hotplug**

语法:
allow-hotplug <interface_name>

含义：
只有当内核从该接口检测到热插拔事件后才启动该接口。如果系统开机时该接口没有插入网线,则系统不会启动该接口,系统启动后,如果插入网线,系统会自动启动该接口。也就是将网络接口设置为热插拔模式。

**手动重新启动网络**

一般修改了网络配置文件后,会用以下命令重新启动网络
# /etc/init.d/networking restart
但从squeeze开始,此命令会有如下提示:

Running /etc/init.d/networking restart is deprecated because it may not enable again some interfaces ... (warning).
Reconfiguring network interfaces...done.

如果设置接口为auto,虽然会有如此提示,但接口仍然会正确的启动。
如果接口设置为allow-hotplug则没有这么走运了,网络接口不会正确启动。这种情况下必须使用如下命令启动网络接口:
#ifup <interface_name>
而命令
#ifconfig <interface_name> up
也无法正确启动接口

所以allow-hotplug设置的接口最好如下方式重新启动网络接口,当然auto方式的接口也没问题:

#ifdown <interface_name> && ifup <interface_name>

特别是在ssh登录远程主机的情况下,一定要像上面这样在一条命令里执行ifdown和ifup,否则,如果先执行ifdown,则再也没有机会执行ifup了。

看来大多数情形下,网络接口还是用auto方式比较省心。

**注(6/3/2019)：如果配置网桥，一定不要用allow-hotplug，要用auto。**