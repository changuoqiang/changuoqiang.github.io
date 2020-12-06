---
title: linode最新内核docker服务无法启动
tags: []
id: '8039'
categories:
  - - uncategorized
date: 2018-11-25 12:20:35
---


<!-- more -->
升级完linode发现docker服务无法启动了，containerd服务报找不到overlay模块
```js
...
modprobe: FATAL: Module overlay not found
...
```

linode内核早就启用overlay模块了，这是docker bug导致的。

执行以下命令来解决此问题：
```js
$ su -
$ mkdir -p /etc/systemd/system/containerd.service.d/

$ cat << EOF > /etc/systemd/system/containerd.service.d/override.conf
\[Service\]
ExecStartPre=
EOF

$ systemctl daemon-reload

$ systemctl start docker
```

References:
\[1\][Docker won't start using the latest Linode kernel](https://www.linode.com/community/questions/17114/docker-wont-start-using-the-latest-linode-kernel#answer-67343)