---
title: Ubuntu 10.10 maverick AMD64安装firefox 4.0 正式版
tags:
  - Firefox
id: '1246'
categories:
  - - Firefox
date: 2011-03-30 22:18:15
---

Firefox 4正式发布一周了,貌似有些童鞋还是不会在Ubuntu上面安装,简单说一下
<!-- more -->
现在mozilla已经开始官方制作AMD64平台的二进制包了,也就是说不用再为ubuntu AMD64下载源代码编译再安装了，直接下载build好的二进制包就好了,我用的[en_US版本](ftp://ftp.mozilla.org/pub/firefox/releases/4.0/linux-x86_64/en-US/firefox-4.0.tar.bz2),其他平台、语言版本请自行去mozilla ftp查找下载。

下载后,执行命令

1 $sudo tar jxvf firefox\-4.0.tar.bz2 \-C /opt/firefox  
2 $/opt/firefox/firefox  

就可以运行firefox 4了,很简单吧！还是使用~/.mozilla/firefox下的profile文件夹。

enjoy it!