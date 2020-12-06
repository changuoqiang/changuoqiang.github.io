---
title: 更新keyspace的复制因子
tags:
  - cassandra
id: '6560'
categories:
  - - Database
date: 2015-07-29 13:23:49
---


<!-- more -->
keyspace创建以后，仍然可以更改其复制因子，也就是keyspace中数据的复制份数是可以动态修改的。

cassandra集群的系统keyspace system_auth默认的replication factor是1，也就是其实是没有冗余的。如果这唯一的节点挂掉，就无法再登录到集群了。
因此官方文档推荐将其复制因子设置为每个数据中心的每一个节点。也就是将其复制到集群中的每一个节点上。

查看system_auth的复制因子

```js
cqlsh> DESC KEYSPACE system_auth
CREATE KEYSPACE system_auth WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'} AND durable_writes = true;
...
```

果然replication factor只有1,修改之：
```js
cqlsh> ALTER KEYSPACE system_auth WITH replication = {'class': 'NetworkTopologyStrategy', 'dc1':2,'dc2':2};
```

durable_writes参数用于设置写数据时是否写入commit log,如果设置为false,则写请求不会写commit log，会有丢失数据的风险。
此参数默认为true,即要写commit log,生产系统应该将该参数设置为true。

References:
\[1\][CREATE KEYSPACE](http://docs.datastax.com/en/cql/3.1/cql/cql_reference/create_keyspace_r.html)

**\===
\[erq\]**