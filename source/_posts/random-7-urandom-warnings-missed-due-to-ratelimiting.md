---
title: 'random: 7 urandom warning(s) missed due to ratelimiting'
tags:
  - Debian
id: '8846'
categories:
  - - GNU/Linux
date: 2019-10-15 13:32:21
---


<!-- more -->
kvm上的debian虚拟客户机，升级操作系统到buster之后，重启内核启动缓慢:
```js
\[ 3.126166\] ppdev: user-space parallel port driver
\[ 138.280959\] random: crng init done
\[ 138.280968\] random: 7 urandom warning(s) missed due to ratelimiting
```
随机数产生存在问题，以下方法解决
```js
sudo apt-get install haveged
sudo systemctl enable haveged
sudo systemctl start haveged
```

References:
\[1\][Debian Testing takes a long time to load. Crng init done \[closed\]](https://unix.stackexchange.com/questions/461425/debian-testing-takes-a-long-time-to-load-crng-init-done)
\[2\][random: 7 urandom warning(s) missed due to ratelimiting](https://www.linode.com/community/questions/17915/random-7-urandom-warnings-missed-due-to-ratelimiting)