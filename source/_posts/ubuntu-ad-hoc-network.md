---
title: ubuntu配置ad hoc网络
tags:
  - Ubuntu
id: '687'
categories:
  - - GNU/Linux
date: 2009-12-29 22:49:35
---

　　Network manager老难用了，忍无可忍之后将其remove,据说wicd不错，装上试了试也卸载掉了。其实linux的世界，还是cli用起来最顺手。
　　
　　配置一个ad hoc网络很简单的，在/etc/network/interfaces里面添加就可以了，我的设置如下：

auto wlan0
iface wlan0 inet static
wireless-mode ad-hoc
wireless-channel 11
wireless-essid Adhoc
address 10.42.43.1
netmask 255.255.255.0
gateway 10.42.43.1

　　还是比较直白的，一般我们就一个无线网卡，没意外名字就是wlan0了，选个没有重叠的wifi信道11，设置一下IP、掩码、网关就好了。