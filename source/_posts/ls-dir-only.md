---
title: ls命令只显示目录
tags: []
id: '4251'
categories:
  - - GNU/Linux
date: 2013-11-22 15:55:47
---

串接ls,grep和sed实现只列目录的命令，ls -F grep / sed "s/\\///"，长模式列目录的话更简单ls -l grep /