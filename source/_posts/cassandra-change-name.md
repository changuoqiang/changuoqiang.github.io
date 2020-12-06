---
title: cassandra集群更名
tags:
  - cassandra
id: '6870'
categories:
  - - Database
date: 2015-11-06 23:24:14
---


<!-- more -->
debian从官方源安装cassandra后，集群其实已经建立起来了，默认的集群名字为Test Cluster
直接更改/etc/cassandra/cassandra.yaml文件中的cluster_name,然后重新启动cassandra是行不通的。
有如下类似错误提示：
```js
ERROR \[main\] 2015-11-06 22:44:41,853 CassandraDaemon.java:635 - Fatal exception during initialization
org.apache.cassandra.exceptions.ConfigurationException: Saved cluster name Test Cluster != configured name imageCluster
```

这是因为集群的名字存储在系统表中，当与配置文件中的集群名字不同时，就会出现以上错误。**二者必须要一致才可以**。

```js
cqlsh> UPDATE system.local SET cluster_name = 'test' where key='local';
# flush the sstables to persist the update.
bash $ ./nodetool flush
```

修改完后还要flush一下节点。如果更改集群的名字，集群中所有的节点要逐一这样改过才行。

最好在集群初始化之初规划好集群的名字，不要随意更改集群名字。

References:
\[1\][Saved cluster name Test Cluster != configured name](http://stackoverflow.com/questions/22006887/cassandra-saved-cluster-name-test-cluster-configured-name)
\[2\][Cassandra says "ClusterName mismatch: oldClusterName != newClusterName" and refuses to start](https://wiki.apache.org/cassandra/FAQ#clustername_mismatch)
\[3\][Troubleshooting cassandra: Saved cluster name XXXX != configured name YYYY](http://www.tomas.cat/blog/en/troubleshooting-cassandra-saved-cluster-name-xxxx-configured-name-yyyy-en)

**\===
\[erq\]**