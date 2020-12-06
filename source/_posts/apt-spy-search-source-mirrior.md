---
title: 使用apt-spy自动查找最快的镜像源
tags:
  - Debian
id: '1566'
categories:
  - - GNU/Linux
date: 2011-06-30 12:53:55
---

debian testing更新这么频繁,找个速度快的源是很有必要的，不然能郁闷死
<!-- more -->
apt-spy通过测试带宽来自动寻找速度最快的源，并自动添加list文件,是一个很不错的工具

**安装**

$sudo apt-get install apt-spy

**使用**

apt-spy的参数很多，具体看man，这里只介绍最常用的参数
-d distrabution 指定为那个分发版查找源,最直观的就是stable,testing和unstable，也可以指定具体的分发版名称，比如当前的squeezy
-a area 只测试指定区域area的镜像源列表，有效的值有Africa, Asia, Europe, North-America, Oceania和South-America.

通过一下命令来测试更新源,其他参数默认

$sudo apt-spy -d testing -a asia

apt-spy会测试区域内的源镜像,并将最快的源添加到/etc/apt/sources.lisd.d/apt-spy.list文件中,默认没有打开contrib和non-free。注释掉/etc/apt/sources.list中的源就可以开始使用新的镜像源了。

台湾的源ftp.tw.debian.org真的挺快,最快上到1MB/s了,比官方源快了好几倍。这是移动的线路,从联通线路访问就慢多了。