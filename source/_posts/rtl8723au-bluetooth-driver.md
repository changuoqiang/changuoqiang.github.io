---
title: RTL8723AU 蓝牙驱动
tags:
  - Debian
id: '6052'
categories:
  - - GNU/Linux
date: 2014-11-15 21:43:19
---


<!-- more -->
原来RTL8723AU芯片上的蓝牙功能驱动也已经有了，还是那个热心的Larry W. Finger搞的，github地址在https://github.com/lwfinger/rtl8723au_bt

安装也很简单：
```js
$ git clone https://github.com/lwfinger/rtl8723au_bt
$ cd rtl8723au_bt
$ make
# make install
# modprobe rtk_btusb
```

然后就可以了

**UPDATE(08/01/2015):**
hci_recv_fragment函数从kernel 3.18起被删除了，当前仓库的master分支尚未修改以支持此状况，但kernel分支已经支持。因此应该切换到kernel分支再行编译安装。
并且，模块的名字变成了btusb, so:
```js
$ git checkout kernel
...
# modprobe btusb
```
就可以了。

 **===
\[erq\]**