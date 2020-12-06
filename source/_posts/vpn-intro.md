---
title: VPN技术简介
tags: []
id: '2530'
categories:
  - - Misc
date: 2012-10-15 15:13:02
---

VPN(Virtual Private Network)虚拟专用网络在公用网络上建立一个安全的加密通道,常用于企业分支机构之间的通讯,或个人远程接入企业内网。
<!-- more -->
VPN通过认证、加密的隧道携带用户数据通过公共网络来保证其安全性。
最常见的VPN技术有PPTP,L2TP/IPSec,IPSec,SSL VPN,OponVPN等。

**PPTP**
Point to Point Tunneling Protocol 点对点隧道协议

PPTP主要用于windows平台,PPTP本身并未包括认证和加密特性,PPTP属专有厂商协议,并不是IETF批准的国际标准,单独使用PPTP并无法保证其安全性。
PPTP只能用于IP网络。

**L2TP/IPSec**
Layer Two Tunneling Protocol 二层隧道协议

L2TP是IETF标准。L2TP自身并不对携带的数据加密,通常与IPSec搭配使用从而实现对数据的加密和完整性校验,这就是L2TP/IPSec的由来。L2TP可用于IP、ATM、帧中继、X.25等网络。
L2TP与PPTP一样使用PPP协议来封装携带的数据。L2TP支持隧道验证,PPTP则不支持。

**IPSec**
Internet Protocol Security IP安全

原始的IP协议并没有提供分组的安全性和完整性,两个端点之间的任何一跳都可以监听IP流量,而且可以伪造IP分组。IPSec工作于IP层,可以透明的为上层提供加密服务,其上层不用做任何修改即可享受到安全保障。IPv6强制使用IPSec。SSL/TLS则工作于传输层。

只使用IPSec即可以实现完整的VPN功能,支持net-to-net和road warrior模式,但主要用于类unix系统。L2TP/IPSec使用ppp协议,在复杂的NAT环境下实现road warrior更方便,而且其他平台的兼容性更好。

**SSL VPN**

SSL VPN则是在客户和web应用之间附加一个https通道,由SSL协议来认证用户和加密数据。SSL VPN一般是在企业网络内部放置一个SSL代理服务器,客户首先链接到SSL代理服务器,通过身份认证之后,SSL代理服务器会在客户和web应用之间传输数据。一般使用证书来认证客户端。

SSL VPN的优势在于部署简单,无需特别的客户端配置,只要使用浏览器即可,而且可以通过其他形式VPN传播的局域网病毒无法通过SSL VPN传播。

SSL VPN的缺点则是一般只适用于B/S模式的应用程序,并不是一个通用的VPN解决方案。

**OpenVPN**

OpenVPN则是一种混合型的VPN,并不与其他VPN兼容,也不是基于web的。它对自己的定义是“SSL/TLS based user-space VPN”。OpenVPN可以通过TAP/TUN驱动来创建二层/三层隧道。

OpenVPN使用通用网络协议（TCP与UDP）,而且所有的通信都基于一个单一的IP端口,使它成为IPsec等协议的理想替代，尤其是在ISP过滤某些特定VPN协议的情况下,比如可以使用80端口。

OpenVPN可以在NAT环境下很好的工作。

OpenVPN需要专用的客户端来接入OpenVPN虚拟网络,支持常见的各种系统平台,能在Solaris、Linux、OpenBSD、FreeBSD、NetBSD、Mac OS X与Windows 2000/XP/Vista/Windows 7以及Android上运行。