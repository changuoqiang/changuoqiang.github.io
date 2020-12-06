---
title: qemu monitor
tags:
  - Debian
id: '8392'
categories:
  - - GNU/Linux
date: 2019-06-15 17:09:32
---


<!-- more -->
qemu monitor可以监控guest的运行状态，还可以操纵guest的运行

**telnet访问**

qemu命令行上添加
```js
-monitor telnet:192.168.0.86:1234,server,nowait
```
这样在qemu在host接口192.168.0.86端口1234上打开telnet监听，可以使用telnet连接monitor

```js
$ telnet 192.168.0.86 1234
Trying 192.168.0.86...
Connected to 192.168.0.86.
Escape character is '^\]'.
QEMU 3.1.0 monitor - type 'help' for more information
(qemu)
```

注意，如果在qemu命令上quit会结束guest的运行，如果只是想退出telnet连接，应该按'^\]'，然后输入quit退出telnet，之后还可以再次连接qemu monitor

**raw socket访问**
命令行
```js
-monitor tcp:192.168.0.86:1234,server,nowait
```
然后可以这样连接
```js
$ nc 192.168.0.86 1234
QEMU 3.1.0 monitor - type 'help' for more information
(qemu) 
```

again，在qemu命令行上quit，会结束guest的运行，如果只是退出nc的话crtl+c就可以了。

References:
\[1\][通过网络连接到QEMU MONITOR](http://smilejay.com/2014/01/access-qemu-monitor-accross-network/)
\[2\][QEMU/Monitor](https://en.wikibooks.org/wiki/QEMU/Monitor)
\[3\][kvm guest live migration](https://www.linux-kvm.org/page/Migration)