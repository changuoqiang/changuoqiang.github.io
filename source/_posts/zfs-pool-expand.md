---
title: zfs pool 空间扩展
tags:
  - Debian
id: '8833'
categories:
  - - GNU/Linux
date: 2019-10-13 20:56:05
---


<!-- more -->
这里以lxd使用的zfs存储后端为例来扩展zpool

先看一下lxd默认存储池default的信息:
```js
$ lxc storage show default
config:
 size: 10GB
 source: /var/snap/lxd/common/lxd/disks/default.img
 zfs.pool_name: default
description: ""
name: default
driver: zfs
used_by:
- /1.0/profiles/default
status: Created
locations:
- none
```
从zfs端看default zpool
```js
$ zpool list default
NAME SIZE ALLOC FREE CKPOINT EXPANDSZ FRAG CAP DEDUP HEALTH ALTROOT
default 9G 372K 9.00G - - 0% 0% 1.00x ONLINE -
```
只有10G大小，现在扩展到100G

停止所有正在运行的容器，使用truncate将存储文件尺寸增大90G：
```js
$ sudo truncate -c -s +90G /var/snap/lxd/common/lxd/disks/default.img
```

查看zpool的自动扩展属性：
```js
$ zpool get autoexpand default
NAME PROPERTY VALUE SOURCE
default autoexpand off default
```
是关闭的，将其打开
```js
$ sudo zpool set autoexpand=on default
```

查看default存储池的设备名称
```js
$ zpool status -vg default
pool: default
 state: ONLINE
 scan: none requested
config:

NAME STATE READ WRITE CKSUM
default ONLINE 0 0 0
 15286821055422665849 ONLINE 0 0 0

errors: No known data errors
```

扩展default池到最大可用容量
```js
$ sudo zpool online -e default 15286821055422665849
```
查看default池
```js
$ zpool list default
NAME SIZE ALLOC FREE CKPOINT EXPANDSZ FRAG CAP DEDUP HEALTH ALTROOT
default 99G 399K 99.0G - - 0% 0% 1.00x ONLINE -
```
可以看到容量已经扩展到了100G

关闭zpool的自动扩展
```js
$ sudo zpool set autoexpand=off default
```

lxd端查看：
```js
$ lxc storage info default
info:
 description: ""
 driver: zfs
 name: default
 space used: 340.99kB
 total space: 102.98GB
used by:
 profiles:
 - default
```

lxd官方文档给的方案，参见\[3\]：
```js
sudo truncate -s +5G /var/lib/lxd/disks/<POOL>.img
sudo zpool set autoexpand=on lxd
sudo zpool online -e lxd /var/lib/lxd/disks/<POOL>.img
sudo zpool set autoexpand=off lxd
```

References:
\[1\][How to resize ZFS used in LXD](https://discuss.linuxcontainers.org/t/how-to-resize-zfs-used-in-lxd/1333)
\[2\][GROWING ZFS POOL](https://tomasz.korwel.net/2014/01/03/growing-zfs-pool/)
\[3\][Storage configuration](https://lxd.readthedocs.io/en/latest/storage/)