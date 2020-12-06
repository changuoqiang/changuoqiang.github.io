---
title: cassandra修复损坏的sstables
tags:
  - cassandra
id: '8542'
categories:
  - - Database
  - - GNU/Linux
date: 2019-07-15 15:21:08
---


<!-- more -->
由于磁盘阵列Unreadable Sectors错误，强制修复后导致cassandra的一个sstable损坏，cassandra启动时报错:
```js
ERROR \[CompactionExecutor:2\] 2019-07-15 15:03:27,161 DefaultFSErrorHandler.java:92 - Exiting forcefully due to file system exception on startup, disk failure policy "stop"
org.apache.cassandra.io.FSReadError: org.apache.cassandra.io.sstable.CorruptSSTableException: Corrupted: /mnt/data/cassandra/reis/image-6a85c44086a711e5aef4b53617129a2a/lb-47344-big-Data.db
at org.apache.cassandra.io.util.RandomAccessReader.readBytes(RandomAccessReader.java:365) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.utils.ByteBufferUtil.read(ByteBufferUtil.java:361) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.utils.ByteBufferUtil.readWithLength(ByteBufferUtil.java:324) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.ColumnSerializer.deserializeColumnBody(ColumnSerializer.java:132) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.OnDiskAtom$Serializer.deserializeFromSSTable(OnDiskAtom.java:92) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.AbstractCell$1.computeNext(AbstractCell.java:52) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
```
lb-47344-big-Data.db这个sstable被破坏了。
因为节点已经无法启动了，所以下面的尝试无可避免的失败了

```js
$ nodetool scrub
nodetool: Failed to connect to '127.0.0.1:7199' - ConnectException: 'Connection refused (Connection refused)'.
```

尝试离线修复，如果数据量很大，记得开启screen会话
```js
$ sudo -u cassandra sstablescrub reis image
```
注意cassandra数据目录的权限，这里使用cassandra用户来执行scrub
执行结束后，删除掉已经损坏的sstable，scrub时cassandra会将损坏的sstable保持原样
```js
$ sudo mv lb-47344* backups/
```

启动cassandra
```js
$ sudo systemctl start cassandra
```

确认系统运行正常
```js
$ nodetool status 
```

之后可以删除sstablescrub自动创建的快照，释放掉已经无用的sstables
```js
$ nodetool clearsnapshot
Requested clearing snapshot(s) for \[all keyspaces\]
```

最后需要repair本节点，修复节点数据
```js
$ nodetool repair -local -- reis image
```

References:
\[1\][sstablescrub](https://docs.datastax.com/en/dse/5.1/dse-admin/datastax_enterprise/tools/toolsSStables/toolsSSTableScrub.html)
\[2\][Dealing with a corrupt SSTable in Cassandra](https://engineering.gosquared.com/dealing-corrupt-sstable-cassandra)
\[3\][So You Have A Broken Cassandra SSTable File?](https://blog.pythian.com/so-you-have-a-broken-cassandra-sstable-file/)