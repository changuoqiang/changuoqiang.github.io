---
title: Mac OS X lsusb命令
tags:
  - mac
id: '6013'
categories:
  - - Misc
date: 2014-10-31 09:10:04
---


<!-- more -->
mac os x上没有lsusb命令,可以使用如下命令列出系统usb设备信息:
```js
$ system_profiler SPUSBDataType
USB:

 USB 3.0 SuperSpeed Bus:

 Host Controller Location: Built-in USB
 Host Controller Driver: AppleUSBXHCI
 PCI Device ID: 0x9c31 
 PCI Revision ID: 0x0004 
 PCI Vendor ID: 0x8086 
 Bus Number: 0x0a 

 USB 3.0 Hi-Speed Bus:

 Host Controller Location: Built-in USB
 Host Controller Driver: AppleUSBXHCI
 PCI Device ID: 0x9c31 
 PCI Revision ID: 0x0004 
 PCI Vendor ID: 0x8086 
 Bus Number: 0x0a 

 BRCM20702 Hub:

 Product ID: 0x4500
 Vendor ID: 0x0a5c (Broadcom Corp.)
 Version: 1.00
 Speed: Up to 12 Mb/sec
 Manufacturer: Apple Inc.
 Location ID: 0x14300000 / 1
 Current Available (mA): 500
 Current Required (mA): 94
 Built-In: Yes

 Bluetooth USB Host Controller:

 Product ID: 0x828f
 Vendor ID: 0x05ac (Apple Inc.)
 Version: 0.99
 Speed: Up to 12 Mb/sec
 Manufacturer: Apple Inc.
 Location ID: 0x14330000 / 4
 Current Available (mA): 500
 Current Required (mA): 0
 Built-In: Yes

```

也可以用brew安装第三方lsusb命令:
```js
$ brew update
$ brew tap jlhonora/lsusb
$ brew install lsusb
$ lsusb
Bus 020 Device 001: ID 0a5c:4500 Broadcom Corp. BRCM20702 Hub 
Bus 020 Device 004: ID 05ac:828f Apple Inc. Bluetooth USB Host Controller 
Bus 010 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub 
Bus 010 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub 
```

References:
\[1\][lsusb command for Mac OS X](https://github.com/jlhonora/lsusb)

**\===
\[erq\]**