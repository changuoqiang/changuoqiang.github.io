---
title: Debian lenny backports源
tags:
  - Debian
id: '645'
categories:
  - - GNU/Linux
date: 2009-11-24 20:45:37
---

backport的含义是“向后移植”，就是将软件新版本的某些功能移植到旧版本上来,这种行为就称为backport。

Debian向来以稳定性著称，所以就存在一个问题，官方源分发的软件版本比软件本身的版本总是要慢一拍，所以就有了backports源。backports主要从testing源，部分安全更新从unstable源重新编译包，使这些包不依赖于新版本的库就可以在debian的stable发行版上面运行。所以backports是stable和testing的一个折衷。

backports源的使用方法如下：
在/etc/apt/sources.list增加下面的行
deb http://www.backports.org/debian/ lenny-backports main contrib non-free
deb-src http://www.backports.org/debian/ lenny-backports main contrib non-free
然后安装backports源的GnuPG archive key
sudo apt-get update
sudo apt-get install debian-backports-keyring
就可以正常的使用backports源了。