---
title: 挂载virtualbox共享文件夹
tags:
  - Debian
id: '8308'
categories:
  - - GNU/Linux
date: 2019-06-02 10:11:27
---


<!-- more -->
首先需要[安装guest addtions](https://openwares.net/2019/06/02/guiless-install-virtualbox-guest-additions/)

主机端：

为客户机配置共享文件夹，略。

客户机：

列出可用的share folders
```js
$ sudo VBoxControl sharedfolder list
Oracle VM VirtualBox Guest Additions Command Line Management Interface Version 6.0.8
(C) 2008-2019 Oracle Corporation
All rights reserved.

Shared Folder mappings (1):

01 - Downloads \[idRoot=0 writable auto-mount host-icase guest-icase mnt-pt=/media/host/\]
```

如果设定了自动挂装, virtualbox会自动挂载之，否则可以手动挂载：

```js
$ sudo mount -t vboxsf Downloads /media/host
```

访问权限问题，将当前用户加入vboxsf组
```js
$ sudo adduser $USER vboxsf
```

然后注销重新登录，或者使用
```js
$ newgrp vboxsf
```