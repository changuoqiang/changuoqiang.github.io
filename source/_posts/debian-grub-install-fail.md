---
title: debian testing grub-pc安装失败解决方法
tags:
  - Debian
id: '1515'
categories:
  - - GNU/Linux
date: 2011-06-18 14:00:11
---

全新的办公电脑到货了,CPU i3 2100/4G DDR3/1T HDD/AMD Radeon HD 6450 1G/21.5 LED,
<!-- more -->
3年前的老电脑可以退役了,新电脑果断安装Debian,window$就不考虑了。桌面就用testing吧,里面的包还是都够新的。

下载debian testing weekly build iso,刻盘,开始安装，熟悉的安装界面,虽然安装程序提供了btrfs，但还是选择了ext4，这样比较保险一些。根分区/分了10G,使用主分区sda1,然后是/home分区,使用主分区sda2,容量为1T去掉10G根分区和8G交换分区swap剩余的容量,最后是8G的swap，使用主分区sda3。硬件识别顺利,只安装基本系统，安装grub时出现了问题,错误提示如下：
```js
“Grub package failed to install into /target. Without GRUB boot loader, the installed system will not boot”
```
竟然无法安装grub,跳过此步骤继续安装系统。

重新光盘引导进入rescue模式,命令行下输入
```js
$ grub-installer
```
出现错误提示
```js
Wrong number of args: mapdevfs
```

下载了debian testing daily build重新安装，问题依旧。使用前段时间刻录的debian squeeze 6.0.1a安装时竟然识别不出网卡，放弃。最后下载SystemRescueCd 2.2.0,引导系统，挂装硬盘上的根分区sda1,然后chroot安装grub-pc成功，步骤如下：
```js
# ifconfig eth0 192.168.0.8 netmask 255.255.255.0
# route add default gw 192.168.0.1

# mount -t ext4 /dev/sda1 /mnt
# mount --bind /proc /mnt/proc
# mount --bind /dev /mnt/dev
# mount --bind /sys /mnt/sys
# chroot /mnt /bin/bash
# apt-get update
# apt-get install grub-pc
```
chroot后要检查一下/etc/apt/source.list文件,看看安装源是否正确。退出chroot重新启动硬盘引导,出现熟悉的grub引导界面。

chroot 重新绑定虚拟文件系统时，可以这样:
```js
# for i in /dev /dev/pts /proc /sys /run; do mount -B $i /mnt $i; done
```

-B参数就是--bind参数。

**\===
\[erq\]**