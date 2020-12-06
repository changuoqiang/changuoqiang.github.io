---
title: 'ip_local_port_range: prefer different parity for start/end values'
tags:
  - Debian
id: '8850'
categories:
  - - GNU/Linux
date: 2019-10-15 13:46:44
---


<!-- more -->
dmesg有提示：
```js
ip_local_port_range: prefer different parity for start/end values
```

查询本地端口范围
```js
$ cat /proc/sys/net/ipv4/ip_local_port_range
1024 65000
```
起始与结束端口都是偶数,打开/etc/sysctl.conf添加:
```js
net.ipv4.ip_local_port_range = 1024 65535
```
开始端口与结束端口奇偶不同就可以了。