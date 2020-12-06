---
title: linux route命令
tags:
  - Debian
id: '2682'
categories:
  - - GNU/Linux
date: 2012-10-25 11:01:43
---

route命令用于查看和修改IP路由表
<!-- more -->
## **格式**

route \[-CFvnee\]

route \[-v\] \[-A family\] add \[-net-host\] target \[netmask Nm\] \[gw Gw\] \[metric N\] \[mss M\] \[window W\] \[irtt I\] \[reject\]
 \[mod\] \[dyn\] \[reinstate\] \[\[dev\] If\]

route \[-v\] \[-A family\] del \[-net-host\] target \[gw Gw\] \[netmask Nm\] \[metric N\] \[\[dev\] If\]

route \[-V\] \[--version\] \[-h\] \[--help\]

## **选项**

**\-A** family 指定网络地址类型,默认为inet即internet v4版本,支持的地址类型有：
inet (DARPA Internet) inet6 (IPv6) ax25 (AMPR AX.25) netrom (AMPR NET/ROM) ipx (Novell IPX) ddp (Appletalk DDP) x25 (CCITT X.25) 
**\-F** 操作内核的FIB(Forwarding Information Base)路由表,这是默认值。
**\-C** 操作内核的路由缓存
**\-v** 冗余显示模式
**\-n** 显示数字地址而不是主机名
**\-e** 使用netstat格式显示路由表
**\-ee** 显示更多的路由表信息

## **命令**

**del** 删除路由表
**add** 添加路由表

**del或add命令子选项：**

**\-net** 指定路由目标target为网络
**\-host** 指定路由目标target为主机
**target** 目标网络或主机,可以为IP地址或主机/网络名称。target为"0.0.0.0"或者"default"的路由条目为默认路由。
**netmask NM** 当增加网络路由时指定网络掩码,当target为主机时不用也不能指定掩码(其实掩码默认为255.255.255.255)
**gw GW** 指定网关。如果目标是不经网关直接可到达的,那么不用指定网关,此时路由表中Gateway会显示为0.0.0.0
**metric M** 指定路由表项的度量metric为M,此值愈小的路由表项优先级愈高
**mss M** 指定此路由的TCP最大段大小(Maximum Segment Size)为M字节,默认值为设备最大传输单元MTU(Maximum Transmission Unit)减去IP头部。当路径MTU发现机制无法正常工作时可以指定一个较小的TCP包。
**window W** 指定此路由TCP窗口尺寸为W字节
**irtt I** 指定此路由初始往返时间(initial round trip time)为I毫秒。
**reject** 此路由表项的目标将被阻止,即使存在默认路由。
**mod,dyn,reinstate** 增加一个动态或修改过的路由,此选项用于诊断目的,一般只有路由守护程序设置此选项。
**dev If** 强制此路由与指定的接口设备If关联,否则内核会自己决定此路由使用哪一个接口设备。如果dev If是命令的最后一个选项,dev关键字可以省略。

## **样例**

增加到主机10.100.0.3的路由,网络是直连的,无需经过网关,通过网络接口ppp0进行路由
#route add -host 10.100.0.3 dev ppp0

增加到网络10.100.0.0/24的路由,分组经过网关10.100.0.1,通过网络接口ppp0路由。
#route add -net 10.100.0.0 netmask 255.255.255.0 gateway 10.100.0.1 dev ppp0

删除默认路由
#route del default

添加默认路由,网关192.168.0.1,分组通过网络设备wlan0
#route add default gateway 192.168.0.1 dev wlan0

## **路由表输出格式**

**Destination** 目标网络或主机,"0.0.0.0"或"default"为默认路由,可以有多条默认路由,通过metric开区分优先级,metric值越低优先级越高

**Gateway** 网关地址,"0.0.0.0"标示网络是直连的,无需经过网关

**Flags** 标志

*   U 路由项是生效的(Up)
*   H 路由目标为主机(Host)
*   G 使用网关(gateway)
*   R 动态选路恢复路由(Reinstate)
*   D 路由守护程序或重定向添加路由(Dynamic)
*   M 路由守护程序或重定向修改路由(Modified)
*   A 由addrconf程序添加的路由
*   C 缓存路由项
*   ! 拒绝的路由

**Metric** 到路由目标的距离度量,一般用跳(hop)来度量。
**Ref** 路由被引用的次数,其他路由依赖于本路由算作引用
**Use** 路由被使用的次数
**Iface** 路由使用的接口地址,从此接口发送此路由的数据
**MSS** 经过此路由的TCP最大段尺寸(Maximum Segment Size)
**Window** 此路由TCP连接的窗口大小
**irtt** 初始往返时间Initial RTT (Round Trip Time)。内核使用此参数来估算最佳的TCP参数。
**Arp** 缓存路由的硬件地址是否是最新的,只适用于缓存的路由。