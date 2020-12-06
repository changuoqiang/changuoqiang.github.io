---
title: NFS使用固定端口
tags:
  - Debian
id: '9321'
categories:
  - - GNU/Linux
date: 2020-07-05 22:38:21
---


<!-- more -->
NFS通常情况下会使用动态端口，对于防火墙配置很不友好。
可以设置使用固定的几个端口。
修改以下配置文件：
/etc/default/nfs-common:
```js
STATDOPTS="--port 3000 --outgoing-port 3001"
```

/etc/default/nfs-kernel-server:
```js
RPCMOUNTDOPTS="--manage-gids --port 3002"
```

新添加配置文件：
/etc/sysctl.d/nfs-static-ports.conf:
```js
fs.nfs.nlm_tcpport = 3003
fs.nfs.nlm_udpport = 3003
```
然后：
```js
$ sudo sysctl -p /etc/sysctl.d/nfs-static-ports.conf
$ sudo systemctl restart nfs-utils.service
$ sudo systemctl restart nfs-kernel-server.service
```

然后打通防火墙的TCP和UDP端口:111,2049,3000-3003就可以了。

如果出现错误：
```js
mount.nfs: access denied by server while mounting ...
```
可以检查/etc/exports设置的访问网段是否正确，如果通过防火墙NAT方式访问，端口号会大约1024，需要添加insecure访问选项，比如(insecure,rw)

修改/etc/exports后，可以使用
```js
$ sudo exportfs -a
```
重新导出文件系统

References:
\[1\][SecuringNFS](https://wiki.debian.org/SecuringNFS)
\[2\][Setting Up iptables for NFS on Ubuntu](https://www.peterbeard.co/blog/post/setting-up-iptables-for-nfs-on-ubuntu/)