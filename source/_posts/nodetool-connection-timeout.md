---
title: nodetool连接超时错误
tags:
  - cassandra
  - Java
id: '6101'
categories:
  - - Database
date: 2014-12-27 22:05:52
---


<!-- more -->
nodetool查看本地集群状态时,N久以后出现无法连接、连接超时的错误提示:
```js
$ nodetool status
nodetool: Failed to connect to '127.0.0.1:7199' - ConnectException: 'Connection timed out'.
```

经排查为/etc/hosts文件配置错误所致,文件中实际的主机名(不是localhost)对应的ip地址解析行设置错误,这是由于主机ip地址更换后未及时更新hosts文件所致。更改为正确的ip地址类似如下：
```js
192.168.1.104 yoga.localdomain yoga
```

然后重新启动cassandra服务
```js
$ sudo /etc/init.d/cassandra restart
\[ ok \] Restarting cassandra (via systemctl): cassandra.service.
```
或者
```js
$ sudo systemctl restart cassandra.service
```

然后再重新执行
```js
$ nodetool status
Datacenter: datacenter1
=======================
Status=Up/Down
/ State=Normal/Leaving/Joining/Moving
-- Address Load Tokens Owns (effective) Host ID Rack
UN 127.0.0.1 139.45 KB 256 100.0% 27e51705-c13d-4f4b-b4f8-de3759fcd895 rack1
```

如果cassandra尚未完全启动时就执行该命令，会有异常抛出，类似如下：
```js
$ nodetool status
error: No nodes present in the cluster. Has this node finished starting up?
-- StackTrace --
java.lang.RuntimeException: No nodes present in the cluster. Has this node finished starting up?
 at org.apache.cassandra.dht.Murmur3Partitioner.describeOwnership(Murmur3Partitioner.java:129)
 at org.apache.cassandra.service.StorageService.effectiveOwnership(StorageService.java:3762)
 at org.apache.cassandra.service.StorageService.effectiveOwnership(StorageService.java:103)
 at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:606)
 at sun.reflect.misc.Trampoline.invoke(MethodUtil.java:75)
 at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:606)
 at sun.reflect.misc.MethodUtil.invoke(MethodUtil.java:279)
 at com.sun.jmx.mbeanserver.StandardMBeanIntrospector.invokeM2(StandardMBeanIntrospector.java:112)
 at com.sun.jmx.mbeanserver.StandardMBeanIntrospector.invokeM2(StandardMBeanIntrospector.java:46)
 at com.sun.jmx.mbeanserver.MBeanIntrospector.invokeM(MBeanIntrospector.java:237)
 at com.sun.jmx.mbeanserver.PerInterface.invoke(PerInterface.java:138)
 at com.sun.jmx.mbeanserver.MBeanSupport.invoke(MBeanSupport.java:252)
 at com.sun.jmx.interceptor.DefaultMBeanServerInterceptor.invoke(DefaultMBeanServerInterceptor.java:819)
 at com.sun.jmx.mbeanserver.JmxMBeanServer.invoke(JmxMBeanServer.java:801)
 at javax.management.remote.rmi.RMIConnectionImpl.doOperation(RMIConnectionImpl.java:1487)
 at javax.management.remote.rmi.RMIConnectionImpl.access$300(RMIConnectionImpl.java:97)
 at javax.management.remote.rmi.RMIConnectionImpl$PrivilegedOperation.run(RMIConnectionImpl.java:1328)
 at javax.management.remote.rmi.RMIConnectionImpl.doPrivilegedOperation(RMIConnectionImpl.java:1420)
 at javax.management.remote.rmi.RMIConnectionImpl.invoke(RMIConnectionImpl.java:848)
at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
 at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
 at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
 at java.lang.reflect.Method.invoke(Method.java:606)
 at sun.rmi.server.UnicastServerRef.dispatch(UnicastServerRef.java:322)
 at sun.rmi.transport.Transport$1.run(Transport.java:177)
 at sun.rmi.transport.Transport$1.run(Transport.java:174)
 at java.security.AccessController.doPrivileged(Native Method)
 at sun.rmi.transport.Transport.serviceCall(Transport.java:173)
 at sun.rmi.transport.tcp.TCPTransport.handleMessages(TCPTransport.java:556)
 at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run0(TCPTransport.java:811)
 at sun.rmi.transport.tcp.TCPTransport$ConnectionHandler.run(TCPTransport.java:670)
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
 at java.lang.Thread.run(Thread.java:745)
```

Mac OS X平台上/etc/hosts文件中根本就不设置主机名对应的IP地址解析,而出现的错误提示也略有不同:
```js
nodetool: Failed to connect to '127.0.0.1:7199' - ConnectException: 'Operation timed out'.
```
解决办法也是一样的,对于动态ip的客户端测试环境而言,直接将主机名对应的ip设置为127.0.0.1亦可：
```js
127.0.0.1 mba
```
重新加载cassandra就可以了
```js
$ launchctl unload /usr/local/opt/cassandra/homebrew.mxcl.cassandra.plist
$ launchctl load /usr/local/opt/cassandra/homebrew.mxcl.cassandra.plist
```

 **===
\[erq\]**