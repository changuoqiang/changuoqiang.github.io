---
title: lxd clustering using ceph storage backend
tags:
  - Debian
id: '9056'
categories:
  - - GNU/Linux
date: 2019-11-11 16:50:44
---


<!-- more -->
lxd集群使用ceph后端共享存储，多个host共同管理一组容器，可以提高lxd容器的可用性，但当前版本的lxd集群功能还不够完善，不支持lxd容器在集群host之间live migration，故障迁移支持也不完善。
lxd集群部署ceph后端，数据丢失的风险大大降低，集群中host掉线，可以将lxd容器快速移动到其他host继续提供服务。

**bootstrap节点配置**
第一个节点加入一个存在的集群选no，集群剩余其他节点选择加入现有集群。一个集群共享一个ceph pool，不用的集群要使用不用的ceph pool。

**其他节点配置**
```js
$ sudo lxd init
Would you like to use LXD clustering? (yes/no) \[default=no\]: yes
What name should be used to identify this node in the cluster? \[default=web\]: 
What IP address or DNS name should be used to reach this node? \[default=10.100.0.80\]: 
Are you joining an existing cluster? (yes/no) \[default=no\]: yes
IP address or FQDN of an existing cluster node: 10.100.0.31
Cluster fingerprint: 79ec4bdfa32501a664b1adde03a2296f7d663a43676a422781668df1bec2ee12
You can validate this fingerprint by running "lxc info" locally on an existing node.
Is this the correct fingerprint? (yes/no) \[default=no\]: yes
Cluster trust password: 
All existing data is lost when joining a cluster, continue? (yes/no) \[default=no\] yes
Would you like a YAML "lxd init" preseed to be printed? (yes/no) \[default=no\]: 
```

**集群管理**
集群节点列表
```js
$ lxc cluster list
+---------+--------------------------+----------+--------+-------------------+
 NAME URL DATABASE STATE MESSAGE 
+---------+--------------------------+----------+--------+-------------------+
 vm02 https://10.100.0.33:8443 YES ONLINE fully operational 
+---------+--------------------------+----------+--------+-------------------+
 vmsvr02 https://10.100.0.31:8443 YES ONLINE fully operational 
+---------+--------------------------+----------+--------+-------------------+
 web https://10.100.0.80:8443 YES ONLINE fully operational 
+---------+--------------------------+----------+--------+-------------------+
```

容器静态迁移，假设容器名字为foo，将其移动到node2主机运行
```js
$ lxc stop foo
$ lxc move foo --target node2
```
容器所在主机故障时，可以使用lxc move移动容器到健康的节点继续运行，因为使用ceph,这个过程中没有主机间的数据拷贝。

如果lxd集群支持在线迁移和故障自动迁移就好用多了。

References:
\[1\][Clustering](https://lxd.readthedocs.io/en/latest/clustering/)
\[2\][LXD Clusters: A Primer](https://ubuntu.com/blog/lxd-clusters-a-primer)