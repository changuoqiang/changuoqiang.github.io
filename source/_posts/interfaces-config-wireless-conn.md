---
title: interfaces文件配置wireless连接
tags:
  - Debian
id: '7171'
categories:
  - - GNU/Linux
date: 2016-03-30 13:53:30
---


<!-- more -->
**配置文件访问无线网络**

在/etc/network/interfaces文件可以配置要默认访问的无线热点:

动态获取ip:
```js
# wireless
auto wlan0
iface wlan0 inet dhcp
 wpa-ssid ESSID/SSID
 wpa-psk pre-shared-key
```

配置静态ip:

```js
# wireless
auto wlan0
iface wlan0 inet static
 address 192.168.1.110
 netmask 255.255.255.0
 network 192.168.1.0
 broadcast 192.168.1.255
 gateway 192.168.1.1
 wpa-ssid ESSID/SSID
 wpa-psk pre-shared-key
```

重新启动网络服务即可连接到默认的热点。

**命令行手动扫描并连接到热点**

扫描热点：
```js
# iwlist wlan0 scan
# iw dev wlan0 scan
```

连接到热点：
```js
# wpa_supplicant -i wlan0 -c <(wpa_passphrase ESSID pre-shared-key) -B
```

动态获取ip:
```js
# dhclient wlan0
```

设置静态ip:
```js
# ip addr add 192.168.1.110/24 dev wlan0
# ip route add default via 192.168.1.1
```

**\===
\[erq\]**