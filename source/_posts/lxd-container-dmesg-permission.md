---
title: lxd容器运行dmesg权限问题
tags:
  - Debian
  - lxd
id: '8927'
categories:
  - - GNU/Linux
date: 2019-10-24 18:08:00
---


<!-- more -->
默认配置的非特权lxd容器内，即使以特权用户运行dmesg
```js
# dmesg
dmesg: read kernel buffer failed: Operation not permitted
```
也是不允许访问内核缓冲区的，这是因为目前容器尚不能做到只读取自己相关的dmesg信息，如果允许容器运行dmesg,容器则会读取到主机全部的信息，包括主机和其他容器以及apparmor的信息，这是安全问题，lxd以后应该会支持每容器的dmesg信息，现在只能在主机上简单粗暴的设置内核参数kernel.dmesg_restrict，特权容器不受此参数限制。

如果允许容器运行dmesg，则需要关闭此参数
```js
$ sudo sysctl kernel.dmesg_restrict=0
```

References:
\[1\][deny access to dmesg or use SYSLOG namespace](https://github.com/lxc/lxd/issues/1397)