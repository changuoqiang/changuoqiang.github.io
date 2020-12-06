---
title: 使用OpenVPN Settings管理Android OpenVPN客户端
tags:
  - Android
id: '1329'
categories:
  - - GNU/Linux
date: 2011-04-08 21:03:30
---

曾经写过一篇[Android手机OpenVPN客户端设置](https://openwares.net/mobile/openvpn_for_android_setup.html)的文字,但是每次要打开终端操作还是太繁琐了
<!-- more -->
市场里有一款软件OpenVPN Settings大大简化了Android手机OpenVPN客户端的操作。

先按照那篇文字设置好OpenVPN,然后打开OpenVPN Settings,打开Advanced设置菜单,如下图
[![](/images/2011/04/openvpn_setting.png "openvpn_setting")](https://openwares.net/linux/openvpn_settings_manual.html/attachment/openvpn_setting)

关于是否要"Load tun kernel module",主要看ROM有没有把tun编译进内核,在终端下输入以下命令：

#ls /dev grep tun

如果有输出说明内核已经支持tun设备,无需再让OpenVPN settings加载tun模块；如果没有输出,则需要先加载tun.ko内核模块，才可以使用vpn。如需加载，点击打开"TUN module settings","Load module using"选择insmod,"Path to tun module"输入tun.ko完整的路径，一般为/lib/modules/tun.ko

"Path to configurations"输入配置文件路径/sdcard/openvpn
"Path to openvpn binary"输入下载的[静态openvpn](https://github.com/downloads/fries/android-external-openvpn/openvpn-static-2.1.1.bz2)二进制文件所在位置/system/xbin/openvpn

这样使用起来就方便多了