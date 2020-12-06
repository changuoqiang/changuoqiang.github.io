---
title: debian从BIOS启动切换到UEFI启动
tags:
  - Debian
id: '6681'
categories:
  - - GNU/Linux
date: 2015-10-07 22:18:11
---


<!-- more -->
系统重装了一次，本来Debian installer已经支持UEFI安装了，但是可能是这台机器兼容性的问题，UEFI安装时，字符和图形安装界面都是花屏，根本无法安装。只好设置成legacy模式(BIOS兼容方式)来安装。

安装完后,Debian是使用GRUB-PC来启动的，也就是legacy模式启动的。注意，legacy模式的GRUB是无法引导UEFI启动方式的其他系统的。

当然也可以切换到UEFI启动方式，其原理就是临时以UEFI方式引导Debian,然后安装配置grub-efi,因为只有UEFI方式启动的系统才能更改系统固件(NVRAM)中的UEFI Boot Manager配置。

可以使用live CD/USB来引导系统访问当前的Debian,此时需要chroot来安装配置grub-efi。另一种方法为使用rEFInd来直接引导当前的Debian系统，此时无需chroot。

下面是使用rEFInd引导管理器的操作步骤:

*   rEFInd USB启动盘制作

去[Getting rEFInd](http://www.rodsbooks.com/refind/getting.html)页面下载A USB flash drive image file,将下载的zip文件解压后，进入refind-flashdrive-x.x.x文件夹，将img文件写入usb盘
```js
# dd if=refind-flashdrive-x.x.x.img of=/dev/sdb
```
注意自己usb闪存的设备名
*   挂载ESP分区

使用rEFInd引导usb盘以UEFI方式引导系统，进入rEFInd界面，选择引导硬盘上的Debian系统。
然后，将GPT硬盘上的ESP分区,也就是EFI System Partition挂载到/boot/efi目录下
```js
# mount /dev/sda2 /boot/efi
```
*   安装grub-efi
```js
# apt-get install --reinstall grub-efi
# grub-install /dev/sda
```

grub-install最后会向UEFI Boot Manager写入启动项,而只有UEFI方式启动的系统才能更改系统固件(NVRAM)中的UEFI Boot Manager。

不过，参考\[2\]介绍了一个trick,legacy启动方式下，将grub的镜像拷贝一份为efi/boot/bootx64.efi，这路径是相对于ESP分区的根。
```js
# cp /boot/efi/efi/debian/grubx64.efi /boot/efi/efi/boot/bootx64.efi
```
然后重新启动系统会自动以UEFI方式引导Debian系统，然后重新执行grub-insall就可以了。

为什么这样可以呢？据说是因为UEFI Boot Manager如果没有配置指定的efi镜像，会自动寻找efi/boot/bootx64.efi来引导。没有实验到底是否可行，如果本来就存在多系统，这trick也就不太好用了。

*   重新生成grub配置
```js
# update-grub
```
*   确认安装

```js
# file /boot/efi/EFI/debian/grubx64.efi 
/boot/efi/EFI/debian/grubx64.efi: PE32+ executable (EFI application) x86-64 (stripped to external PDB), for MS Windows
```
bootloader已正确安装

```js
# efibootmgr --verbose grep debian
Boot0003* debian HD(2,GPT,80d7a129-458e-4395-a20d-edd18f128d19,0x1f4800,0x82000)/File(\\EFI\\debian\\grubx64.efi)
```
系统UEFI boot manager固件(NVRAM)中debian引导项已正确创建

去掉rEFInd启动盘，重新启动系统，UEFI中设置debian优先启动即可。

References:
\[1\][GrubEFIReinstall](https://wiki.debian.org/GrubEFIReinstall)
\[2\][Debian: switch to UEFI boot](http://tanguy.ortolo.eu/blog/article51/debian-efi)
\[3\]

**\==
\[erq\]**