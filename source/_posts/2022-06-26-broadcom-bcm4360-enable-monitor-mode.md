---
title: broadcom bcm4360 enable monitor mode
date: 2022-06-26 18:12:11
tags:
---

2013年的 mba 11'，无线网卡为broadcom bcm4360 (PCI ID 14e4:43a0) rev 3，使用wl(aka broadcom-sta)专有驱动

<!--more-->

其开启monitor模式的方法与其他无线网卡不太一样。

```# echo 1 > /proc/brcm_monitor0```

或者

```$ sudo sh -c "echo 1 > /proc/brcm_monitor0"```

然后会出现一个新的接口prism0,就类似其他无线网卡的mon0或wlan0mon

prism0的命名貌似是promiscuous mode 0的缩写，但promiscuous node混杂模式是有线交换设备的概念，在无线设备中叫monitor模式，无需连接到任何ap,就可以获取空口的数据包。

如果使用airmod-ng,应该直接使用prism0接口

```bash
# airmod-ng check kill
# airmod-ng start prism0
# airodump-ng prism0
```

References:

[1][Enables monitor mode for wl driver(Broadcom)](https://gist.github.com/mkaminsky11/eaf2d643917b22edb510)

[2][Using Monitor Mode in Kali Linux](https://linuxhint.com/monitor_mode_kali_linux/)