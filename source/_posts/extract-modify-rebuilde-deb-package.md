---
title: 提取、修改、重建deb包
tags:
  - Debian
id: '945'
categories:
  - - GNU/Linux
date: 2010-10-11 20:34:38
---

以下皆以fglrx驱动deb包为例,fglrx文件夹用来存放解包后的所有文件,fglrx_8.753-0ubuntu1_amd64.deb为需要修改的deb包
<!-- more -->
创建fglrx文件夹
$ mkdir fglrx

解包deb
$dkpg-deb -x fglrx_8.753-0ubuntu1_amd64.deb fglrx

提取deb包控制信息
$dpkg-deb -e fglrx_8.753-0ubuntu1_amd64.deb fglrx/DEBIAN

修改fglrx目录下的相关文件后就可以重新打包为deb,名字随便,此处为new_fglrx.deb
$dpkg-deb -b fglrx new_fglrx.deb