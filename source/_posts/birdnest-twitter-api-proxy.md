---
title: 不基于GAE构建birdnest twitter api proxy
tags:
  - Twitter
id: '859'
categories:
  - - Misc
date: 2010-07-29 13:25:25
---

其实只要空间支持python都可以[使用birdnest搭建twitter api proxy](http://yegle.net/2009/07/29/setup-a-birdnest-twitter-api-proxy-on-your-own-host/)。

曾经尝试用twip来搭建，但是因为主机用的是nginx，尝试N久未成功，遂放弃改用birdnest，原来是如此简单，记叙如下：

1.安装python及支持模块。我的VPS已经自带了python。下载[simplejson](http://pypi.python.org/pypi/simplejson/),解压后进去目录执行python setup.py build和sudo python setup.py install即可

2.下载birdnest。在某个目录下执行

svn checkout http://birdnest.googlecode.com/svn/branches/stable birdnest-read-only

或者如果你用git的话

git-svn clone http://birdnest.googlecode.com/svn/branches/stable birdnest-read-only

3\. 进入birnest目录执行

python code.py 空间ip:随便指定的port

测试一下如果正常，则可以在/etc/init.d下面加入脚本birdnest，并在/etc/rc3.d/目录下建立其目录链接,注意你自己的运行级，让其开机自动运行，脚本内容如下

#!/bin/sh

cd /你的birdnest路径

python code.py 空间ip:指定的port > /dev/null 2>&1 &

4.在twitter客户端设置api地址为http://空间ip:指定的port/api即可.birdnest提供了4种api，/api、/optimized、/image、/text，具体介绍请翻墙去[官网](http://nest.onedd.net/)。我只用了/api，看起来还不错