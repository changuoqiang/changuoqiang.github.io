---
title: debian testing amd64安装firefox 5
tags:
  - Debian
  - Firefox
id: '1579'
categories:
  - - GNU/Linux
date: 2011-07-03 23:30:24
---

debian官方是没有firefox的，只有iceweasel,这是因为debian的洁癖,但这也正是debian的独特之处
<!-- more -->
现在firefox玩起了版本号游戏,分发版很难跟上其步伐，特别是像debian这么严谨的分发版,所以要用最近的firefox就只能自己动手，丰衣足食了。

首先下载官方[firefox 5 amd64 build](ftp://ftp.mozilla.org/pub/firefox/releases/5.0/linux-x86_64/en-US/firefox-5.0.tar.bz2)，下载后，执行如下指令

$sudo tar jxvf firefox-5.0.tar.bz2 -C /opt/firefox

这样安装就算完成了,firefox的可执行文件为/opt/firefox/firefox,建立一个快捷方式指向此命令就可以方便的使用firefox 5了。squeeze上也是一样的安装方法。