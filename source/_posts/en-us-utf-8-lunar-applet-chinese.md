---
title: en_US.UTF-8环境下让lunar-applet显示中文
tags:
  - Debian
id: '803'
categories:
  - - GNU/Linux
date: 2010-05-03 11:05:14
---

en_US.UTF-8环境下luna-applet默认用拼音来显示农历，可以把 /usr/share/locale/zh_CN/LC_MESSAGES/liblunar.mo 复制到/usr/share/locale/en/LC_MESSAGES/ 下即可让lunar-applet在英文环境下用汉字来显示农历。