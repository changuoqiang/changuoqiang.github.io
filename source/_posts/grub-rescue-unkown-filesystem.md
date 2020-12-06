---
title: grub rescue 模式下引导修复
tags:
  - Debian
id: '3413'
categories:
  - - GNU/Linux
date: 2013-10-19 11:58:02
---

grub rescue 引导修复
<!-- more -->
windows 8.1出来了，升级以后重写了主引导记录，把grub给破坏了。而且开机都进不了BIOS,只能通过windows 8.1的高级启动重新引导才进入BIOS，重新设置Debian EFI引导记录为第一启动顺序。启动时提示：

error:unknown filesystem 
grub rescue>

所以需要从rescue模式下引导debian,修复grub。rescue模式下只有很少的命令可用。

ls列出硬盘上所有分区
grub rescue> ls
(hd0) (hd0, gpt8) (hd0, gpt7) (hd0, gpt6) (hd0,gpt5) (hd0,gpt4) (hd0, gpt3) (hd0,gpt2) (hd0,gpt1)

找到grub所在分区
grub rescue> ls (hd0, gpt7)/boot/grub

确认grub安装在(hd0,gpt7)分区，然后

grub rescue> set root = (hd0, gpt7) 
grub rescue> set prefix = (hd0, gpt7)/boot/grub
grub rescue> insmod normal.mod

最后输入normal命令进入正常的引导菜单

grub rescue> normal

然后引导进入Debian系统，重新安装grub到硬盘主引导记录

# grub-install /dev/sda

BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0002,2001,2002,2003
Boot0002* Windows Boot Manager
Boot2001* EFI USB Device
Boot2002* EFI DVD/CDROM
Boot2003* EFI Network
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0000,0002,2001,2002,2003
Boot0002* Windows Boot Manager
Boot2001* EFI USB Device
Boot2002* EFI DVD/CDROM
Boot2003* EFI Network
Boot0000* debian
Installation finished. No error reported.

重新启动就可以了