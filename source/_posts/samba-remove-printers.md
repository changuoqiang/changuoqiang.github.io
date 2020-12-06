---
title: debian samba去掉默认打印机共享
tags:
  - Debian
id: '2459'
categories:
  - - GNU/Linux
date: 2012-09-11 09:29:38
---

samba默认配置即使没有使用打印机共享,客户端也会看到"打印机和传真"图标
<!-- more -->
很简单的就可以去掉它,在/etc/smaba/smd.conf的\[global\]加入如下语句即可:

disable spoolss = yes

这样客户端就不会看到打印机共享了