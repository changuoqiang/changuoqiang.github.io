---
title: lxd容器初步
tags:
  - Debian
id: '8315'
categories:
  - - GNU/Linux
date: 2019-06-02 11:32:04
---


<!-- more -->
docker为应用级容器技术，容器内只能运行一个主进程，而lxd是lxc的上层包装，是系统级容器技术，可以像虚拟化技术一样在容器内运行一个guest OS，但是更轻量。

惯例，主机debian，这次版本是buster。

**安装snap**

lxd是ubuntu亲生的,所以除了ubuntu可以直接用apt安装，其他发行版需要用snap安装，忍！
```js
$ sudo apt install snapd
```

**安装lxd**

```js
$ sudo snap install lxd --channel=3.0/stable
```
这里选择stable版本

**用户权限及sudo**

如果想使用当前普通用户来管理lxd容器，则需要将用户添加到lxd用户组中 
```js
$ sudo adduser $USER lxd
```
当前用户需要重新登录用户组才能生效

因为snap安装的lxd并不在任何传统的文件系统中，它奇葩的位于/snap/bin路径下，so需要编辑/etc/sudoer文件，添加/snap/bin到secure_path

```js
$ which lxd
/snap/bin/lxd
```

下面就可以进入正题了

**初始化lxd**
```js
$ lxd init
```
基本上一路enter即可，以后再详细了解每一项的含义吧, go

**创建容器**
从官方镜像源创建debian buster容器实例bst
```js
$ lxc launch images:debian/buster/amd64 bst
```

如果创建ubuntu容器实例ubt，则可以这样
```js
$ lxc launch ubuntu:18.04 ubt
```
ubuntu的源标签是ubuntu，其他所有发行版的源标签是images，再一次，忍！

**容器列表**
```js
$ lxc list
+------+---------+---------------------+-----------------------------------------------+------------+-----------+
 NAME STATE IPV4 IPV6 TYPE SNAPSHOTS 
+------+---------+---------------------+-----------------------------------------------+------------+-----------+
 bst RUNNING 10.132.77.54 (eth0) fd42:2d28:4331:ad36:216:3eff:fed5:4b5c (eth0) PERSISTENT 0 
+------+---------+---------------------+-----------------------------------------------+------------+-----------+
```

**查看容器实例信息**
```js
$ lxc info bst
Name: bst
Remote: unix://
Architecture: x86_64
Created: 2019/06/02 03:19 UTC
Status: Running
Type: persistent
Profiles: default
Pid: 1166
Ips:
 eth0:inet10.132.77.54vethKTBXNA
 eth0:inet6fd42:2d28:4331:ad36:216:3eff:fed5:4b5cvethKTBXNA
 eth0:inet6fe80::216:3eff:fed5:4b5cvethKTBXNA
 lo:inet127.0.0.1
 lo:inet6::1
Resources:
 Processes: 6
 CPU usage:
 CPU usage (in seconds): 7
 Memory usage:
 Memory (current): 211.66MB
 Memory (peak): 297.09MB
 Network usage:
 eth0:
 Bytes received: 1.43MB
 Bytes sent: 69.46kB
 Packets received: 966
 Packets sent: 902
 lo:
 Bytes received: 0B
 Bytes sent: 0B
 Packets received: 0
 Packets sent: 0
```

**容器交互**
获取容器的shell
```js
$ lxc exec first -- /bin/bash
```

或者执行一次性命令
```js
$ lxc exec first -- apt install procps
```
源里的镜像很干净，基本的工具都需要自己安装，比如procps包里提供了free, kill, pkill, pgrep, pmap, ps, pwdx, skill, slabtop, snice, sysctl, tload, top, uptime, vmstat, w, 和 watch等基本命令行工具

从容器内部往外拉取文件
```js
$ lxc file pull first/etc/hosts .
```
从外部向容器推送文件
```js
$ lxc file push hosts first/etc/
```

向容器推送文件夹
```js
$ lxc file push -r folder first/path/to
```

**停止容器**
```js
$ lxc stop bst
```

**彻底删除容器**
```js
$ lxc delete bst
```

**管理远程lxd服务器**
lxc命令行工具既可以管理本地lxd服务器，也可以管理远程lxd服务器，这里的服务器是指运行的用于管理容器的lxd服务

要管理远程lxd服务器，首先在远程lxd服务器上执行:
```js
$ lxc config set core.https_address "\[::\]"
$ lxc config set core.trust_password some-password
```

第一条命令使lxd服务在所有本地地址上监听8443端口
第二条命令设定访问的密码凭证

然后就可以在本地添加远程的lxd服务器
```js
$ lxc remote add host-a <ip address or DNS name>
```
会提示服务器指纹，并要求提供上一步设置的密码，完成之后就可以像管理本地lxd服务一样来管理远程lxd服务，除了要明确的指定远程lxd服务区的别名之外：

```js
$ lxc exec host-a:bst -- /bin/bash
```
这就是在本地管理远程lxd服务器的容器实例了。

后面继续探索...