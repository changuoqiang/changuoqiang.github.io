---
title: ubuntu系统HTC G1通过笔记本wifi ad hoc网络共享宽带上网
tags:
  - Android
  - Ubuntu
id: '524'
categories:
  - - GNU/Linux
date: 2009-10-18 17:13:46
---

因为没有使用无线路由器，两台笔记本一直使用wifi的ad hoc模式网络互联，xp共享ubuntu的wifi上网。新入手黑色HTC G1，自然也想利用笔记本的ad hoc wifi网络共享上网，没必要再购置无线路由器。幸好G1支持wifi的ad hoc网络模式，拥有宽带的笔记本使用32bits ubuntu 9.04，记叙设置方法如下。

1、参考[Connect G1 to Ad-hoc network SOLVED](http://modmygphone.com/forums/showthread.php?t=22681)弄好G1端的wifi设置

2、因为我的ad hoc网络没有启用DHCP,笔记本ubuntu无线网卡wlan0的静态IP设置为10.42.43.1,mask为255.255.255.0,网关未设，所以设置G1的wifi也使用静态IP。G1的“wifi设置->高级”里面，这样设置，IP在一个网段即可，我设置为10.42.43.8,掩码为255.255.255.0,网关设置为ubuntu wlan0的IP，也就是10.42.43.1。可以根据个人情况自由选择私有网络地址。

3、默认设置下， ubuntu是不在多个接口间转发数据的，也就是没有开启路由功能，通过修改/etc/sysctrl.conf来打开IP转发功能。使net.ipv4.ip_forward=1就可以了，这是启用ipv4的转发功能，如果要启用ipv6的转发功能，使net.ipv6.conf.all.forwarding=1就可以了。这样ubuntu主机上来自ad hoc网络的请求就可以被路由到其他网络接口了。但是现在G1还不能访问internet,因为我们使用的是私有ip地址，是不能在公网上路由的，必须要进行NAT才可以。可以使用iptables来设置NAT规则，打开rc.local，在exit 0之前添加下面这几句:
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 10.42.43.0/24 -o ppp0 -j MASQUERADE

其中-s 10.42.43.0/24可以根据你使用的私有IP段和掩码位数来设置，-o ppp0根据你使用的上网宽带接口设置，我使用pppoe拨号，所以此处设置为ppp0。

ubuntu重启一下应该就可以了。