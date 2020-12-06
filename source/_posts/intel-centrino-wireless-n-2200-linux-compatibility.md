---
title: Intel Centrino Wireless-N 2200 linux兼容性问题
tags: []
id: '6962'
categories:
  - - GNU/Linux
date: 2015-11-28 11:02:12
---


<!-- more -->
intel迅驰无线网卡Centrino Wireless-N 2200在debian jessie系统下奇慢无比，连接速度只有1Mb/s,到网关的延迟有时达到1000ms以上。

是因为此无线网卡在802.11n模式下与当前内核存在兼容性问题。所以，要解决此问题，要么关闭无线网卡的802.11n模式，或者更改无线路由器不开启802.11n模式。

**关闭网卡的802.11n工作模式**

 /etc/modprobe.d目录下新建文件11n_disable.conf,添加如下行:
```js
options iwlwifi 11n_disable=1
```

重新启动机器。

References:
\[1\][Intel Centrino Wireless-N 2200 Ubuntu 1Mbps Workaround](http://syntaxionist.rogerhub.com/intel-centrino-wireless-n-2200-ubuntu-1mbps-workaround.html)
\[2\][How to fix slow wireless on machines with Intel wireless cards?](http://askubuntu.com/questions/119578/how-to-fix-slow-wireless-on-machines-with-intel-wireless-cards)

**\===
\[erq\]**