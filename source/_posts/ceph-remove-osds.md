---
title: 'ceph集群移除osd,mon,mdr,mds节点'
tags:
  - Debian
id: '9069'
categories:
  - - GNU/Linux
date: 2019-11-14 10:50:22
---


<!-- more -->
**移除osd节点**

查看当前osd状态
```js
$ ceph osd tree
ID CLASS WEIGHT TYPE NAME STATUS REWEIGHT PRI-AFF 
-1 9.74405 root default 
-9 0.95409 host bank1 
 3 hdd 0.95409 osd.3 up 1.00000 1.00000 
-3 5.99799 host vm01 
 0 hdd 5.99799 osd.0 up 1.00000 1.00000 
-5 1.81929 host vm02 
 1 hdd 1.81929 osd.1 up 1.00000 1.00000 
-7 0.97269 host web 
 2 hdd 0.97269 osd.2 up 1.00000 1.00000 
```

将osd标记为out，准备踢出集群，{osd-num}为osd编号,比如osd.2
```js
$ ceph osd out {osd-num}
```

集群会进行重新平衡和数据迁移，查看 
```js
$ ceph -w
```
`ceps -s`也可以查看进度，当完成时集群状态会重新回归到actice+clean状态
如果卡在active+clean+remapped或者active+remapped状态,先将osd回归集群
```js
$ ceph osd in {osd-num}
```
等集群恢复到active+clean状态后，执行
```js
$ ceph osd crush reweight osd.{osd-num} 0
```
等集群状态再次变成active+clean状态后，将osd标记为out,并停止ceph-osd服务
```js
$ ceph osd out {osd-num}
$ sudo systemctl stop ceph-osd@2.service
```

移除osd
```js
$ ceph osd purge osd.{osd-num} --yes-i-really-mean-it
purged osd.2
```

**移除mon节点**
```js
$ ceph mon remove {mon-name}
```

**移除mgr节点**
在将要被移除的mgr节点上执行
```js
$ sudo systemctl stop ceph-mgr@{mgr-name}
$ sudo systemctl disable ceph-mgr@{mgr-name}
$ sudo rm -rf /var/lib/ceph/mgr/ceph-{mgr-name}
```

**移除mds节点**
在将要被移除的mds节点上执行
```js
$ sudo systemctl stop ceph-mds@{mds-name}
$ sudo systemctl disable ceph-mds@{mds-name}
$ sudo rm -rf /var/lib/ceph/mds/ceph-{mds-name}
```

References:
\[1\][ADDING/REMOVING OSDS](https://docs.ceph.com/docs/master/rados/operations/add-or-rm-osds/)
\[2\][DEPLOYING METADATA SERVERS](https://docs.ceph.com/docs/master/cephfs/add-remove-mds/)