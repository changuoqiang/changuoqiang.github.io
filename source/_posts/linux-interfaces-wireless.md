---
title: linux环境通过interfaces文件配置无线网卡
tags:
  - Debian
id: '960'
categories:
  - - GNU/Linux
date: 2010-10-19 19:48:59
---

linux下通过/etc/network/interfaces配置无线网卡很简单,[adhoc模式的设置](https://openwares.net/linux/ubuntu_ad_hoc_network.html)已经写过了,再写一下访问无线AP的设置.
<!-- more -->
下面是DHCP方式访问wap2-psk加密的无线AP的设置
auto wlan0
iface wlan0 inet dhcp #static
#address 192.168.1.3
#netmask 255.255.255.0
#gateway 192.168.1.1
 
wpa-essid ssid_name
wpa-psk xxxxxxxxx #wap2访问密码

如果是wep方式访问无线AP,则最后两行改为
wireless-essid ssid_name
wireless-key xxxxxx #wep访问密码

这样开机就可以自动连入无线网络了

**UPDATE:**一定要确保安装了wpasupplicant包，这是WPA和WPA2的客户端支持组件，通过以下命令安装
$sudo apt-get install wpasupplicant