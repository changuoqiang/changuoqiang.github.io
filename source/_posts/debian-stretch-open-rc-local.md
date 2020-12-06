---
title: debian stretch 启用rc.local
tags:
  - Debian
id: '8377'
categories:
  - - GNU/Linux
date: 2019-06-12 20:40:32
---


<!-- more -->
debian stretch默认不再支持rc.local，但是系统提供了systemd服务rc-local，可以用来添加rc.local支持，详见[\[1\]](https://sb.sb/blog/debian-9-rc-local/)

如果需要指定工作目录，可以在rc.local中exit之前这样写：
```js
(cd /opt/reps && ./reps)
```

References:
\[1\][Debian 9 Stretch 解决 /etc/rc.local 开机启动问题](https://sb.sb/blog/debian-9-rc-local/)