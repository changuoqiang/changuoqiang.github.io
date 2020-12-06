---
title: 文件系统权限不足导致cassandra无法启动一例
tags:
  - cassandra
id: '6207'
categories:
  - - GNU/Linux
date: 2015-03-24 10:53:02
---


<!-- more -->
集群中的某一node无法启动,nodetool status输出如下：
```js
error: No nodes present in the cluster. Has this node finished starting up?
-- StackTrace --
java.lang.RuntimeException: No nodes present in the cluster. Has this node finished starting up?
 at org.apache.cassandra.dht.Murmur3Partitioner.describeOwnership(Murmur3Partitioner.java:129)
 at org.apache.cassandra.service.StorageService.getOwnership(StorageService.java:3856)
 at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:497)
 at sun.reflect.misc.Trampoline.invoke(MethodUtil.java:71)
 at sun.reflect.GeneratedMethodAccessor2.invoke(Unknown Source)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:497)
 at sun.reflect.misc.MethodUtil.invoke(MethodUtil.java:275)
 at com.sun.jmx.mbeanserver.StandardMBeanIntrospector.invokeM2(StandardMBeanIntrospector.java:112)
 at com.sun.jmx.mbeanserver.StandardMBeanIntrospector.invokeM2(StandardMBeanIntrospector.java:46)
 at com.sun.jmx.mbeanserver.MBeanIntrospector.invokeM(MBeanIntrospector.java:237)
 at com.sun.jmx.mbeanserver.PerInterface.getAttribute(PerInterface.java:83)
 at com.sun.jmx.mbeanserver.MBeanSupport.getAttribute(MBeanSupport.java:206)
 at com.sun.jmx.interceptor.DefaultMBeanServerInterceptor.getAttribute(DefaultMBeanServerInterceptor.java:647)
 at com.sun.jmx.mbeanserver.JmxMBeanServer.getAttribute(JmxMBeanServer.java:678)
 at javax.management.remote.rmi.RMIConnectionImpl.doOperation(RMIConnectionImpl.java:1443)
 at javax.management.remote.rmi.RMIConnectionImpl.access$300(RMIConnectionImpl.java:76)
 at javax.management.remote.rmi.RMIConnectionImpl$PrivilegedOperation.run(RMIConnectionImpl.java:1307)
 at javax.management.remote.rmi.RMIConnectionImpl.doPrivilegedOperation(RMIConnectionImpl.java:1399)
 at javax.management.remote.rmi.RMIConnectionImpl.getAttribute(RMIConnectionImpl.java:637)
 at sun.reflect.GeneratedMethodAccessor9.invoke(Unknown Source)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:497)
 at sun.rmi.server.UnicastServerRef.dispatch(UnicastServerRef.java:323)
 at sun.rmi.transport.Transport$1.run(Transport.java:200)
 at sun.rmi.transport.Transport$1.run(Transport.java:197)
 at java.security.AccessController.doPrivileged(Native Method)
 at sun.rmi.transport.Transport.serviceCall(Transport.java:196)
 at sun.rmi.transport.tcp.TCPTransport.handleMessages(TCPTransport.java:568)
 at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(TCPTransport.java:826)
 at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.lambda$run$78(TCPTransport.java:683)
 at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler$$Lambda$1/294183905.run(Unknown Source)
 at java.security.AccessController.doPrivileged(Native Method)
at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(TCPTransport.java:682)
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
 at java.lang.Thread.run(Thread.java:745)
```

/var/log/cassandra/system.log有如下错误信息:
```js
ERROR \[MemtableFlushWriter:3\] 2015-03-23 18:26:37,996 CassandraDaemon.java:153 - Exception in thread Thread\[MemtableFlushWriter:3,5,main\]
java.lang.RuntimeException: java.io.FileNotFoundException: /var/lib/cassandra/data/image/image-2a19ce908f1f11e481c2a9fac1d00bce/image-image-tmp-ka--> 2-Index.db (Permission denied)
 at org.apache.cassandra.io.util.SequentialWriter.<init>(SequentialWriter.java:75) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.io.util.SequentialWriter.open(SequentialWriter.java:104) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.io.util.SequentialWriter.open(SequentialWriter.java:99) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.io.sstable.SSTableWriter$IndexWriter.<init>(SSTableWriter.java:552) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.io.sstable.SSTableWriter.<init>(SSTableWriter.java:134) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.db.Memtable$FlushRunnable.createFlushWriter(Memtable.java:390) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.db.Memtable$FlushRunnable.writeSortedContents(Memtable.java:329) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.db.Memtable$FlushRunnable.runWith(Memtable.java:313) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.io.util.DiskAwareRunnable.runMayThrow(DiskAwareRunnable.java:48) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at org.apache.cassandra.utils.WrappedRunnable.run(WrappedRunnable.java:28) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at com.google.common.util.concurrent.MoreExecutors$SameThreadExecutorService.execute(MoreExecutors.java:297) ~\[guava-16.0.jar:na\]
 at org.apache.cassandra.db.ColumnFamilyStore$Flush.run(ColumnFamilyStore.java:1037) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145) ~\[na:1.7.0_65\]
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615) ~\[na:1.7.0_65\]
 at java.lang.Thread.run(Thread.java:745) ~\[na:1.7.0_65\]
Caused by: java.io.FileNotFoundException: /var/lib/cassandra/data/image/image-2a19ce908f1f11e481c2a9fac1d00bce/image-image-tmp-ka-2-Index.db -> (Permission denied)
 at java.io.RandomAccessFile.open(Native Method) ~\[na:1.7.0_65\]
 at java.io.RandomAccessFile.<init>(RandomAccessFile.java:241) ~\[na:1.7.0_65\]
 at org.apache.cassandra.io.util.SequentialWriter.<init>(SequentialWriter.java:71) ~\[apache-cassandra-2.1.2.jar:2.1.2\]
 ... 14 common frames omitted

```
看错误信息为文件系统访问权限问题所致，查看/var/lib/cassandra/data/image,果然此目录的属主和组都成了root
```js
# chown -R cassandra:cassandra /var/lib/cassandra/data/image
```

重新启动cassandra成功。

**\===
\[erq\]**