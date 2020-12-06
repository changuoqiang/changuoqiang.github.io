---
title: lxd容器快照
tags:
  - Debian
id: '8346'
categories:
  - - GNU/Linux
date: 2019-06-04 16:10:37
---


<!-- more -->
以下使用的容器名字为test8，运行debian/buster/amd64

**创建容器快照**

```js
$ lxc snapshot test8 test8snap0
```

默认创建的是无状态快照，如果要将容器当前的运行状态一起保存到快照，需要使用`--stateful`参数,比如

```js
$ lxc snapshot test8 test8snap1 --stateful
```

**查看容器快照**

```js
$ lxc info test8
Name: test8
Remote: unix://
Architecture: x86_64
Created: 2019/06/04 07:52 UTC
Status: Running
Type: persistent
Profiles: default
Pid: 7769
Ips:
 eth0: inet 192.168.0.8 vethM2PWUN
 eth0: inet6 fe80::216:3eff:fea7:706b vethM2PWUN
 lo: inet 127.0.0.1
 lo: inet6 ::1
Resources:
 Processes: 5
 CPU usage:
 CPU usage (in seconds): 123
 Memory usage:
 Memory (current): 2.05GB
 Memory (peak): 2.45GB
 Network usage:
 eth0:
 Bytes received: 347.96MB
 Bytes sent: 5.86MB
 Packets received: 132127
 Packets sent: 63110
 lo:
 Bytes received: 4.07kB
 Bytes sent: 4.07kB
 Packets received: 52
 Packets sent: 52
Snapshots:
 test8snap0 (taken at 2019/06/04 08:17 UTC) (stateless)
```

**快照恢复**

```js
$ lxc restore test8 test8snap0
```

**删除快照**

```js
$ lxc delete test8/test8snap0
```