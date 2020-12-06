---
title: cassandra集群添加新的数据中心
tags:
  - cassandra
id: '6874'
categories:
  - - Database
date: 2015-11-06 23:29:46
---


<!-- more -->
可以为现有集群添加一个新的数据中心，要求新添加数据中心的所有节点，要安装与原集群节点相同的cassandra版本。

操作步骤:

1.  使用NetworkTopologyStrategy
系统keyspace并没有使用NetworkTopologyStrategy策略，用户的keyspace如果要使用多数据中心就要使用NetworkTopologyStrategy策略。
2.  停止节点
debian包系统安装的cassandra,安装完成后处于运行状态，而且有默认的集群Test Cluster，因为需要逐一停止新数据中心节点，并清除默认安装的信息：
```js
$ sudo service cassandra stop
$ sudo rm -rf /var/lib/cassandra/*
```
3.  配置cassandra.yaml
新数据中心节点cassandra.yaml文件中添加`auto_bootstrap: false`。auto_bootstrap默认是true，并且没有在cassandra.yaml文件中列出来。设置其他参数，比如seeds和endpoint_snitch，匹配原有集群的配置。num_tokens参数可以设置与原集群一致，但不要设置initial_token参数。
5.  编辑相关配置文件
GossipingPropertyFileSnitch使用的配置文件cassandra-rackdc.properties中添加新数据中心和机架。
6.  客户端配置
如果使用DataStax驱动,负载均衡策略设置为DCAwareRoundRobinPolicy,其他驱动做相应修改，以使客户端与新的集群相适应。
如果原来使用一致性级别QUORUM，那么现在重新审视一下，是否LOCAL_QUORUM或者EACH_QUORUM一致性级别更适合现在的多数据中心集群。
7.  新节点启动cassandra
8.  新节点数据同步
当集群中的所有节点都正常运行之后，修改keyspace的属性以便将数据分布到新的数据中心，比如:
```js
cqlsh> ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1':2,'DC2':1};
cqlsh> ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1':2,'DC2':1};
cqlsh> ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1':2,'DC2':1};
```
在原数据中心或新数中心的任意节点上执行皆可。

然后新添加数据中心的每一个节点上运行nodetool rebuild,并指定原数据中心的名字:
```js
$ nodetool rebuild -- name_of_existing_data_center
```
多个节点可以同时运行此命令。

9.  还原auto_bootstrap参数
新添数据中心节点的配置文件cassandra.yaml去掉auto_bootstrap参数或者将其值设置为true。如果新添加的节点是种子节点，则此参数应设置为false,种子节点不需要bootstrap。

References:
\[1\][Adding a data center to a cluster](http://docs.datastax.com/en/cassandra/2.2/cassandra/operations/opsAddDCToCluster.html)
\[2\][Using multiple network interfaces](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/configuration/configMultiNetworks.html)
\[3\][Apache Cassandra Deployed on Private and Public Networks](https://www.instaclustr.com/apache-cassandra-deployed-on-private-and-public-networks/)
\[4\][Adding nodes to an existing cluster](https://docs.datastax.com/en/cassandra-oss/2.2/cassandra/operations/opsAddNodeToCluster.html)

**\===
\[erq\]**