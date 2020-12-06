---
title: TSC_DEADLINE disabled due to Errata
tags:
  - Debian
id: '8721'
categories:
  - - GNU/Linux
date: 2019-09-21 10:21:06
---


<!-- more -->
dmesg中有错误消息：
```js
\[Firmware Bug\]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
```

安装intel微码可以解决此问题：
```js
$ sudo apt install intel-microcode
```