---
title: 为firefox安装java插件
tags:
  - Debian
  - Firefox
id: '1969'
categories:
  - - GNU/Linux
date: 2012-03-14 14:32:25
---

Debian AMD64系统,firefox 11安装java plugin
<!-- more -->
google docs上传文件夹需要安装java applet,已经安装了sun java 6 jdk和jre,但仍然提示firefox不支持java,只是因为friefox没有找到java plugin而已,在firefox查找的plugin目录下为java plugin建立一个符号链接即可

$cd ~/.mozilla/plugins
$sudo ln -sf /usr/lib/jvm/java-6-sun/jre/lib/amd64/libnpjp2.so .

然后restart firefox,在plugins页面已经可以看到Java(TM) Plug-in 1.6.0_26,google docs安装applet成功。

如果你使用openjdk那就更简单了,安装包icedtea-plugin就可以了

$sudo apt-get install icedtea-plugin

这个插件的名字叫IcedTea-Web Plugin