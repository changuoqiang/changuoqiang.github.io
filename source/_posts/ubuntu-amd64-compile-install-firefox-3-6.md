---
title: ubuntu 9.10(kamic koala) amd64编译安装firefox 3.6(namoroka)
tags:
  - Firefox
  - Ubuntu
id: '751'
categories:
  - - GNU/Linux
date: 2010-01-24 18:55:11
---

代号为"namoroka"的firefox 3.6正式发布了，性能提升不少。ubuntu估计要到下一个版本10.04(Lucid Lynx)才会更新到firefox 3.6，但愿不要这么晚。mozilla官方不提供amd64版本的安装包，那么下载源代码本地编译吧，这样性能还能更优。编译安装步骤如下，参考了官方[build文档](https://developer.mozilla.org/En/Developer_Guide/Build_Instructions)。
　　
　　0. 准备编译环境和依赖
　　sudo apt-get build-dep firefox
　　sudo apt-get install libasound2-dev libcurl4-openssl-dev libnotify-dev libxt-dev libiw-dev mesa-common-dev autoconf2.13
<!-- more -->
1\. 下载源代码
　　从官方下载3.6的[源代码](http://releases.mozilla.org/pub/mozilla.org/firefox/releases/3.6/source/)firefox-3.6.source.tar.bz2,然后tar jxf firefox-3.6.source.tar.bz2解压源代码到某个位置，得到的源代码根目录名字为mozilla-1.9.2，因为gecko的版本是1.9.2。

　　2. 准备编译配置文件
　　在源代码根目录mozilla-1.9.2下新建一个文件.mozconfig，输入以下内容：
　　# my mozilla firefox config
　　mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/obj-@CONFIG_GUESS@

　　ac_add_options - -enable-application=browser
　　mk_add_options MOZ_CO_PROJECT=browser

　　ac_add_options - -enable-optimize
　　ac_add_options - -disable-tests

　　3. 编译并制作安装包
　　在源代码根目录mozilla-1.9.2下运行命令make -f client.mk build开始编译，编译完成后切换到obj目录，我的机器上生成的目录名字为obj-x86_64-unknown-linux-gnu，进入该目录并执行make package，会在当前目录的子目录dist里面生成最终的安装包，名字为firefox-3.6.en-US.linux-x86_64.tar.bz2。

　　4. 安装
　　执行命令sudo tar jxf firefox-3.6.en-US.linux-x86_64.tar.bz2 -C /opt，把firefox安装到/opt目录下，然后sudo ln -sf /opt/firefox/firefox /usr/bin/firefox更新符号连接。

　　编译安装完毕。