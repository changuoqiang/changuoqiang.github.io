---
title: cassandra替换当掉的种子节点
tags:
  - cassandra
id: '8704'
categories:
  - - Database
comments: false
date: 2019-08-30 14:55:49
---


<!-- more -->
分为两个步骤，首先用新的节点替换宕机的节点，其次把新节点提升为种子节点。

**替换故障节点**

1、`nodetool status`命令找到DN节点的ip地址比如192.168.0.82，后面会用到这个ip地址。

2、新节点安装与集群其他节点一样版本的cassandra，然后停止cassandra服务，并清除节点全部数据
```js
$ sudo systemctl stop cassandra
//$ sudo kill -sigterm <pid_of_cassandra>
//$ sudo kill -15 <pid_of_cassandra>
$ sudo rm -rf /var/lib/cassandra/*
```

3、设置参数文件cassandra.yaml和cassandra-rackdc.properties或者 cassandra-topology.properties

auto_bootstrap要设置为true，因为新节点要从种子节点获取数据。
cluster_name设置为要加入的集群的名字
linsten_address和rpc_address设置为本机ip
endpoint_snitch 要与集群其他节点一致，然后修改对应的属性文件
seed_provider只要要提供一个集群中现有的种子节点，但不要将新添加节点的地址加入，因为种子节点并不会bootstrap，等新节点bootstrap完成后再将新节点提升为种子节点。

可以提取集群中其他节点的配置文件，只对应修改新节点独有的参数即可。

4、使用 replace_address 选项启动新节点

修改/etc/cassandra/cassandra-env.sh 文件，添加选项：
```js
JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address=192.168.0.82"
```
这里的ip地址就是上面找到的要被替换的节点ip地址

5、启动新节点

等新节点bootstrap完成后再执行以下步骤，并且需要去掉replace_address选项

6、cassandra-rackdc.properties或cassandra-topology.properties文件中去掉被替换的节点

7、从集群中移除当掉的节点

```js
$ nodetool removenode <hostid>
```

nodetool status命令可以获取到节点的hostid

**提升为种子节点**

新添加节点bootstrap完成之后，可以提升为种子节点。

1、因为种子节点不能bootstrap，所以需要将其cassandra.yaml文件中的auto_bootstrap参数设置为false
2、在集群所有节点执行以下操作:
 将cassandra.yaml配置文件中的种子列表中去掉被替换的节点，将新添加节点的地址加入种子列表，然后重启节点。
注意不要并行操作，最好一个节点接一个节点的逐一操作。

References:
\[1\][Replacing a dead node or dead seed node](https://docs.datastax.com/en/archived/cassandra/2.2/cassandra/operations/opsReplaceNode.html)
\[2\][Replace a Dead Node in a Scylla Cluster](https://docs.scylladb.com/operating-scylla/procedures/cluster-management/replace_dead_node/)
\[3\][Replacing a dead seed node](https://docs.scylladb.com/operating-scylla/procedures/cluster-management/replace_seed_node/)
\[4\][nodetool removenode](https://docs.datastax.com/en/archived/cassandra/2.2/cassandra/tools/toolsRemoveNode.html)