---
title: 初始化一个单数据中心多节点cassandra集群
tags: []
id: '6879'
categories:
  - - GNU/Linux
date: 2015-11-07 08:33:45
---


<!-- more -->
**集群信息**

集群的名字叫fooCluser,总共有两个节点在同一个数据中心。每个节点位于不同的机架。
数据中心的名字叫DC1,两个机架的名字分别为RAC1和RAC2。
两个节点的IP分别为192.168.0.100和192.168.0.101。
因为只有两个节点，两个节点都作为种子节点。
注意：要保证所有的节点安装相同版本的Cassandra

**操作步骤**

1.  停止节点
debian包系统安装的cassandra,安装完成后处于运行状态，而且有默认的集群Test Cluster。
停止所有的集群节点
```js
$ sudo service cassandra stop
```
2.  清除数据
清除默认的集群(Test Cluster)信息
```js
$ sudo rm -rf /var/lib/cassandra/data/system/*
```
3.  修改cassandra.yaml配置
核心的参数设置如下：
```js
cluster_name: 'fooCluster'
seed_provider:
 - class_name: org.apache.cassandra.locator.SimpleSeedProvider
 parameters:
 - seeds: "192.168.0.100,192.168.0.101"

listen_address: 192.168.0.100
endpoint_snitch: GossipingPropertyFileSnitch
auto_bootstrap: false
```

不同的节点listen_address是不同的。如果需要开启thrift rpc server,还需设置rpc相关参数，对于当前版本的cassandra，rpc并不是必须的，只使用cql是可行的。

当初始化一个没有数据的新集群时，要设置auto_bootstrap参数为false。auto_bootstrap参数在cassandra.yaml中是没有的，其默认值为true,需要手动添加。种子节点是不需要bootstrap的，只有向集群中添加新的节点时，新加入的节点启动时需要bootstrap。
4.  机架感应配置
因为使用了GossipingPropertyFileSnitch，所以对应的数据中心、机架配置文件为cassandra-rackdc.properties
对于192.168.0.100节点，此文件内容设置为:
```js
dc = DC1
rack= RAC1
```
而对于192.168.0.101节点，则设置为:
```js
dc = DC1
rack= RAC2
```

注意：cassandra集群内的多个节点是可以放置于同一个机架内的，只不过cassandra认为，同一个机架内的节点容易一起失败，所以要尽量将数据分布到不同机架内的节点上。
5.  启动节点
先启动种子节点，每次启动一个，顺序启动所有种子节点后，再顺序启动其他节点。
```js
$ sudo service cassandra start
```
6.  查看集群状态
```js
$ nodetool status
$ nodetool describecluster
```

References:
\[1\][Initializing a multiple node cluster (single data center)](http://docs.datastax.com/en/cassandra/2.0/cassandra/initialize/initializeSingleDS.html)

**\===
\[erq\]**