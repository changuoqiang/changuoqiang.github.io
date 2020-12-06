---
title: debian安装rkt
tags:
  - Debian
id: '7621'
categories:
  - - GNU/Linux
date: 2016-10-06 16:09:55
---


<!-- more -->
rkt是一个容器引擎和规范，Kubernetes已经支持rkt容器引擎，rkt兼容docker，但其更unix更安全。

Kubernetes + rkt可以组建基于容器的云计算平台，而openstack是为虚拟化而生。

openstack结合Kubernetes可以组建既有虚拟化又有容器的混合云计算平台。

**安装rkt**

当前debian官方只有sid源里有rkt包，而且版本略滞后，因此可以这样安装最新版本的rkt

```js
$ wget https://raw.githubusercontent.com/coreos/rkt/master/scripts/install-rkt.sh
$ chmod +x install-rkt.sh
$ sudo ./install-rkt.sh
```

install-rkt.sh脚本会生成deb包再安装。

**卸载**

```js
$ sudo apt remove rkt --purge
```

References:
\[1\][Installing rkt on popular Linux distributions](https://coreos.com/rkt/docs/latest/distributions.html)

**\===
\[erq\]**