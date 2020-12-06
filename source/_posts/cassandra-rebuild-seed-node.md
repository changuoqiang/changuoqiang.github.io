---
title: cassandra rebuild 种子节点
tags:
  - cassandra
id: '8120'
categories:
  - - GNU/Linux
date: 2018-12-02 11:49:55
---


<!-- more -->
cassandra 2.2.6环境，有一台种子节点硬件故障，半年以后才修复重新上线。
其数据已经落后太多，而cassandra并不会在其重新上线后自动进行数据同步。
nodetool repair应该可以使其数据重新同步，但是那速度是无法忍受的，因此使用nodetool rebuild来重建其数据。

首先停止cassandra服务

```js
$ sudo systemctl stop cassandra
```
或者
```js
$ sudo service cassandra stop
```

然后删除掉数据目录下system和用户keyspace的所有数据
 $ sudo rm -rf /var/lib/cassandra/data/system/*
$ sudo rm -rf /var/lib/cassandra/data/your_keyspaces/* 
```js
$ sudo rm -rf /var/lib/cassandra/*
```

如果不清除用户的keyspace，rebuild的时候并不会自动清除，而且rebuild是全量而不是增量，所以那些数据会成为垃圾数据，如果数据量很大，应该提前清除掉。

对于种子节点，还应该确认auto_bootstrap参数已经设置为false。

启动cassandra服务，执行rebuild

```js
$ sudo service cassandra start
$ nodetool rebuild -- name_of_existing_data_center
```

指定源数据中心时，要指定与当前节点所在数据中心不同的数据中心。

查看rebuild进度
```js
$ watch -n 10 'nodetool netstats grep "Receiving\\Sending" gawk {'"'"' print $1" - "$11/$4*100"% Complete, "($4-$11)/1024/1024/1024" GB remaining" '"'"'}'
```

等nodetool rebuild结束重建就算完成了，其实这与添加新的节点差别不大,不过就是原来的环境，所有的配置都不用动罢了。

同步完成后可以看看用户表的统计信息：

```js
$ nodetool tablestats keyspace_name.table_name
```

**updated:06/22/2019**

这次种子节点下线重做RAID，系统重新安装，cassandra版本为2.2.14

rebuild的时候提示：

```js
$nodetool rebuild -- DC2

nodetool: Unable to find sufficient sources for streaming range (2952258499581076301,2996932853512195336\] in keyspace system_traces
See 'nodetool help' or 'nodetool help <command>'.
```

需要将keyspace system_traces的replication strategy设置为NetworkTopologyStrategy并将其分布到所有的数据中心，其默认设置为SimpleStrategy

```js
cqlsh> ALTER KEYSPACE system_traces WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1':2,'DC2':1};
```

keyspace system_distributed的replication strategy也应该设置为NetworkTopologyStrategy并将其分布到所有的数据中心

```js
cqlsh> ALTER KEYSPACE system_distributed WITH replication = {'class': 'NetworkTopologyStrategy', 'DC1':2,'DC2':1};
```

References:
\[1\][Unable to find sufficient sources for streaming range (,\] in keyspace](https://support.datastax.com/hc/en-us/articles/213145066-Unable-to-find-sufficient-sources-for-streaming-range-token-a-token-b-in-keyspace-some-keyspace-) 
\[2\][Unable to find sufficient sources for streaming range in keyspace](https://stackoverflow.com/questions/46723429/unable-to-find-sufficient-sources-for-streaming-range-in-keyspace)
\[3\][system_distributed and system_traces keyspaces use hard-coded replication factors](https://issues.apache.org/jira/browse/CASSANDRA-11098)