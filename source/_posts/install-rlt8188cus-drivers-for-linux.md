---
title: install rlt8188cus wireless lan drivers for linux
tags:
  - Debian
id: '2748'
categories:
  - - GNU/Linux
date: 2013-01-16 22:43:37
---

入手迷你无线网卡一枚,rtl8188cus芯片,真的相当小巧精致,而且信号还不错,记录安装过程以备忘
<!-- more -->
1、下载最新官方驱动

光盘自带的linux驱动稍微有些旧了,去realtek官方下载最新的[linux驱动](http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=3&PNid=48&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true#2742)。官方描述支持到kernel 3.0.8,实测debian wheezy当前的内核3.2.25安装没有问题。

2、编译安装

先安装编译环境
#apt-get install build-essential linux-headers-\`uname -r\`

将下载的zip文件解压得到文件夹RTL8188C_8192C_USB_linux_v3.4.4_4749.20121105,进入此文件夹,最简单的安装方法是执行其下的脚本install.sh

为install.sh添加执行权限
$chmod +x install.sh

然后以超级用户身份执行
#./install.sh

会自动编译安装内核模块8192cu.ko

3、blacklist老的8192驱动

上一步的安装最后会提示以下字样:
insmod: error inserting '8192cu.ko': Device or resource busy

如果
#modprobe 8192cu.ko
也会有类似的提示
这是因为老的驱动rtl8192cu已经加载导致的冲突,所以需要将其加入黑名单
#vim /etc/modprobe.d/blacklist.conf
写入
blacklist rtl8192cu
保存退出

然后
#rmmod rtl8192cu
#modprobe 8192cu
或者直接重新启动

再看
#ifconfig wlan0
就显示正常了

用network-manager连接热点测试,速度还算不错,虽然个头那么小。