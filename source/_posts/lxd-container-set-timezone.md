---
title: lxd容器设置时区
tags:
  - Debian
id: '8381'
categories:
  - - GNU/Linux
date: 2019-06-12 20:51:00
---


<!-- more -->
lxd容器默认使用UTC时间，可以这样设置容器的时区：

```js
$ lxc config set mycontainer environment.TZ Asia/Shanghai
```

也可以设置lxd default profile，这样使用default profile新建的容器会继承时区设置：

```js
$ lxc profile set default environment.TZ Asia/Shanghai
```