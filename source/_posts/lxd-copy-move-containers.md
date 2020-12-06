---
title: lxd拷贝/迁移容器
tags:
  - Debian
id: '8366'
categories:
  - - GNU/Linux
date: 2019-06-04 22:20:16
---


<!-- more -->
假设有两个lxd host，分别为lxd-l和lxd-r,在lxd-l机器上添加一个remote叫做lxd-r

```js
$ lxc remote add lxd-r <ip of lxd-r>
```

**拷贝容器**

1. 停止容器并拷贝到远程

```js
$ lxc stop pridns
$ lxc copy pridns lxd-r:pridns-backup
$ lxc start pridns
```

2. 制作容器快照，第一个快照为snap0，以此类推，然后拷贝快照到lxd-r
```js
$ lxc snapshot my-container
$ lxc copy my-container/snap0 lxd-r:my-container-backup
```

3. 直接拷贝运行中的容器
```js
$ lxc copy pridns lxd-r:pridns-backup
Error: Unable to perform container live migration. CRIU isn't installed on the source server
```
直接拷贝运行中的容器叫做live migration，需要将其运行状态一起拷贝到目标容器，保持二者完全一致，这需要CRIU的支持，lxd已经打包了CUIR,需要在本地和远程host上分别启用CRIU
```js
$ sudo snap set lxd criu.enable=true
$ sudo systemctl reload snap.lxd.daemon
```
然后再拷贝

lxc move