---
title: qemu 3 '-usbdevice' is deprecated
tags:
  - de
id: '8389'
categories:
  - - GNU/Linux
date: 2019-06-15 15:21:25
---


<!-- more -->
qemu 3.1 提示 
```js
'-usbdevice' is deprecated, please use '-device usb-...' instead
```

使用主机usb设备可以这样写:
```js
-machine usb=on
-device usb-host,hostbus=2,hostaddr=4
```

一定不要忘了添加 `-machine usb=on`，不然
```js
No 'usb-bus' bus found for device 'usb-host'
```