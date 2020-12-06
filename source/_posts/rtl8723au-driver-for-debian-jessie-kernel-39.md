---
title: RTL8723AU驱动 for Debian Jessie kernel 3.9
tags:
  - Debian
id: '3175'
categories:
  - - GNU/Linux
date: 2013-06-22 18:17:14
---

Debian 当前testing Jessie终于更新到kernel 3.9
<!-- more -->
更新后，yoga 13的触摸屏终于可以驱动了，但是内置wifi模块仍然驱动不起来，因为RTL8723AU的驱动还没有进入主线内核。RealTEK的动作可真够慢的，这本子已经用了马上半年了。

这无线模组的设备ID为0bda:1724
$ lsusb
...
Bus 001 Device 005: ID 0bda:1724 Realtek Semiconductor Corp.
...

幸好[Larry W. Finger](http://www.lwfinger.net)通过与realrek交涉，[拿到了尚未公开的内部驱动](https://lkml.org/lkml/2013/4/1/280)，并在github上将[RTL8723AU的驱动](https://github.com/lwfinger/rtl8723au)公布出来。

Larry W. Finger虽然并没有此硬件设备，但对此驱动十分热心，正在着手将其推到内核主线，这就是开源的魅力。此芯片还有bluetooth功能，不过驱动尚未准备好，Larry W. Finger也打算与realtek共同努力解决对蓝牙的支持。期待下个内核版本rtl8723au的驱动能进入主线。

**驱动安装**

安装内核头文件
# apt-get install build-essential linux-headers-3.9-1-amd64
$ git clone http://github.com/lwfinger/rtl8723au.git

用新内核启动

$ cd ~/rtl8723au
$ make && sudo make install
# modprobe 8723au

# ifconfig
就可以看到wlan设备了，信号还不错哈。
蓝牙还不行。

**UPDATE(1/5/2014):**

偶然看了一眼,没想到编译后的内核模块ko文件这么大,8723au.ko竟然有23M之巨。看来strip一下十分有必要,那么在# make install之前，先执行以下命令剥除ko文件的符号。
# make strip
这样8723.ko文件就只有1.4M大了,对于内核模块来说,这尺寸也不算小了。

**\===
\[erq\]**