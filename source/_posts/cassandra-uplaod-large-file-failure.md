---
title: Cassandra上传大文件失败
tags:
  - cassandra
id: '6482'
categories:
  - - Database
date: 2015-06-05 19:30:50
---


<!-- more -->
上传大文件到Cassandra时失败，/var/log/cassandra/system.log中有如下错误：
```js
WARN \[SharedPool-Worker-2\] 2015-05-26 10:29:56,900 AbstractTracingAwareExecutorService.java:169 - Uncaught exception on thread Thread\[SharedPool-Worker-2,5,main\]: {}
java.lang.RuntimeException: java.lang.IllegalArgumentException: Mutation of 25802415 bytes is too large for the maxiumum size of 16777216
 at org.apache.cassandra.service.StorageProxy$LocalMutationRunnable.run(StorageProxy.java:2219) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:471) ~\[na:1.7.0_79\]
 at org.apache.cassandra.concurrent.AbstractTracingAwareExecutorService$FutureTask.run(AbstractTracingAwareExecutorService.java:164) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.concurrent.SEPWorker.run(SEPWorker.java:105) \[apache-cassandra-2.1.5.jar:2.1.5\]
 at java.lang.Thread.run(Thread.java:745) \[na:1.7.0_79\]
Caused by: java.lang.IllegalArgumentException: Mutation of 25802415 bytes is too large for the maxiumum size of 16777216
 at org.apache.cassandra.db.commitlog.CommitLog.add(CommitLog.java:221) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.db.Keyspace.apply(Keyspace.java:368) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.db.Keyspace.apply(Keyspace.java:348) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.db.Mutation.apply(Mutation.java:214) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.service.StorageProxy$7.runMayThrow(StorageProxy.java:1036) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 at org.apache.cassandra.service.StorageProxy$LocalMutationRunnable.run(StorageProxy.java:2215) ~\[apache-cassandra-2.1.5.jar:2.1.5\]
 ... 4 common frames omitted
```

这是因为cassandra.yaml配置文件中默认配置的单个提交日志文件的大小为32MB,而Cassandra允许的最大写尺寸是其一半，也就是16MB,亦即是上述错误中提示的16777216

```js
commitlog_segment_size_in_mb: 32
```

Cassandra并不是为大文件设计的，所以最好适当的限制一下写尺寸，或者上传文件的大小，而不是调整系统参数。

**\===
\[erq\]**