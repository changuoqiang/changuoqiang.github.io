---
title: lxd容器改变存储后端
tags:
  - Debian
id: '8678'
categories:
  - - GNU/Linux
date: 2019-08-13 15:41:43
---


<!-- more -->
已经创建的容器可以通过一定的方法更改为使用其他的存储池/存储后端

**本机**

本机有两个存储池，分别使用btrfs和zfs
```js
$ lxc storage list
+---------+-------------+--------+--------------------------------------------+---------+
 NAME DESCRIPTION DRIVER SOURCE USED BY 
+---------+-------------+--------+--------------------------------------------+---------+
 default btrfs /var/snap/lxd/common/lxd/disks/default.img 1 
+---------+-------------+--------+--------------------------------------------+---------+
 lxd_zfs zfs /var/snap/lxd/common/lxd/disks/lxd_zfs.img 2 
+---------+-------------+--------+--------------------------------------------+---------+
```

使用btrfs存储池新建一个alpine容器
```js
$ lxc init images:alpine/3.10/amd64 alp -s default
$ lxc storage show default
```

可以看到alp容器使用default存储池，也就是btrfs后端。

然后通过将容器发布为image，使用image创建新容器的方式使新的alp容器使用lxd_zfs存储后端
```js
$ lxc publish -f alp --alias alp_img
$ lxc delete alp
$ lxc init alp_img alp -s lxd_zfs
$ lxc image delete alp_img
$ lxc storage show lxd_zfs
config:
 size: 15GB
 source: /var/snap/lxd/common/lxd/disks/lxd_zfs.img
 zfs.pool_name: lxd_zfs
description: ""
name: lxd_zfs
driver: zfs
used_by:
- /1.0/containers/alp
- /1.0/profiles/default
status: Created
locations:
- none
```
可以看到容器alp使用zfs后端存储，其实这是一个全新的容器，不过使用image做了一下中转。

**异机**

在目标服务器上新建zfs存储池和profile
```js
$ lxc storage create lxd_zfs zfs
$ lxc profile create storage_zfs
$ lxc profile device add storage_zfs root disk path=/ pool=lxd_zfs
$ lxc profile show storage_zfs 
config: {}
description: ""
devices:
 root:
 path: /
 pool: lxd_zfs
 type: disk
name: storage_zfs
used_by: \[\]
```

这样在向目标服务器上copy/move容器时，指定storage_zfs profile就可以了。
```js
$ lxc copy container1 remotesvr1: -p storage_zfs
```