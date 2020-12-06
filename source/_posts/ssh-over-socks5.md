---
title: ssh over socks5
tags: []
id: '8195'
categories:
  - - uncategorized
date: 2018-12-26 14:19:18
---

nc要使用netcat-openbsd版本或者使用nmap实作的ncat
<!-- more -->
可以在ssh命令行或者config文件中:
```js
ProxyCommand /bin/nc -x 127.0.0.1:1080 %h %p
#ProxyCommand /usr/bin/ncat --proxy-type socks5 --proxy 127.0.0.1:1080 %h %p
```

可以使用如下命令切换nc版本：
```js
$ sudo update-alternatives --config nc
```