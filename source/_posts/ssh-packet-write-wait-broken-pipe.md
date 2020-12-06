---
title: ssh packet_write_wait Broken pipe
tags:
  - Debian
id: '8892'
categories:
  - - GNU/Linux
date: 2019-10-20 10:12:07
---


<!-- more -->
ssh连接空闲一段时间后出现：
```js
packet_write_wait: Connection to UNKNOWN port 65535: Broken pipe
```
这是连接超时，需要设置一个保持心跳的参数，客户端是ServerAliveInterval，服务器端是ClientAliveInterval，参数值单位为second，还可以在.ssh/config中为每用户、每连接设置此参数

客户端：
/etc/ssh/ssh_config文件
```js
Host *
ServerAliveInterval 45
```

References:
\[1\][How to prevent “Write Failed: broken pipe” on SSH connection?](https://askubuntu.com/questions/127369/how-to-prevent-write-failed-broken-pipe-on-ssh-connection)
\[2\][当SSH遇到“Write failed: Broken pipe”](https://www.logcg.com/archives/897.html)