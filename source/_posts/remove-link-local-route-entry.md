---
title: ubuntu 9.10 删除link-local 路由表项
tags:
  - Ubuntu
id: '657'
categories:
  - - GNU/Linux
date: 2009-12-21 21:19:48
---

route -n 时你总能看到这样一条路由

Destination Gateway Genmask Flags Metric Ref Use Iface
169.254.0.0 0.0.0.0 255.255.0.0 U 1000 0 0 eth0

由RFC3330 可知 169.254.0.0/16 为本地链路地址

"169.254.0.0/16 - This is the "link local" block. It is allocated for
 communication between hosts on a single link. Hosts obtain these
 addresses by auto-configuration, such as when a DHCP server may not
 be found."

当系统配置为使用动态地址，而找不到DHCP服务器时，系统会为本机设置一个169.254.X.X的地址。
这个路由表项是有zeroconf 协议Daemon 程序添加的,我们一般是用不到的

只是注释掉/etc/networks 里面的link-local 项是无法去掉该路由表项的,/etc/networks 与/etc/hosts
文件的作用差不多,是用来关联网络号(数字格式)和网络名(字符格式)的,注释掉该条目后,只是169.254.0.0
无法解析为网络名link-local了.

可以用以下命令来删除zeroconf 相关的程序包
sudo apt-get remove avahi-autoipd --purge
下次启动机器后这条路由就不会自动出现了.