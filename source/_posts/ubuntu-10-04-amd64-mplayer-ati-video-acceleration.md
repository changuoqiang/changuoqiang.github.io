---
title: Ubuntu 10.04 AMD64 mplayer 开启ATI卡硬解加速
tags:
  - MPlayer
  - Ubuntu
id: '806'
categories:
  - - GNU/Linux
date: 2010-05-08 09:32:26
---

昨晚在Ubuntu 10.04(Lucid Lynx) AMD64上面设置ATI Mobile Readon 3470硬解加速成功,mplayer播放高清视频时CPU占有率大大降低，大约只有原来的1/10。使用Ubuntu 9.10时也曾经试图硬解，但没成功。具体设置/安装方法记叙如下。

首先A卡要支持UVD(Unified Video Decoder)，比较新的显卡应该都是支持到UVD2的，另外Lucid自带的ATI驱动在我的机器上不支持UVD功能。
cat /var/log/Xorg.0.log grep UVD
如果输出如下字样
(II) fglrx(0): UVD2 feature is available
则表明支持驱动UVD特性
我的卡子在未安装ATI官方最新驱动ATI Catalyst Display Driver 10.4以前是不支持UVD2的。ATI驱动如何安装请参考ATI官方文档。
<!-- more -->
A卡现在在linux平台上能够进行硬解得益于intel与开源社区开发的vaapi(Video Acceleration API)，只要安装相应的后端驱动，vaapi可以支持A卡和N卡，A卡的后端就是xvba-video,N卡的后端是vdpau-video.

安装完ATI最新的官方驱动后，下载相应平台的[libva](http://www.splitted-desktop.com/~gbeauchesne/libva/)包安装，当然也可以下载源码进行安装，http://www.splitted-desktop.com/~gbeauchesne/上有详细的说明。还要把libva的开发包一并安装，因为后面编译带vaavpi扩展的mplayer要用到。我安装的是最新的libva1_0.31.0-1+sds13_amd64.deb和libva-dev_0.31.0-1+sds13_amd64.deb

然后下载并安装[xvba-video](http://www.splitted-desktop.com/~gbeauchesne/xvba-video/)。安装完成后测试一下vaapi是否就绪
$ vainfo
我的输出如下
libva: libva version 0.31.0-sds6
Xlib: extension "XFree86-DRI" missing on display ":0.0".
libva: va_getDriverName() returns 0
libva: Trying to open /usr/lib/va/drivers/fglrx_drv_video.so
libva: va_openDriver() returns 0
vainfo: VA API version: 0.31
vainfo: Driver version: Splitted-Desktop Systems XvBA backend for VA API - 0.6.11
vainfo: Supported profile and entrypoints
 **VAProfileMPEG2Simple : VAEntrypointIDCT
 VAProfileMPEG2Main : VAEntrypointIDCT
 VAProfileH264High : VAEntrypointVLD
 VAProfileVC1Advanced : VAEntrypointVLD**
最重要的是后面输出的profile，如果有内容输出应该问题就不大了。

最后就是让mplayer来支持vaapi了，发行版自带的版本目前是不支持此特性的，所以要重新编译。先执行
$sudo apt-get build-dep mplayer
然后下载[mplayer-vaapi-latest-FULL.tar.bz2](http://www.splitted-desktop.com/~gbeauchesne/mplayer-vaapi/) ,解开后执行$ ./checkout-patch-build.sh即可。
编译完成后生成的mplayer在mplayer-vaapi目录下面。

$./mplayer -vo vaapi -va vaapi path_to_movie
如果有以下字样输出
VO: \[vaapi\] 1280x720 => 1280x720 H.264 **VA API Acceleration**
则说明硬件加速成功。
enjoy it!