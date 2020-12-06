---
title: lxd容器使用zfs存储池
tags:
  - Debian
  - ZFS
id: '8662'
categories:
  - - GNU/Linux
date: 2019-08-08 10:49:49
---


<!-- more -->
lxd支持btrfs,zfs,lvm和ceph存储后端，默认使用btrfs，但在线迁移容器的时候btrfs总是不成功，可以尝试更换到zfs存储后端，zfsonlinux项目已经十分成熟。

**安装**

buster发布后，debian-backports已经启用了，为了安装更新版本的zfs，最好添加这个源：
/etc/apt/source.list
```js
# backports
deb http://ftp.cn.debian.org/debian buster-backports main contrib non-free
```
/etc/apt/preferences.d/90_zfs
```js
Package: libnvpair1linux libuutil1linux libzfs2linux libzpool2linux spl-dkms zfs-dkms zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=buster-backports
Pin-Priority: 990
```

因为需要编译内核模块,先安装内核头文件
```js
# apt update
# apt install linux-headers-$(uname -r) linux-image-amd64
```

安装zfsonlinux
```js
# apt install zfs-dkms zfsutils-linux
```
安装到最后会有一些错误提示，不要害怕，那是因为还没有加载zfs内核模块

加载内核模块
```js
# modprobe zfs
```

然后重新执行上一个安装命令，zfs就会配置成功了。

系统自动加载内核模块
```js
# echo "zfs" >> /etc/modules
```

如果安装zfs之前已经安装了lxd，那么需要将lxd daemon重启一下，否则lxd会报错：
```js
Error: The "zfs" tool is not enabled
```

重启lxd daemon
```js
$ sudo systemctl reload snap.lxd.daemon
```

**存储池**

`lxd init`的时候就可以选择ZFS作为存储后端来新建default storage pool了，默认会使用当前文件系统内的文件来虚拟一个zfs文件系统，也可以使用真实的zfs文件系统来建立存储池。

也可以使用`lxc storage create`命令来创建新的使用zfs作为存储后端的存储池。
创建zfs存储池lxd_zfs
```js
$ lxc storage create lxd_zfs zfs size=100GB
```

将默认配置的存储池设置为lxd_zfs，前提是没有容器在使用default profile的root disk设备。
```js
$ lxc profile device remove default root
$ lxc profile device add default root disk path=/ pool=lxd_zfs
$ lxc profile show default 
config: {}
description: Default LXD profile
devices:
 eth0:
 name: eth0
 nictype: bridged
 parent: lxdbr0
 type: nic
 root:
 path: /
 pool: lxd_zfs
 type: disk
name: default
used_by: \[\]
```

后面再新建容器就会自动使用zfs存储池lxd_zfs了。
也可以将default存储池删除掉，重现创建一个default存储池，只要default存储池没有被镜像、容器或profile使用即可。
其实default就是一个名字而已，与其他存储池并无任何不同。

References:
\[1\][Setup a ZFS pool for your LXC containers with LXD](https://angristan.xyz/lxc-zfs-pool-lxd/)
\[2\][zfsonlinux](https://zfsonlinux.org/)
\[3\][debian](https://github.com/zfsonlinux/zfs/wiki/Debian)