---
title: PXE网络安装Debian
tags:
  - Debian
id: '742'
categories:
  - - GNU/Linux
date: 2010-01-17 15:33:37
---

近期收拾一台老本本IBM thinkpad 390X,虽有光驱，但已无法使用。网卡支持PXE(Preboot eXecution Environment)，于是以PXE方式启动安装Debian。
　　PXE网络安装或启动需要BOOTP(Bootstrap Protocol)和TFTP(Trivial File Transfer Protocol)服务支持。通过BOOTP服务获取本机IP和启动映像(boot image)所在的网络位置，通过TFTP服务来获取启动映像。DHCP(Dynamic Host Configuration Protocol)是一个更具弹性的，兼容BOOTP的动态主机配置协议，因此在局域网内安装TFTP和DHCP服务器即可。
<!-- more -->
1\. 安装配置DHCP服务器
```js
$ sudo apt-get install dhcp3-server
```
　　在/etc/dhcp3/dhcpd.conf文件内添加以下内容
```js
allow booting;
allow bootp;

subnet 192.168.1.0 netmask 255.255.255.0 { 
 #根据实际的局域网设置配置
 range 192.168.1.10 192.168.1.20;
 option routers 192.168.1.2;
# option domain-name "localdomain";
 option domain-name-servers 8.8.8.8;
}

host tftpclient {
 #以实际的需要PXE方式引导的机器网卡MAC地址为准 
 hardware ethernet 00:E0:00:1A:5D:43; 
 filename "pxelinux.0";
}
```　　
　　2. 安装配置TFTP服务器
```js
$ sudo apt-get install tftpd-hpa
```
　　修改/etc/default/tftpd-hpa文件内的行RUN_DAEMON="no"为RUN_DAEMON="yes",然后重新装载配置或启动inet服务
　　
　　3. 准备PXE启动映像
　　打开/etc/inetd.conf文件，找到tftp开头的行，最后的参数列是一个路径名，这个路径就是TFTP提供文件服务的根路径，Debian及衍生系统上一般为/var/lib/tftpboot。下载Debian PXE网络安装映像[netboot.tar.gz](http://ftp.nl.debian.org/debian/dists/lenny/main/installer-i386/current/images/netboot/)并解压到/var/lib/tftpboot。

　　最后以PXE启动电脑就可以从网络开始安装了。

**\===
\[erq\]**