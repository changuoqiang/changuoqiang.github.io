---
title: 使用nc(netcat)传输文件
tags: []
id: '5900'
categories:
  - - GNU/Linux
date: 2014-09-30 19:35:23
---


<!-- more -->
如果手上没有移动存储器，也不想开ftp,那么两台电脑之间可以使用nc(netcat)传输文件,比如现在要在一台mac和一台linux机器之间传输文件。

要接收文件的机器开启监听准备接收文件,本机器的ip地址为1.2.3.4

```js
$ nc -l -p 1234 > foo.bar
```

发送文件的机器开始发送文件 

```js
$ nc 1.2.3.4 1234 < foo.bar
```

**\===
\[erq\]**