---
title: 手动强制卸载broken包
tags:
  - Debian
id: '9094'
categories:
  - - GNU/Linux
date: 2019-12-26 10:10:33
---


<!-- more -->
```js
$ sudo mv /var/lib/dpkg/info/PACKAGE_NAME.* /tmp/
$ sudo dpkg --remove --force-remove-reinstreq PACKAGE_NAME
```