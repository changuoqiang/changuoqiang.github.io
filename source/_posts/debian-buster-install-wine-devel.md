---
title: debian buster安装wine-devel
tags:
  - Debian
id: '8528'
categories:
  - - GNU/Linux
date: 2019-07-15 12:12:13
---


<!-- more -->
wine是个伟大的工程。

wine有三个分支wine-stable,wine-devel和wine-staging，就好像debian的三个分支stable,testing和sid，devel分支其实很稳定的，也能支持更多的应用程序

但是debian buster上安装wine-devel出现依赖问题：
```js
wine-devel : Depends: wine-devel-amd64 (= 4.12.1~buster) but it is not going to be installed
 Depends: wine-devel-i386 (= 4.12.1~buster)
wine-devel-amd64 : Depends: libfaudio0 but it is not installable
```
从wine4.5开始，wine-devel依赖libfaudio0,但是debian官方源并没有提供这个包，因此可以从参考\[2\]给出的链接下载amd64和i386两个架构的安装包libfaudio0_19.07-0_buster_amd64.deb和libfaudio0_19.07-0_buster_i386.deb
并手工安装
```js
$ sudo dpkg -i libfaudio0_19.07-0_buster_amd64.deb
$ sudo dpkg -i libfaudio0_19.07-0_buster_i386.deb
```

然后再安装wine-devel
```js
$ sudo apt -y install wine-devel
```

注意wine-devel安装到/opt/wine-devel目录，因此要使用wine-devel需要在.bashrc中添加
```js
export PATH=/opt/wine-devel/bin:$PATH
```

References:
\[1\][Installing WineHQ packages](https://wiki.winehq.org/Debian)
\[2\][FAudio for Debian and Ubuntu](https://forum.winehq.org/viewtopic.php?f=8&t=32192)