---
title: 通过串行控制台访问kvm客户机
tags: []
id: '7216'
categories:
  - - GNU/Linux
date: 2016-04-25 11:20:37
---


<!-- more -->
当ssh,vnc都不能访问客户机时,serial console可以提供另一种访问客户机的途径。

**客户机serial console配置**

/etc/inittab文件打开或添加如下行:

```js
T0:23:respawn:/sbin/getty -L ttyS0 38400 vt100
```

/etc/securetty文件中确保列出了ttyS0:
```js
ttyS0
```

/etc/default/grub文件添加:
```js
GRUB_CMDLINE_LINUX='console=tty0 console=ttyS0,38400n8'
GRUB_TERMINAL=serial
GRUB_SERIAL_COMMAND="serial --speed=38400 --unit=0 --word=8 --parity=no --stop=1"
```

波特率是38400，没有奇偶校验，停止位是1

使用virsh来连接客户机串行控制台比较简单，应该也可以重定向客户机的串行端口到主机。

References:
\[1\][Debian Linux: Set a Serial Console](http://www.cyberciti.biz/faq/howto-setup-serial-console-on-debian-linux/)
\[2\][Working with the serial console](https://wiki.archlinux.org/index.php/working_with_the_serial_console)
\[3\][qemu(-kvm) monitor and serial console over sockets with minicom](https://blackdot.be/2013/07/qemu-kvm-monitor-and-serial-console-over-sockets-with-minicom/)

**\===
\[erq\]**