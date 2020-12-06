---
title: 使用ceph块设备
tags:
  - Debian
id: '9010'
categories:
  - - GNU/Linux
date: 2019-11-04 22:43:24
---


<!-- more -->
ceph提供了一个具有很多高级特性的虚拟块设备，可以当做普通块设备来使用，也可以用于qemu等虚拟化环境。ceph提供的块设备具有多副本高可用、快照、精简配置、条带化、远程镜像等很多特性。

**基本操作**

创建并初始化一个块设备池，取名叫rbd
```js
$ sudo ceph osd pool create rbd 36 36
$ sudo rbd pool init
```
如不提供pool名字,rdb命令默认使用名字为rdb的pool

创建块设备镜像data，大小为1024MB，可以忽略掉pool名字
```js
$ sudo rbd create --size 1024 rbd/data
```
因为ceph使用精简配置，所以把size设置的大一些也无妨，不使用并不会真正的占用存储空间。

获取镜像信息
```js
$ sudo rbd info data
rbd image 'data':
size 1 GiB in 256 objects
order 22 (4 MiB objects)
snapshot_count: 0
id: 2ab0d130bf615
block_name_prefix: rbd_data.2ab0d130bf615
format: 2
features: layering, exclusive-lock, object-map, fast-diff, deep-flatten
op_features: 
flags: 
create_timestamp: Wed Nov 6 21:59:10 2019
access_timestamp: Wed Nov 6 21:59:10 2019
modify_timestamp: Wed Nov 6 21:59:10 2019
```

resize镜像,扩大和缩小
```js
$ sudo rbd resize --size 2048 foo
$ sudo rbd resize --size 2048 foo --allow-shrink
```

删除块设备镜像
```js
$ suro rbd rm {pool-name}/{image-name}
$ sudo rbd rm foo
```

**内核模块块设备映射**

可以通过内核模块将ceph块设备镜像映射成为OS可以操作的块设备，就像一个真的块设备一样，比如一块硬盘。

镜像列表
```js
$ sudo rbd list
```

映射为块设备，使用默认的client.admin用户
```js
###format: rbd device map {pool-name}/{image-name} --id {user-name}
$ sudo rbd device map data
bd: sysfs write failed
RBD image feature set mismatch. You can disable features unsupported by the kernel with "rbd feature disable data object-map fast-diff deep-flatten".
In some cases useful info is found in syslog - try "dmesg tail".
rbd: map failed: (6) No such device or address
$ sudo rbd feature disable data object-map fast-diff deep-flatten
$ sudo rbd device map data
/dev/rbd0
```
这里映射出来的块设备名字为/dev/rbd0，当做普通的块设备来使用就行了。

查看映射设备列表
```js
$ sudo rbd device list
id pool namespace image snap device 
0 rbd data - /dev/rbd0 
```

取消设备映射
```js
###format: rbd device unmap /dev/rbd/{poolname}/{imagename}
###format: rbd device unmap {devicename}
$ sudo rbd device unmap /dev/rbd0
```

注意：块设备是不能共享访问的，所以不要多次映射并行访问同一个镜像。

**QEMU集成**

创建镜像,要使用raw格式,不要使用其他格式
```js
###format: qemu-img create -f raw rbd:{pool-name}/{image-name} {size}
$ sudo qemu-img create -f raw rbd:rbd/foo 10G
Formatting 'rbd:rbd/foo', fmt=raw size=10737418240
```

查看镜像信息
```js
$ sudo qemu-img info rbd:rbd/foo
image: json:{"driver": "raw", "file": {"pool": "rbd", "image": "foo", "driver": "rbd"}}
file format: raw
virtual size: 10G (10737418240 bytes)
disk size: unavailable
cluster_size: 4194304
```

resize镜像
```js
###format: qemu-img resize rbd:{pool-name}/{image-name} {size}
$ sudo qemu-img resize rbd:rbd/foo 20G
```

转换已有kvm镜像为ceph镜像
```js
$ sudo qemu-img convert -f qcow2 -O raw bar.qcow2 rbd:rbd/bar
###or: sudo qemu-img convert -f qcow2 bar.qcow2 -O raw rbd:rbd/bar
```

运行客户机
```js
$ qemu -m 1024 -drive format=rbd,file=rbd:rbd/bar,cache=writeback
```

**lxd集成**

lxd已经内置支持ceph集群存储,执行lxd init时，指定存储后端为ceph即可。
也可以使用lxc storage命令创建新的存储池。
lxd集群使用ceph后端存储可以创建高可用lxd容器，但是同一时刻只能有一个节点在运行一个容器实例，需要其他机制来自动故障转移。

References:
\[1\][CEPH BLOCK DEVICE](https://docs.ceph.com/docs/master/rbd/)
\[2\][Ceph 中块设备 RBD 的基本用法](https://amito.me/2018/Using-RBD-in-Ceph/)
\[3\][Ceph storage driver in LXD](https://ubuntu.com/blog/ceph-storage-driver-in-lxd)