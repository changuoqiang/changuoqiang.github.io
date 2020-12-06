---
title: Debian关闭AMD显卡KMS设置
tags:
  - Debian
id: '1527'
categories:
  - - GNU/Linux
date: 2011-06-23 16:22:43
---

linux的内核模式设置KMS(Kernel Mode Setting)是一个很好的特性,从系统启动很早的阶段就给用户一个高分辨率的显示环境
<!-- more -->
这对intel的卡子来说很完美,但A卡多少有些杯具,自从xserver-xorg-video-radeon版本1:6.12.192-2开始,linux默认开启了A卡的KMS,在一块radeon hd 6450上安装最新的debian testing,安装完成重新启动后,过了grub就花屏了,无法进入控制台,原因就是AMD开源驱动默认开启了KMS,但对这个卡的支持有问题，所以只有关闭了KMS才能进入控制台。

用rescuecd引导系统进入控制台,然后挂装根分区
#mount -t ext4 /dev/sda1 /mnt
#cd /mnt/etc/modprobe.d/
查看一下是否有radeon-kms.conf这个文件,如果没有就新建该文件,输入一下内容
options radeon modeset=0

重新启动就可以进入console了，不过分辨率真的惨不忍睹,而AMD卡的VESA模式又那么怪异,竟然不支持1920x1080x24这种VESA模式，好吧，反正大部分时间都在X下，但是启动的时候就不那么美观了。

通过grub命令行来关闭KMS貌似行不通，没有测试成功。