---
title: dnscrypt-proxy-can-not-start
date: 2025-09-28 11:13:33
tags:
    - Debian
categories:
    - GNU/Linux
---

Debian Trixie dnscrypt-proxy 2.1.8 启动问题：无法绑定53端口
<!-- more -->

dnscrypt-proxy 2.1.8启动失败，日志提示：

```listen udp4 127.0.0.1:53: bind: permission denied```

也就是没有网路权限，无法绑定53端口，低于1024的端口为特权端口，普通用户需要授权才能绑定

查看systemd服务单元文件，发现dnscrypt-proxy使用非特权用户启动

```User=_dnscrypt-proxy```

因此需要为非特权用户授权网络权限

```$ sudo systemctl edit dnscrypt-proxy.service```

添加如下行：

```js
[Service]
AmbientCapabilities=cap_net_bind_service
```

然后

```js
$ sudo systemctl daemon-reload
$ sudo systemctl start dnscrypt-proxy.service
```

问题解决，可以顺利启动