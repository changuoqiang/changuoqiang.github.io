---
title: windows平台用VIM浏览编辑jar文件
tags:
  - Vim
id: '1208'
categories:
  - - Vim
date: 2011-03-17 12:56:05
---

windows系统下面用Vim编辑Echofon.jar时，VIM提示错误“***error*** (zip#Browse) unzip not available on your system”，
<!-- more -->
这是因为没有找到unzip程序导致zip.vim报告的错误，zip.vim是用来支持vim浏览、处理zip格式文件的，而jar正是使用zip格式打包的。

去[info-zip](http://www.info-zip.org)网站下载windows 32位版本的[unzip](ftp://ftp.info-zip.org/pub/infozip/win32/unz600xn.exe),这是自解压文件，解压后将unzip.exe放入$PATH路径中,重新用Vim打开jar文件就没问题了。

但是如果编辑了jar里面的文件后要保存的话，vim又会提示“***error*** (zip#Write) sorry,your system doesn't appear to have the zip pgm”，这是因为zip.vim没有找到zip程序，还是从info-zip下载[zip](ftp://ftp.info-zip.org/pub/infozip/win32/zip300xn.zip),解压缩后将zip.exe放入$PATH路径中，vim保存jar内修改的文件就没问题了。