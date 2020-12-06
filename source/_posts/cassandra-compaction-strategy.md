---
title: cassandra compaction strategy
tags:
  - cassandra
  - Debian
id: '8422'
categories:
  - - Database
  - - GNU/Linux
date: 2019-06-22 11:29:53
---


<!-- more -->
cassandra更新或删除rows时并不会真正的更新或删除原先的rows，只是添加新的rows并将原rows打上tombstone标记，所以cassandra需要周期性的运行compaction来整理数据库。

compaction有三种策略，SizeTieredCompactionStrategy (STCS)、LeveledCompactionStrategy (LCS)和DateTieredCompactionStrategy (DTCS)，默认的compaction策略是STCS。

当前使用的集群在compaction时出现错误:
```js
ERROR \[CompactionExecutor:41367\] 2019-06-22 11:22:02,063 CassandraDaemon.java:185 - Exception in thread Thread\[CompactionExecutor:41367,1,main\]
java.lang.RuntimeException: Not enough space for compaction, estimated sstables = 1, expected write size = 678107716200
 at org.apache.cassandra.db.compaction.CompactionTask.checkAvailableDiskSpace(CompactionTask.java:275) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at org.apache.cassandra.db.compaction.CompactionTask.runMayThrow(CompactionTask.java:118) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at org.apache.cassandra.utils.WrappedRunnable.run(WrappedRunnable.java:28) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at org.apache.cassandra.db.compaction.CompactionTask.executeInternal(CompactionTask.java:74) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at org.apache.cassandra.db.compaction.AbstractCompactionTask.execute(AbstractCompactionTask.java:59) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at org.apache.cassandra.db.compaction.CompactionManager$BackgroundCompactionCandidate.run(CompactionManager.java:256) ~\[apache-cassandra-2.2.6.jar:2.2.6\]
 at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511) ~\[na:1.8.0_66\]
 at java.util.concurrent.FutureTask.run(FutureTask.java:266) ~\[na:1.8.0_66\]
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142) ~\[na:1.8.0_66\]
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617) \[na:1.8.0_66\]
 at java.lang.Thread.run(Thread.java:745) \[na:1.8.0_66\]

```

需要600多G的空间来compaction，昏！

是的，有一个数据文件达到了600多G，默认的SizeTieredCompactionStrategy压缩策略需要比数据文件大一些的空闲空间来执行compaction，但是磁盘剩余空间只有不到400G了，so.

"SizeTieredCompactionStrategy Compaction requires a lot of temporary space: In worst case, we need to merge all existing SSTables into one, so we need half the disk to be empty to write the output file and only later can delete the old SSTables"

使用STCS compaction策略，cassandra节点一般要保持50%以上的剩余空间，对于大数据集来讲，太可怕了，几个T的数据，需要额外几个T的剩余空间才能正常运行, WTF!

STCS策略会在达到min_threshold(默认为4)时，将这几个SSTABLE合并为一个大的SSTABLE，这个SSTABLE并不会有上限大小的限制，初期数据少的时候并不会有什么问题。但是目前2T的节点，已经有3个600G的SSTABLE了，下一步compaction要生成单个2T以上的SSTABLE了，看来默认的STCS策略并不太适合大数据集。

LeveledCompactionStrategy压缩策略只使用很少的空间来执行压缩，只要10 * sstable_size_in_mb的空间，目前默认的sstable_size_in_mb为160MB，10倍的话差不多2个G的样子，不过官方也讲最好保持10G以上的剩余空间。

sstable_size_in_mb是LeveledCompactionStrategy bean的一个RW attribute来控制compaction后生成的sstable的大小，一般使用当前默认的160M或设置为200M都是适合的。对于大数据集LCS会生成数量很多的sstables。

**当前表的compaction**

```js
cqlsh> desc TABLE image;
CREATE TABLE reis.image (
 id text PRIMARY KEY,
 content blob,
 name text
) WITH bloom_filter_fp_chance = 0.01
 AND caching = '{"keys":"ALL", "rows_per_partition":"NONE"}'
 AND comment = ''
 AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
 AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
 AND dclocal_read_repair_chance = 0.1
 AND default_time_to_live = 0
 AND gc_grace_seconds = 864000
 AND max_index_interval = 2048
 AND memtable_flush_period_in_ms = 0
 AND min_index_interval = 128
 AND read_repair_chance = 0.0
 AND speculative_retry = '99.0PERCENTILE';
```

果然是SizeTieredCompactionStrategy

**修改compaction策略**
```js
cqlsh>ALTER TABLE image WITH compaction = { 'class': 'org.apache.cassandra.db.compaction.LeveledCompactionStrategy','sstable_size_in_mb':'200'}
```

这里虽然将compaction策略由STCS修改成了LCS，但是要完成一次完整的转换仍然需要巨大的剩余磁盘空间，因为在完整的转换为LCS之前，那些大的sstable,当前有3个600G以上的，会一直保留在磁盘上，完整转换完毕后才能删除，只剩下数量众多的小sstabel，之后的compaction就不会需要这么多的剩余磁盘空间了。

official documnet: "While a merge of several SSTables is ongoing, the request path continues to read the old SSTables. Ideally, the old SSTables would be deleted as soon as the merge is done, but we must not delete an SSTable that still has in-progress reads."

还有一个问题，直接alter table修改compaction策略，会使所有的集群节点开始转换到LCS的compaction动作，集群的负载会高居不下，所以也可以使用jmx来逐个节点的迁移到LCS策略。

当然也可以关闭节点的自动compaction

```js
$ nodetool disableautocompation -- keyspacename tablename 
```

修改完table的compaction策略后，手动逐个执行compaction

```js
$ nodetool compact -- keyspacename tablename
```

最后再打开autocompaction

```js
$ nodetool enableautocompaction
```

**创建新表时**
可以直接指定compaction策略

```js
CREATE TABLE reis.image (
 id text PRIMARY KEY,
 content blob,
 name text
) WITH compaction = { 'class': 'org.apache.cassandra.db.compaction.LeveledCompactionStrategy'}
```

References:
\[1\][How is data maintained?](https://docs.datastax.com/en/archived/cassandra/2.2/cassandra/dml/dmlHowDataMaintain.html)
\[2\][Leveled Compaction in Apache Cassandra](https://www.datastax.com/dev/blog/leveled-compaction-in-apache-cassandra)
\[3\][When to Use Leveled Compaction](https://www.datastax.com/dev/blog/when-to-use-leveled-compaction)
\[4\][Cassandra 的压缩策略STCS，LCS 和 DTCS](https://www.cnblogs.com/didda/p/4728588.html)
\[5\][介绍CASSANDRA中的压缩](https://www.cnblogs.com/gpcuster/archive/2010/05/27/1745859.html)
\[6\][Cancelling ongoing compaction jobs in Cassandra](https://stackoverflow.com/questions/45419041/cancelling-ongoing-compaction-jobs-in-cassandra)
\[7\][nodetool setcompactionthreshold](https://docs.datastax.com/en/archived/cassandra/3.0/cassandra/tools/toolsSetCompactionThreshold.html)
\[8\][被忽视的Compaction策略-有关NoSQL Compaction策略的一点思考](https://www.cnblogs.com/sing1ee/archive/2012/05/24/2765042.html)
\[9\][Cassandra control SSTable size](https://stackoverflow.com/questions/29392153/cassandra-control-sstable-size)
\[10\][SSTable compaction and compaction strategies](https://github.com/scylladb/scylla/wiki/SSTable-compaction-and-compaction-strategies)