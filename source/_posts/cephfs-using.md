---
title: 使用CephFS文件系统
tags:
  - Debian
id: '8990'
categories:
  - - GNU/Linux
date: 2019-10-31 23:01:57
---


<!-- more -->
**创建池**
ceph文件系统需要驻留在pool上，至少需要创建一个data和一个metadata pool
```js
$ sudo ceph osd pool create cephfs_data 128
pool 'cephfs_data' created

$ sudo ceph osd pool create cephfs_metadata 128
Error ERANGE: pg_num 128 size 3 would mean 768 total pgs, which exceeds max 750 (mon_max_pg_per_osd 250 * num_in_osds 3)
john@node6:~$ sudo ceph osd pool create cephfs_metadata 24
pool 'cephfs_metadata' created
```

**创建文件系统**
```js
$ sudo ceph fs new cephfs cephfs_metadata cephfs_data
new fs with metadata pool 2 and data pool 1
$ sudo ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: \[cephfs_data \]
```
查看mds状态
```js
$ sudo ceph mds stat
cephfs:1 {0=node6=up:active} 2 up:standby
```
没有创建文件系统之前，所有的mds实例都为standby状态
集群状态
```js
$ sudo ceph -s
 cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_OK
 
 services:
 mon: 3 daemons, quorum node8,node6,node7 (age 11m)
 mgr: node6(active, since 11m), standbys: node7, node8
 mds: cephfs:1 {0=node6=up:active} 2 up:standby
 osd: 3 osds: 3 up (since 11m), 3 in (since 3d)
 
 data:
 pools: 2 pools, 152 pgs
 objects: 22 objects, 2.2 KiB
 usage: 3.0 GiB used, 18 GiB / 21 GiB avail
 pgs: 152 active+clean
```

**fuse挂载cephfs**
安装客户端和fuse
```js
$ sudo apt install ceph-common ceph-fuse
```
将集群配置/etc/ceph/*拷贝到客户机相同位置
挂载
```js
$ sudo ceph-fuse /path/to/mount
```
或者指定monitor地址
```js
$ sudo ceph-fuse -m ip_of_monitor /path/to/mount
```
/etc/fstab:
```js
none /mnt/mycephfs fuse.ceph ceph.id=admin,_netdev,defaults 0 0
```
这里指定使用admin用户，使用其他用户需要提前建立用户keyring

**内核驱动挂载cephfs**

```js
$ sudo mount.ceph 192.168.3.8:/ /mnt/mycephfs -o name=admin,secret=AQBHybZdKRryLRAAY9jTUkPpNcXmeykzFPNTTw==
###or: sudo mount -t ceph 192.168.3.8:6789:/ /mnt/mycephfs -o name=admin,secret=AQBHybZdKRryLRAAY9jTUkPpNcXmeykzFPNTTw==
```
如果不指定name选项，默认使用guest用户
当前内核驱动使用msgr v1协议与ceph集群通讯，因此应该使用6789端口，指定3300端口无法连接。

**后记：**
只要/etc/ceph目录下的文件普通用户可以读取，特别是keyring文件，那么普通用户就可以连接到集群使用所有的ceph命令。

References:
\[1\][CREATE A CEPH FILESYSTEM](https://docs.ceph.com/docs/mimic/cephfs/createfs/)
\[2\][MOUNT CEPHFS WITH THE KERNEL DRIVER](https://docs.ceph.com/docs/master/cephfs/kernel/)
\[3\][CEPHFS ADMINISTRATIVE COMMANDS](https://docs.ceph.com/docs/master/cephfs/administration/)
\[4\][cephx](https://runsisi.com/2019-02-14/cephx)
\[5\][Ceph Pool操作总结](https://int32bit.me/2016/05/19/Ceph-Pool%E6%93%8D%E4%BD%9C%E6%80%BB%E7%BB%93/)
\[6\][POOLS](https://docs.ceph.com/docs/jewel/rados/operations/pools/)
\[7\][Mount Ceph Filesystem](https://blog.programster.org/ubuntu-14-04-mount-ceph-filesystem)
\[8\][MOUNT CEPHFS IN YOUR FILE SYSTEMS TABLE](https://docs.ceph.com/docs/master/man/8/mount.fuse.ceph/)
\[9\][Ceph 文件系统 CephFS 的介绍与配置](https://amito.me/2018/CephFS-Introduction-Installation-and-Configuration/)
\[10\][CEPHFS SHELL](https://docs.ceph.com/docs/master/cephfs/cephfs-shell/)