---
title: linux系统添加windows共享打印机
tags:
  - Debian
id: '2231'
categories:
  - - GNU/Linux
date: 2012-05-14 09:40:39
---

Debian AMD64 testing添加windows共享打印机简单步骤
<!-- more -->
1、安装cups(Common UNIX Printing System)
#apt-get install cups

2、打开cups web管理界面

浏览器输入网址http://127.0.0.1:631打开cups管理界面

3、添加共享windows共享打印机

进入Administration页面,点击"Add Printer",选择"Windows Printer via SAMBA",点击continue。然后在"Connection:"输入框内输入共享打印机的地址,

smb://ip/HPLaserJ

ip是共享打印机所在windows机器的ip,HPLaserJ是打印机的网络共享名。

如果需要密码来访问共享打印机,则需要添加用户名和密码,如下
smb://username:passwd@ip/printer_share_name

点击continue继续,为共享打印机提供一个本地名字name,Description与Location字段选填，如果不从本机对外继续共享此网络打印机,不要勾选"Share This Printer",默认未勾选。

点击continue继续,Make栏选择打印机厂商,这里选择HP,点击continue继续,选择打印机型号Model,这是选择的是"HP LaserJet P1008 Foomatic/foo2xqx (recommended)(en)",然后点击add printer添加网络打印机完成。

4、打印测试页

从CUPS管理界面进入printer页面，点击刚添加的共享打印机,这里是P1008,然后从maintence下拉框选择Print Test Page即可。