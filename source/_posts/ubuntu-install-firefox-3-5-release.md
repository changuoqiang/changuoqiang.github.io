---
title: Ubuntu 9.04下安装Firefox 3.5正式版(Release)
tags:
  - Firefox
  - Ubuntu
id: '395'
categories:
  - - GNU/Linux
date: 2009-07-15 23:02:06
---

让我们翘首企盼的firefox 3.5正式版(Release)于6月30日正式推出，但是Ubuntu社区却迟迟没有更新，至今已经有半月，官方源仍然毫无动静，难道是因为bug太多，要等到firefox 3.5.1再进行更新？不得而知了。

看来暂时只有自己动手，丰衣足食了。对于firefox的安装我不推荐使用非官方源，而是从[Mozilla](http://www.mozilla.com/en-US/firefox/all.html)下载更新，3.5与以前的版本并存，这样当Ubuntu官方源更新的时候，可以顺利的更新到最新的官方firefox版本。

firefox 3.5的安装比较简单，从[mozilla](http://www.mozilla.com/en-US/firefox/all.html)下载回来的文件名字为firefox-3.5.tar.bz2，遵循FHS(Filesystem Hierarchy Standard)的指导意见，firefox最好安装到/opt目录下面，用下面的命令直接把bz2包解压到/opt目录下就可以了。
tar jxvf firefox-3.5.tar.bz2 -C /opt
这样就算安装完成了，命令行运行/opt/firefox/firefox或者建一个桌面快捷方式都可以，记得一定要运行/opt/firefox目录下的firefox,而不是firefox-bin或run-mozilla.sh。
这样两个版本的firefox使用同一套profile，可以和平共处，至于暂时不兼容的插件(Extensions)hack一下吧。