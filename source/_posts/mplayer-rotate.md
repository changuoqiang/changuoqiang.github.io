---
title: mplayer播放视频时旋转
tags:
  - MPlayer
id: '2902'
categories:
  - - GNU/Linux
date: 2013-05-06 09:51:11
---

手机拍了些视频，从电脑上用mplayer播放竟然图像不是正的。
<!-- more -->
使用mplayer的-vf选项来旋转或镜像视频，vf即vedio filter,这个选项的子参数rotate用来旋转、镜像视频。使用方法如下：

$mplayer -vf rotate\[=0,1,2,3\] video.xxx

rotate或rotate=0 镜像并顺时针旋转90度
rotate=1 顺时针旋转90度
rotate=2 顺时针旋转270度
rotate=3 镜像并顺时针旋转270度