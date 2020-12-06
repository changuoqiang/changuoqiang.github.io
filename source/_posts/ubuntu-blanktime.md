---
title: Ubuntu播放视频定期黑屏问题
tags:
  - Ubuntu
id: '762'
categories:
  - - GNU/Linux
date: 2010-02-05 22:48:29
---

使用mplayer播放视频的时候,如果没有鼠标或键盘活动,大约10分钟后显示器会自动关闭,要动下鼠标才能继续观看,比较烦.我是没有设置屏保的,因为包gnome-screensaver已经卸载掉了.而且power manager里面已经把所有的电源选项都关闭了.竟然还会定期自动关闭LCD,真败了，无法容忍.

其实"罪魁祸首"就是X server,在/etc/X11/xorg.conf的ServerFlags节增加一下选项就可以了.
Section "ServerFlags"
 Option "BlankTime" "0"
 Option "StandbyTime" "0" 
 Option "SuspendTime" "0"
 Option "OffTime" "0"
EndSection

该问题是由Blanktime控制的,这个值控制多长时间没有动作来启动屏保,默认时间是10分钟,设置为0就可以关闭该特性了.

其他三个选项依次是DPMS的待机、挂起、关闭超时值，也可以通过Monitor节的DPMS选项来关闭这三个特性

Section "Monitor"
Option "DPMS" "false"
EndSection

注意，BlankTime特性是不受DPMS特性控制的。

这四个参数的详细信息参见[xorg配置文件手册](http://www.x.org/archive/X11R6.8.0/doc/xorg.conf.5.html)。