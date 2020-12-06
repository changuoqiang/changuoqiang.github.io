---
title: ubuntu 9.10禁止记录最近使用文档(disable recent documents)
tags:
  - Ubuntu
id: '759'
categories:
  - - GNU/Linux
date: 2010-01-28 22:55:45
---

在ubuntu 9.10下修改~/.recently-used和~/..recently-used.xbel文件的属性已经无法阻止gnome记录最近使用文档.正确的做法是在主目录建立.gtk-2.0文件
 touch ~/.gtk-2.0
然后输入
 gtk-recent-files-max-age=0
如果想限制记录最经文档的书录输入
 gtk-recent-files-limit=3 #比如只记录3个