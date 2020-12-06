---
title: Ceph集群部署-monitors配置
tags: []
id: '8862'
categories:
  - - GNU/Linux
date: 2019-10-16 22:26:56
---


<!-- more -->
ceph官方仓库尚未提供debian 10 buster版本的ceph nautilus，而debian官方仓库里也只有ceph 12版本，可以使用三方仓库在debian buster上安装ceph nautilus

proxmox仓库

```js
$ echo 'deb \[arch=amd64\] http://download.proxmox.com/debian/ceph-nautilus buster main' sudo tee /etc/apt/sources.list.d/proxmox-ceph.list
$ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7BF2812E8A6E88E0
$ sudo apt update && sudo apt install ceph
```

croit.io仓库

```js
$ curl https://mirror.croit.io/keys/release.asc sudo apt-key add -
$ echo 'deb https://mirror.croit.io/debian-nautilus/ buster main' sudo tee /etc/apt/sources.list.d/croit-ceph.list
$ sudo apt update && sudo apt install ceph
```

**Updated(2020/02/01):** 现在可以使用buster-backports仓库来安装ceph nautilus

ceph集群安装的第一步是monitor自举

**一、monitor bootstrapping**
1、添加配置文件/etc/ceph/ceph.conf
这里集群的名字使用默认的ceph,ceph.conf文件名中的基本名ceph也是集群名。
```js
\[global\]
# 使用uuidgen生成,debian请安装uuid-runtime包
fsid = 0238426D-78D6-48CD-AF64-B6A8407996C6
# 使用主机名,可以用hostname -s命令获取
mon initial members = node8
# ip地址,支持messenger v1和v2
mon_host = 192.168.3.8
#mon_host = v2:192.168.3.8:3300/0,v1:192.168.3.8:6789/0
# public network可以指定逗号分割的多个子网
public network = 192.168.3.0/24
# 使用cephx认证
auth cluster required = cephx
auth service required = cephx
auth client required = cephx
osd journal size = 1024
# 副本策略,副本数量
osd pool default size = 3
# 降级状态最小副本数量,低于此数量会失败
osd pool default min size = 2
# 默认placement group数量
osd pool default pg num = 333
# 默认placement groups for placement数量
osd pool default pgp num = 333
osd crush chooseleaf type = 1
```

2、创建集群keyring,生成monitor密钥
```js
$ ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
```

3、创建管理keyring,生成client.admin用户并加入keyring
```js
$ sudo ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'
```

4、创建bootstrap-osd keyring,生成client.bootstrap-osd用户并加入keyring
```js
$ sudo ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'
```

5、将生成的key添加到ceph.mon.keyring
```js
$ sudo ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
$ sudo ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
```

6、生成monitor map
```js
$ monmaptool --create --add node8 192.168.3.8 --fsid 0238426D-78D6-48CD-AF64-B6A8407996C6 /tmp/monmap
```
注意此处指定的节点名称、ip地址和fsid要与/etc/ceph/ceph.conf中指定的一致,ip地址还可以使用新的格式指定v2:192.168.3.8:3300/0,v1:192.168.3.8:6789/0

map文件是二进制格式的，可以这样查看生成的map内容
```js
$ monmaptool --print /tmp/monmap
monmaptool: monmap file /tmp/monmap
epoch 0
fsid 0238426d-78d6-48cd-af64-b6a8407996c6
last_changed 2019-10-28 20:24:58.156493
created 2019-10-28 20:24:58.156493
min_mon_release 0 (unknown)
0: v1:192.168.3.8:6789/0 mon.node8
```

7、创建monitor数据目录
```js
sudo -u ceph mkdir /var/lib/ceph/mon/ceph-node8
```
目录名字格式为{cluster-name}-{hostname}

8、修改ceph.mon.keyring访问权限
```js
$ chmod o+r /tmp/ceph.mon.keyring
```
不然会因为ceph用户无法读取/tmp/ceph.mon.keyring而抛出如下错误:
```js
2019-10-28 19:43:54.149 7eff2ff1f440 -1 mon.node8@-1(???) e0 unable to find a keyring file on /tmp/ceph.mon.keyring: (13) Permission denied
2019-10-28 19:43:54.149 7eff2ff1f440 -1 ceph-mon: error creating monfs: (2) No such file or directory
```

9、初始化monitor数据结构
```js
sudo -u ceph ceph-mon --mkfs -i node8 --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
```

10、启动ceph monitor
```js
//$ sudo ln -sf /lib/systemd/system/ceph-mon@.service /etc/systemd/system/multi-user.target.wants/ceph-mon@node8.service
//$ sudo systemctl daemon-reload
$ sudo systemctl enable ceph-mon@node8.service
$ sudo systemctl start ceph-mon@node8.service
```
生成monitor实例自启动systemd服务文件并开启服务

11、查看集群状态
```js
$ sudo ceph -s
 cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_WARN
 1 monitors have not enabled msgr2
 
 services:
 mon: 1 daemons, quorum node8 (age 12m)
 mgr: no daemons active
 osd: 0 osds: 0 up, 0 in
 
 data:
 pools: 0 pools, 0 pgs
 objects: 0 objects, 0 B
 usage: 0 B used, 0 B / 0 B avail
 pgs: 
```

12、启用messenger v2协议
```js
$ sudo ceph mon enable-msgr2
$ sudo ceph -s
 cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_OK
 
 services:
 mon: 1 daemons, quorum node8 (age 67m)
 mgr: no daemons active
 osd: 0 osds: 0 up, 0 in
 
 data:
 pools: 0 pools, 0 pgs
 objects: 0 objects, 0 B
 usage: 0 B used, 0 B / 0 B avail
 pgs: 
```
集群健康状态成为HEALTH_OK
dump集群配置
```js
$ sudo ceph mon dump
dumped monmap epoch 2
epoch 2
fsid 0238426d-78d6-48cd-af64-b6a8407996c6
last_changed 2019-10-28 20:15:02.687549
created 2019-10-28 19:51:04.486571
min_mon_release 14 (nautilus)
0: \[v2:192.168.3.8:3300/0,v1:192.168.3.8:6789/0\] mon.node8
```

**二、添加其他monitor**

一个monitor可以运行ceph集群，但是在生产环境推荐至少要运行三个monitor实例或以上，而且数量最好是奇数，这是因为容错时需要大多数实例达成一致的原因。monitor可以与OSD实例运行在一台物理机器上，但推荐是分开部署。

以下操作皆是在将要添加的monitor机器上执行

1、拷贝初始monitor配置文件

将集群第一个monitor的配置文件目录/etc/ceph整个拷贝到新monitor相同路径，注意保持文件属性不变。之后，新monitor节点虽然尚未初始化，但已经可以访问ceph集群。

2、创建目录
```js
$ sudo -u ceph mkdir /var/lib/ceph/mon/ceph-node6
```

3、获取monitor keyring
```js
$ sudo ceph auth get mon. -o /tmp/ceph.mon.keyring
exported keyring for mon.
```
注意检查/tmp/ceph.mon.keyring文件的访问权限，确保ceph用户可以读取。

4、获取集群monitor map
```js
$ sudo ceph mon getmap -o /tmp/ceph.mon.map
got monmap epoch 2
```

5、初始化新monitor
```js
$ sudo -u ceph ceph-mon --mkfs -i node6 --monmap /tmp/ceph.mon.map --keyring /tmp/ceph.mon.keyring
$ sudo systemctl enable ceph-mon@node6.service
$ sudo systemctl start ceph-mon@node6.service
$ sudo ceph -s
 cluster:
 id: 0238426d-78d6-48cd-af64-b6a8407996c6
 health: HEALTH_OK
 
 services:
 mon: 2 daemons, quorum node8,node6 (age 0.16939s)
 mgr: no daemons active
 osd: 0 osds: 0 up, 0 in
 
 data:
 pools: 0 pools, 0 pgs
 objects: 0 objects, 0 B
 usage: 0 B used, 0 B / 0 B avail
 pgs: 
```

可以看到集群已经有了两个monitor
查看集群monitor状态信息
```js
$ sudo ceph mon stat
e3: 2 mons at {node6=\[v2:192.168.3.6:3300/0,v1:192.168.3.6:6789/0\],node8=\[v2:192.168.3.8:3300/0,v1:192.168.3.8:6789/0\]}, election epoch 26, leader 0 node8, quorum 0,1 node8,node6
```

添加其他新monitor重复以上步骤。

References:
\[1\][Ceph Docs](https://docs.ceph.com/docs/master/)
\[2\][Debian stable and Ceph are great](https://croit.io/2019/07/07/2019-07-07-debian-mirror)
\[3\][MANUAL DEPLOYMENT](https://docs.ceph.com/docs/master/install/manual-deployment/)
\[4\][ceph nautilus版本手动安装](https://www.cnblogs.com/netant-cg/p/10696205.html)
\[5\][CEPH-MGR ADMINISTRATOR’S GUIDE](https://docs.ceph.com/docs/master/mgr/administrator/#mgr-administrator-guide)
\[6\][NETWORK CONFIGURATION REFERENCE](https://docs.ceph.com/docs/mimic/rados/configuration/network-config-ref/)
\[7\][ADDING/REMOVING MONITORS](https://docs.ceph.com/docs/master/rados/operations/add-or-rm-mons/)