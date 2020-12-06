---
title: systemd之确定的网络接口名
tags:
  - Debian
id: '6704'
categories:
  - - GNU/Linux
date: 2015-10-08 21:23:32
---


<!-- more -->
传统的eth0,eth1,wlan0,wlan1等网络接口名字,在多网络接口卡的环境下，有多种因素会导致网络接口的名字与实际对应的网络设备发生变化，比如这次的eth0,可能下次系统重新启动后会变成eth1,这自然会导致很多很多问题。

当然出现了很多解决方案来避免这个问题，比如udev可以使一个网络接口的名字与网络接口的MAC地址绑定,从而只要还是那块网卡，对应的网络接口的名字就还是那个名字。

还有一种解决方案为"biosdevname",当然systemd认为这些方案都有各种各样的问题，于是又有了它自己的解决方案。

systemd果然像有些人所言，想要控制一切！

systemd自v197开始使用自己的命名方案，但是只有全新安装的系统才默认使用这个命名规则，系统升级而来继续使用原先的方案。

所以这次系统重装后，发现wlan接口名字变成了

```js
$ iw dev
phy#0
 Interface wlx2016d803b954
 ifindex 2
 wdev 0x1
 addr 20:16:d8:03:b9:54
 ssid xxxxxxxx
 type managed
```

竟然用的是MAC地址,如果MAC地址改变了呢？

查看内核信息:

```js
$ dmesg grep wlan0
\[ \] rtl8723au 1-1.4:1.2 wlx2016d803b954: rename from wlan0
```

原来是systemd给改了名字,各种不适应,名字各种长。

可以禁用这种命名方式：

```js
# ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
```

或者给内核传递启动参数:

```js
net.ifnames=0
```

随便吧。

References:
\[1\][Predictable Network Interface Names](http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/)
\[2\][network interface naming with systemd 197](https://lists.archlinux.org/pipermail/arch-dev-public/2013-January/024231.html)

**\===
\[erq\]**