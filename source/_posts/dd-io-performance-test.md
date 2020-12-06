---
title: dd命令测试磁盘IO性能
tags:
  - Debian
id: '9077'
categories:
  - - GNU/Linux
date: 2019-11-15 13:46:02
---


<!-- more -->
```js
$ time dd if=/dev/zero of=/tmp/test.img bs=1G count=1 oflag=dsync
```