---
title: 解决debian amd64 flash播放爆音
tags:
  - Debian
id: '1589'
categories:
  - - GNU/Linux
date: 2011-07-10 11:18:50
---

debian tesing amd64系统，播放flash时总有严重的爆音,使用alsa和pulseaudio都有同样的问题
<!-- more -->
google得知是flash的memcpy实现有bug,导致播放某些flash时出现严重的爆音,adobe是没指望了,可以通过替换so文件来绕过这个bug。

firefox的启动程序是一个脚本,可以which firefox来看下其所在的位置，一般应该在这个位置/usr/bin/firefox，我是自己安装的，其位置在/opt/firefox/firefox。

打开脚本文件firefox，在其第一个非注释行前加入下面这行

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libc/memcpy-preload.so

保存退出，重新启动firefox就可以了