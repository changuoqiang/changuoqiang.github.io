---
title: debian jessie服务器安装时console-setup配置停滞
tags:
  - Debian
id: '6056'
categories:
  - - GNU/Linux
date: 2014-11-18 10:38:29
---


<!-- more -->
最近使用带有[firmware](http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/weekly-builds/amd64/iso-cd/)的debian netinst安装一台服务器时,安装进度到99%配置console-setup时进程停滞了，没有当机，只是进度不动，几个小时都不带动的，一直在：
```js
configuring console-setup...
```

CTRL+ALT+4查看安装日志，也没有错误提示，只是在等待。
重启进入rescue安装模式，在instaler环境下执行
```js
# dpkg --configure -a
```
console-setup配置界面选择# american,安装时就是因为这里自动配置没过去，从而无限停滞了。

之后执行
```js
# grub-installer
```
出现类似如下错误：
```js
Media change: please insert the disc labeled
 'Debian GNU/Linux ... Official amd64 CD Binary-1 ...'
in the drive '/media/cdrom/' and press enter
```
无果。

其实大部分包已经装完了，只是还没有安装grub，配置root用户和添加新用户而已。
所以使用[rescuecd引导系统安装grub](https://openwares.net/linux/debian_grub_install_fail.html)
这时候root是没密码的，无法正常登录，grub引导时选择recovery模式，顺利以root登录系统，然后执行passwd命令为root设置密码，之后再添加普通用户即可。