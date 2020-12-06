---
title: 拆分sstables
tags:
  - cassandra
id: '8633'
categories:
  - - GNU/Linux
date: 2019-07-31 17:43:32
---


<!-- more -->
因为使用默认的compaction策略SizeTieredCompactionStrategy，导致产生了几个巨大的sstable，虽然已经更改为了LeveledCompactionStrategy策略，但是cassadra自动进行major compaction的时候因为需要巨大的空闲存储空间出错了
```js
WARN \[CompactionExecutor:6\] 2019-07-31 16:32:15,726 CompactionTask.java:298 - Not enough space for compaction, estimated sstables = 8643, expected write size = 2320284556243
ERROR \[CompactionExecutor:6\] 2019-07-31 16:32:15,727 CassandraDaemon.java:195 - Exception in thread Thread\[CompactionExecutor:6,1,main\]
java.lang.RuntimeException: Not enough space for compaction, estimated sstables = 8643, expected write size = 2320284556243
at org.apache.cassandra.db.compaction.CompactionTask.checkAvailableDiskSpace(CompactionTask.java:299) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.compaction.CompactionTask.runMayThrow(CompactionTask.java:119) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.utils.WrappedRunnable.run(WrappedRunnable.java:28) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.compaction.CompactionTask.executeInternal(CompactionTask.java:74) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.compaction.AbstractCompactionTask.execute(AbstractCompactionTask.java:59) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at org.apache.cassandra.db.compaction.CompactionManager$BackgroundCompactionCandidate.run(CompactionManager.java:257) ~\[apache-cassandra-2.2.14.jar:2.2.14\]
at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511) ~\[na:1.8.0_211\]
at java.util.concurrent.FutureTask.run(FutureTask.java:266) ~\[na:1.8.0_211\]
at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~\[na:1.8.0_211\]
at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) \[na:1.8.0_211\]
at java.lang.Thread.run(Thread.java:748) \[na:1.8.0_211\]
```

所有可以借助离线工具sstablesplit拆分大的sstables，拆分后使用LCS策略进行compaction就不需要那么多的空闲磁盘空间了。

**安装**

```js
$ sudo apt install cassandra-tools
```
cassandra-tools包中包含sstablesplit和sstablemeta等工具

**停止cassandra**

要注意，拆分sstable一定要在离线状态下进行
```js
$ sudo systemctl stop cassandra
```
或者
```js
$ sudo kill -sigterm <pid_of_cassandra>
```

**拆分**

sstablesplit帮助信息
```js
$ sstablesplit -h
usage: sstablesplit \[options\] <filename> \[<filename>\]*
--
Split the provided sstables files in sstables of maximum provided filesize (see option --size).
--
Options are:
 --debug display stack traces
 -h,--help display this help message
 --no-snapshot don't snapshot the sstables before splitting
 -s,--size <size> maximum size in MB for the output sstables (default:
 50)
```

sstablesplit按给定的文件尺寸拆分指定的sstables，可以一次指定多个。注意文件权限的问题，使用cassandra用户来执行操作，下面是一个例子，：
```js
$ sudo -u cassandra sstablesplit -s 256 /var/lib/cassandra/data/keyspace/table-xxxx/la-xxxx-big-Data.db
```

拆分完成后cassandra可以重新上线。

sstablesplit设定的默认堆内存只有256M，拆分过程中出现了OOM错误:
```js
Exception in thread "main" java.lang.OutOfMemoryError: Direct buffer memory
 at java.nio.Bits.reserveMemory(Bits.java:694)
 at java.nio.DirectByteBuffer.<init>(DirectByteBuffer.java:123)
 at java.nio.ByteBuffer.allocateDirect(ByteBuffer.java:311)
 at org.apache.cassandra.io.compress.BufferType$2.allocate(BufferType.java:35)
 at org.apache.cassandra.io.compress.CompressedSequentialWriter.<init>(CompressedSequentialWriter.java:70)
 at org.apache.cassandra.io.util.SequentialWriter.open(SequentialWriter.java:168)
 at org.apache.cassandra.io.sstable.format.big.BigTableWriter.<init>(BigTableWriter.java:75)
 at org.apache.cassandra.io.sstable.format.big.BigFormat$WriterFactory.open(BigFormat.java:107)
 at org.apache.cassandra.io.sstable.format.SSTableWriter.create(SSTableWriter.java:84)
 at org.apache.cassandra.db.compaction.writers.MaxSSTableSizeWriter.append(MaxSSTableSizeWriter.java:83)
 at org.apache.cassandra.db.compaction.CompactionTask.runMayThrow(CompactionTask.java:186)
 at org.apache.cassandra.utils.WrappedRunnable.run(WrappedRunnable.java:28)
 at org.apache.cassandra.db.compaction.CompactionTask.executeInternal(CompactionTask.java:74)
 at org.apache.cassandra.db.compaction.AbstractCompactionTask.execute(AbstractCompactionTask.java:59)
 at org.apache.cassandra.db.compaction.SSTableSplitter.split(SSTableSplitter.java:44)
 at org.apache.cassandra.tools.StandaloneSplitter.main(StandaloneSplitter.java:156)
```

修改/usr/bin/sstablesplit脚本中的`MAX_HEAP_SIZE="256M"`为`MAX_HEAP_SIZE="8192M"`，重启一下cassandra会自动清除掉临时的sstables，`nodetool clearsnapshot`清除掉sstablesplit自动生成的快照，最后停止cassandra再重新拆分。

**删除再repair**

拆分大sstable需要离线操作，重新上线后应该需要repair,其实还有一种最小离线时间的方法，那就是"停止节点->删除大sstable->启动节点->repair节点"，这也是一种可行的方法。

References:
\[1\][sstablesplit](https://docs.datastax.com/en/archived/cassandra/2.2/cassandra/tools/toolsSSTableSplit.html)
\[2\][FAQ - How to split large SSTables on another server](https://support.datastax.com/hc/en-us/articles/115005668426-FAQ-How-to-split-large-SSTables-on-another-server)
\[3\][do sstablesplit on the side](https://stackoverflow.com/questions/42042665/do-sstablesplit-on-the-side)