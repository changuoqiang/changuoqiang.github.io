---
title: Ceph集群部署-mgr-osd-mds配置
tags:
  - Debian
id: '8975'
categories:
  - - GNU/Linux
date: 2019-10-31 20:04:42
---


<!-- more -->
**一、添加manager**

通常每一个运行monitor的机器上同时运行一个manager,以获取同样的可用性，但是manager不涉及到选举，运行于primary/standby模式。

1、创建mgr认证keyring
```js
$ sudo ceph auth get-or-create mgr.node6 mon 'allow profile mgr' osd 'allow *' mds 'allow *'
\[mgr.node6\]
key = AQDAzLpdq7HzDRAAkRLSSkRO/1aLZU+87FcN5g==
```
这里mgr的名字仍然选用主机名,也就是mgr.$(hostname -s)

2、创建mgr实例的目录
```js
sudo -u ceph mkdir /var/lib/ceph/mgr/ceph-node6/
```

3、导出mgr keyring到ngr实例目录
```js
$ sudo ceph auth get mgr.node6 -o /var/lib/ceph/mgr/ceph-node6/keyring
exported keyring for mgr.node6
```

4、运行mgr实例
```js
$ sudo systemctl enable ceph-mgr@node6.service
$ sudo systemctl start ceph-mgr@node6.service
$ sudo ceph -s
cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_OK
 
 services:
 mon: 3 daemons, quorum node8,node6,node7 (age 11m)
 mgr: node6(active, starting, since 0.109568s)
 osd: 0 osds: 0 up, 0 in
 
 data:
 pools: 0 pools, 0 pgs
 objects: 0 objects, 0 B
 usage: 0 B used, 0 B / 0 B avail
 pgs: 
```
可以看到mgr活动实例启动了，重复以上步骤添加其他mgr实例。

**二、添加OSD**

OSD(Object Storage Device)是真正存储数据的组件，一般生产环境至少要部署3个OSD,参数文件/etc/ceph/ceph.conf中`osd pool default size = 3`设定为3，至少需要3个osd进程，集群才能达到active + clean状态。

OSD有几种后端存储，建议使用bluestore提高系统稳定性和效率，bluestore只能使用逻辑卷、磁盘或分区，注意初始化OSD时指定的逻辑卷、磁盘或者分区上的数据会全部被抹掉。一般建议OSD使用单独的机器部署，并且与OS分别使用不同的驱动器。

1、导出client.bootstrap-osd keyring
如果本地机器上没有此keyring,则需要先从集群导出到本地
```js
$ sudo ceph auth get client.bootstrap-osd -o /var/lib/ceph/bootstrap-osd/ceph.keyring
```

2、创建OSD
```js
$ sudo ceph-volume lvm create --data /dev/sdb
```
注意要使用正确的底层设备,lsblk可以查看系统块存储设备。
如果提示错误：
```js
ceph-volume lvm create: error: GPT headers found, they must be removed on: /dev/sdb
...
stderr: Device /dev/sdc excluded by a filter.
...
```
需要先清除掉分区表:
```js
$ sudo partprobe -s /dev/sdb
$ sudo dd if=/dev/zero of=/dev/sdb bs=512 count=1
```
**注意：**这些操作是破坏性的，一定要确认是在正确的块设备上进行操作。

3、运行OSD
```js
$ sudo ceph-volume lvm list

====== osd.0 =======

 \[block\] /dev/ceph-f67dd26c-f5d8-44ca-a9da-fe6b6fccec65/osd-block-bf952b83-7ffe-49e2-bdd7-d2fd3faacafb

 block device /dev/ceph-f67dd26c-f5d8-44ca-a9da-fe6b6fccec65/osd-block-bf952b83-7ffe-49e2-bdd7-d2fd3faacafb
 block uuid jYMJc5-jjUe-hgPk-Wlhk-yo9y-t6JF-r8SqNa
 cephx lockbox secret 
 cluster fsid 0238426D-78D6-48CD-AF64-B6A8407996C6
 cluster name ceph
 crush device class None
 encrypted 0
 osd fsid bf952b83-7ffe-49e2-bdd7-d2fd3faacafb
 osd id 0
 type block
 vdo 0
 devices /dev/sdb

//sudo systemctl enable ceph-osd@0.service
//sudo systemctl start ceph-osd@0.service
```
先查找osd实例的名称，然后启用相应的实例服务,ceph-volume会自动创建相应的服务并启动它们。
```js
$ sudo ceph -s
 cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_OK
 
 services:
 mon: 3 daemons, quorum node8,node6,node7 (age 37m)
 mgr: node6(active, since 25m), standbys: node7, node8
 osd: 1 osds: 1 up (since 85s), 1 in (since 85s)
 
 data:
 pools: 0 pools, 0 pgs
 objects: 0 objects, 0 B
 usage: 1.0 GiB used, 6.0 GiB / 7 GiB avail
 pgs: 
```
可以看到运行了一个osd实例，重复以上步骤添加其他OSD实例。

**三、添加mds**
如果要使用CephFS文件系统才需要设置mds实例，对象存储和块设备存储无需mds实例。

1、创建mds实例目录
```js
$ sudo -u ceph mkdir -p /var/lib/ceph/mds/ceph-node6
```
目录格式为{cluster-name}-{id}，按照惯例这里id仍然取主机名$(hostname -s)

2、创建mds实例keyring
```js
$ sudo -u ceph ceph-authtool --create-keyring /var/lib/ceph/mds/ceph-node6/keyring --gen-key -n mds.node6
```

3、将mds实例keyring导入集群并设置caps权限
```js
$ sudo ceph auth add mds.node6 osd "allow rwx" mds "allow" mon "allow profile mds" -i /var/lib/ceph/mds/ceph-node6/keyring
added key for mds.node6
```
或者2,3步合并为一步：
```js
$ sudo ceph auth get-or-create mds.node6 mon 'allow profile mds' mgr 'allow profile mds' mds 'allow *' osd 'allow *' sudo -u ceph tee /var/lib/ceph/mds/ceph-node6/keyring
```

4、编辑/etc/ceph/ceph.conf添加mds实例
```js
\[mds.node6\]
host = node6
```

5、启动mds实例
```js
$ sudo systemctl enable ceph-mds@node6
$ sudo systemctl start ceph-mds@node6
```

References:
\[1\][CEPH-MGR ADMINISTRATOR’S GUIDE](https://docs.ceph.com/docs/master/mgr/administrator/#mgr-administrator-guide)
\[2\][DEPLOYING METADATA SERVERS](https://docs.ceph.com/docs/master//cephfs/add-remove-mds/)