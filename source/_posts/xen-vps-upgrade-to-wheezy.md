---
title: xen vps升级到wheezy
tags:
  - Debian
id: '2921'
categories:
  - - GNU/Linux
date: 2013-05-12 00:19:39
---

wheezy近期发布了，将vps从squeeze升级到wheezy
<!-- more -->
**修改源**

/etc/apt/sources.list文件中全部的squeeze更改为wheezy

**更新**
#apt-get update
#apt-get install apt
#apt-get update
#apt-get upgrade

**小麻烦**

mysql-server更新时遇到依赖错误，无法更新，按提示apt-get -f install,仍然无法更新，提示与使用的dotdeb相关包有依赖问题

强制卸载两个dotdeb的mysql-client包
#dpkg -r mysql-client-5.5 mysql-client-core-5.5

重新
#apt-get upgrade

然后
#apt-get dist-upgrade

**升级内核**
#apt-get install linux-image-3.2.0-4-amd64

但是xen的grub配置文件不太一样，而且无法更新到grub2,update-grub不起作用，这个没具体研究，手工修改/boot/grub/menu.lst即可
```js
default=1
timeout=5

title Debian GNU/Linux, kernel 2.6.32-5-xen-amd64
root (hd0)
kernel /boot/vmlinuz-2.6.32-5-xen-amd64 root=/dev/xvda ro 
initrd /boot/initrd.img-2.6.32-5-xen-amd64

title Debian GNU/Linux, kernel 3.2.0-4-amd64
root (hd0)
kernel /boot/vmlinuz-3.2.0-4-amd64 root=/dev/xvda ro 
initrd /boot/initrd.img-3.2.0-4-amd64

title Debian GNU/Linux, kernel 3.2.0-4-amd64 (single-user mode)
root (hd0)
kernel /boot/vmlinuz-3.2.0-4-amd64 root=/dev/xvda ro single
initrd /boot/initrd.img-3.2.0-4-amd64
```

#uname -a
Linux \`hostname\` 3.2.0-4-amd64 #1 SMP Debian 3.2.41-2 x86_64 GNU/Linux

升级完成