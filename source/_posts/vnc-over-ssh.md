---
title: 透过ssh使用VNC(VNC over SSH)
tags:
  - Debian
id: '2009'
categories:
  - - GNU/Linux
date: 2012-03-27 09:04:01
---

除了SSH,linux平台还可以使用图形化的方式访问远端机器,最流行的当属VNC
<!-- more -->
然而VNC连接并不安全,容易被拦截,监听,所以更安全的方式是透过SSH隧道来使用VNC,SSH的安全性是有保证的。

很简单,使用SSH做端口转发

**终端方式**

$ ssh -L 5900:localhost:5900 -N -f sshserver_ip_or_name

参数

-L \[bind_address:\]port:host:hostport 将本地主机(ssh客户端)的指定端口转发到远端主机的指定端口,-L 5900:localhost:5900具体是指将本地任意接口的5900端口转发到远端localhost接口的5900端口。VNC服务器的默认起始端口为5900,然后再加上display号,如果VNC服务器在0号display上监听,其监听端口为5900+0也就是5900,如果在1号display上监听,则其监听端口为5900+1也就是5901,以此类推。

-N 不执行远端命令。此SSH连接只做端口转发之用。

-f 将SSH放到后台执行

然后使用vnc viewer连接本地的5900端口即可

$vncviewer 127.0.0.1\[:5900\]

**图形方式**

ssvnc - Enhanced TightVNC viewer with SSL/SSH tunnel helper
ssvnc内置SSL/SSH支持,提供安全的VNC连接,详情见[ssvnc官方](http://www.karlrunge.com/x11vnc/ssvnc.html)