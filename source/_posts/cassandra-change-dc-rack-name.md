---
title: 更改cassandra集群数据中心和机架(rack)名
tags:
  - cassandra
id: '7401'
categories:
  - - Database
date: 2016-06-18 11:10:25
---


<!-- more -->
为了防止意外，cassandra不允许更改节点的数据中心和机架名字。会有类似错误提示:

```js
ERROR \[main\] 2016-06-18 11:01:40,730 CassandraDaemon.java:638 - Cannot start node if snitch's 
data center (DC1) differs from previous data center (datacenter1). Please fix the snitch configuration, 
decommission and rebootstrap this node or use the flag -Dcassandra. ignore_dc=true.
```

如果你知道你在做什么，可以添加两个JVM参数cassandra.ignore_rack和cassandra.ignore_dc来更改数据中心和机架的名字。

编辑/etc/cassandra/cassandra-env.sh文件,添加JVM参数:

```js
JVM_OPTS="$JVM_OPTS -Dcassandra.ignore_dc=true -Dcassandra.ignore_rack=true"
```

References:
\[1\][failed to start dse solr node](http://stackoverflow.com/questions/35056986/failed-to-start-dse-solr-node)

**\===
\[erq\]**