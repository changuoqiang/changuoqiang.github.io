---
title: 'multipath: error getting device'
tags:
  - Debian
id: '6820'
categories:
  - - GNU/Linux
date: 2015-11-03 13:56:12
---


<!-- more -->
dmesg有如下类似错误提示：
```js
kernel: device-mapper: table: 253:3: multipath: error getting device
kernel: device-mapper: ioctl: error adding target to table
kernel: device-mapper: table: 253:3: multipath: error getting device
kernel: device-mapper: ioctl: error adding target to table
```

极有可能是因为multipathd试图在一个已经打开的设备上创建多路径设备，通常是因为这些设备并不是多路径设备，应该在配置文件中屏蔽掉而没有屏蔽的原因。

Are most likely due to multipathd attempting to create a multipath device on top of an already opened device. This is usually because there are device that should be blacklisted which are not.

References:
\[1\][multipath: error getting device](https://bugzilla.redhat.com/show_bug.cgi?id=675366)

**\===
\[erq\]**