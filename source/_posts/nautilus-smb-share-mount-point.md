---
title: Nautilus smb共享挂载点
tags: []
id: '7147'
categories:
  - - GNU/Linux
date: 2016-01-11 20:21:36
---


<!-- more -->
Nautilus可以自动挂装smb共享目录，但是mount命令却看不到共享目录的挂载点。

nautilus使用gvfs来自动挂载smb共享,需要安装gvfs-fuse来提供本地文件系统视图:

```js
$ sudo apt-get install gvfs-fuse
```

系统重新启动

当前debian系统nautilus自动将共享目录挂载到/run/user/$UID/gvfs下，形如:

```js
smb-share:server=server_name,share=foobar
```

**\===
\[erq\]**