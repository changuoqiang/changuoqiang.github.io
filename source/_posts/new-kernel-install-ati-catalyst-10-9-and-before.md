---
title: 在新内核上安装ATI Catalyst 10.9及之前版本的驱动
tags:
  - Ubuntu
id: '949'
categories:
  - - GNU/Linux
date: 2010-10-12 20:03:41
---

因为安全以及GPL相关事宜,linux内核调整了compat_alloc_user_space()函数,将其从asm/compat.h文件移动到linux/compat.h,并将该函数提升为EXPORT_SYMBOL_GPL导出的符号。
<!-- more -->
这就打破了ATI的专有fglrx驱动,因为闭源ATI驱动需要compat_alloc_user_space()函数, 并且希望从asm/compat.h里找到该函数。

在此更新之后的内核包括Ubuntu 10.10(Maverick MeerKat)上安装fglrx驱动时会出现错误,大体有以下字样,"kcl_ioctl.c:196 : error: implicit declaration of function ‘compat_alloc_user_space’",就是因为这个问题。在ATI修复此问题之前可以通过一下方式来安装fglrx驱动。

下载ati fglrx驱动并生成相应的ubuntu安装包
$ sh ./ati-driver-installer-10-7-x86.x86_64.run --buildpkg Ubuntu/lucid

根据[修改deb](https://openwares.net/linux/extract_modify_rebuilde_deb_package.html)这篇文章的提示将生成的deb解开，包括数据和控制文件。修改fglrx/usr/src/fglrx-8.75/kcl_ioctl.c第196行的compat_alloc_user_space为arch_compat_alloc_user_space，重新打包deb，然后$sudo dpkg -i fglrx_new.deb即可.