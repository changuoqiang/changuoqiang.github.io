---
title: 禁止nautilus为自动挂装设备自动弹出窗口
tags:
  - Debian
id: '2773'
categories:
  - - GNU/Linux
date: 2013-01-18 19:26:57
---

每当插入移动存储设备,nautilus会自动挂装并自动弹出窗体提示浏览设备或者弹出设备
<!-- more -->
可以禁止自动挂装或者禁止自动挂装后自动弹出窗口

打开
#dconf-editor

如下两项
org.gnome.desktop.media-handling.automount 
org.gnome.desktop.media-handling.automount-open

分别控制自动挂装和自动挂装后自动弹出窗口，做相应选择即可。

或者使用命令行
$ gsettings set org.gnome.desktop.media-handling automount false
$ gsettings set org.gnome.desktop.media-handling automount-open false