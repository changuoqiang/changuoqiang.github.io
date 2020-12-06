---
title: lxd镜像/映像
tags:
  - Debian
id: '8355'
categories:
  - - GNU/Linux
date: 2019-06-04 19:17:08
---


<!-- more -->
lxd使用镜像来生成容器，可以有几种不同的方式来使用镜像

**内建映像服务**

lxd内建三个映像服务，分别是
ubuntu - 提供稳定版ubuntu镜像
ubuntu-daily - 提供每日构建版ubuntu镜像
images - 提供其他发行版镜像

这样使用内置镜像服务
```js
$ lxc launch ubuntu:18.04 my-ubuntu
$ lxc launch ubuntu-daily:19.04 my-ubuntu-dev
$ lxc launch images:debian/buster/amd64 my-debian
```

显示镜像列表
```js
$ lxc image list ubuntu:
$ lxc image list ubuntu-daily:
$ lxc image list images:
```

**使用远程lxd实例的镜像**

添加远程lxd实例
```js
$ lxc remote add my-images 192.168.0.x
```

使用远程lxd实例的镜像实例化容器
```js
$ lxc launch my-images:image-name your-container
```

远程lxd实例上的镜像列表
```js
$ lxc image list my-images:
```

其实lxd内建的镜像服务就是lxd实例，无非其remote的名字为ubuntu, ubuntu-daily和images而已。

**手动导入镜像文件**

```js
$ lxc image import <file> --alias my-alias
```

使用此导入的镜像
```js
$ lxc launch my-alias my-container
```

**使用容器或快照创建镜像**

使用容器创建镜像
```js
$ lxc my-container stop
$ lxc publish my-container --alias test-image
```

使用快照创建镜像
```js
$ lxc publish my-container/my-snap --alias test-image2
```

之后就可以正常的使用这些镜像来生成容器了。