---
title: linux查看设备usb版本号
tags:
  - Debian
id: '6011'
categories:
  - - GNU/Linux
date: 2014-10-31 08:47:59
---


<!-- more -->
usb规范目前有3个主要的版本,1.0,1.1,2.0,3.0和3.1,在linux系统下可以这样查看设备的usb版本:

```js
$ lsusb -s 001:004 -v grep bcdUSB
bcdUSB 2.00
```

lsusb的-s选项指定总线编号和设备在总线上的编号,可以事先用lsusb得到这些编号

bcdUSB域包含该描述符遵循的USB规范的版本号（以BCD编码）。现在，设备可以使用值0x0100或0x0110来指出它所遵循的是1.0版本还是1.1版本的USB规范。

版本对应:
```js
bcdUSB 1.00 // usb version 1.0
bcdUSB 1.10 // usb version 1.1
bcdUSB 2.00 // usb version 2.0
bcdUSB 3.00 // usb version 3.0
bcdUSB 3.10 // usb version 3.1
```

**\===
\[erq\]**