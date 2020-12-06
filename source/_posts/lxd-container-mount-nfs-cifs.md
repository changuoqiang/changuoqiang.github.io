---
title: lxd容器挂载NFS/CIFS文件系统
tags:
  - Debian
  - lxd
id: '8931'
categories:
  - - GNU/Linux
date: 2019-10-24 19:06:14
---


<!-- more -->
lxd容器内挂载NFS文件系统时出现错误提示：
```js
$ sudo mount -t nfs 192.168.0.62:/srv/homes/upload /mnt/nfs/
mount.nfs: Operation not permitted
$ sudo mount -t nfs -v 192.168.0.62:/srv/homes/upload /mnt/nfs/
mount.nfs: timeout set for Thu Oct 24 19:05:41 2019
mount.nfs: trying text-based options 'vers=4.2,addr=192.168.0.62,clientaddr=10.100.0.20'
mount.nfs: mount(2): Operation not permitted
mount.nfs: trying text-based options 'addr=192.168.0.62'
mount.nfs: prog 100003, trying vers=3, prot=6
mount.nfs: trying 192.168.0.62 prog 100003 vers 3 prot TCP port 2049
mount.nfs: prog 100005, trying vers=3, prot=17
mount.nfs: trying 192.168.0.62 prog 100005 vers 3 prot UDP port 39588
mount.nfs: mount(2): Operation not permitted
mount.nfs: Operation not permitted
```
总之就是权限问题，因为容器是非特权容器，在容器内使用root并不是真正的特权用户，因此仍然无法挂载NFS文件系统，CIFS也是一样的问题。
简单的解决办法就是将容器设置为特权容器：
```js
$ lxc config set container raw.lxc "lxc.apparmor.profile=unconfined"
$ lxc config set container security.privileged true
$ lxc restart container
```
restart容器之后挂载一切如常。
**注意一定要同时关闭apparmor**