---
title: 无GUI安装Virtualbox Guest Additions
tags:
  - Debian
id: '8302'
categories:
  - - GNU/Linux
date: 2019-06-02 09:53:26
---


<!-- more -->
没有GUI的debian buster安装virtualbox guest additions

主机端：

启动客户机，点击菜单Devices->Insert Guest Additons Image...

客户机端：

安装内核模块build依赖:
```js
$ apt-get install -y dkms build-essential linux-headers-$(uname -r)
```

挂载cdrom，安装客户附加组件
```js
$ sudo mount /dev/cdrom /media/cdrom
$ cd /media/cdrom
$ sudo su
# ./VBoxLinuxAdditions.run 
Verifying archive integrity... All good.
Uncompressing VirtualBox 6.0.8 Guest Additions for Linux........
VirtualBox Guest Additions installer
Removing installed version 6.0.8 of VirtualBox Guest Additions...
Copying additional installer modules ...
Installing additional modules ...
VirtualBox Guest Additions: Starting.
VirtualBox Guest Additions: Building the VirtualBox Guest Additions kernel 
modules. This may take a while.
VirtualBox Guest Additions: To build modules for other installed kernels, run
VirtualBox Guest Additions: /sbin/rcvboxadd quicksetup <version>
VirtualBox Guest Additions: or
VirtualBox Guest Additions: /sbin/rcvboxadd quicksetup all
VirtualBox Guest Additions: Building the modules for kernel 4.19.0-5-amd64.
update-initramfs: Generating /boot/initrd.img-4.19.0-5-amd64
VirtualBox Guest Additions: Running kernel modules will not be replaced until 
the system is restarted
```

reboot客户机
```js
# reboot
```

校验安装:
```js
$ lsmod grep vboxguest
vboxguest 348160 2 vboxsf
```

安装成功



References:
\[1\][How to install VirtualBox Guest Additions on a GUI-less Ubuntu server host](https://www.techrepublic.com/article/how-to-install-virtualbox-guest-additions-on-a-gui-less-ubuntu-server-host/)