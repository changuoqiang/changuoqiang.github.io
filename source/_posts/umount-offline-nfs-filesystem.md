---
title: umount已经下线的远程NFS文件系统
tags:
  - Debian
id: '8799'
categories:
  - - GNU/Linux
date: 2019-10-09 16:46:19
---


<!-- more -->
如果远程的NFS服务器/文件系统已经奔溃，这时候umount会stuck住，可以用下面的命令行将其卸除掉：
```js
$ sudo umount -f -l /mnt/mount_point
```