---
title: cassandra 2.2在jdk8最新版本nodetool报错
date: 2025-05-18 20:49:09
tags:
  - Cassandra
categories:
  - - GNU/Linux
---

新安装的cassandra 2.2.19运行`nodetool status`时报错
<!-- more -->

```bash
$ nodetool status
nodetool: Failed to connect to '127.0.0.1:7199' - URISyntaxException: 'Malformed IPv6 address at index 7: rmi://[127.0.0.1]:7199'.
```

出错原因：

JNDI 提供程序的 URL 解析器包括 RMI（由 JMX 使用）在 Oracle Java 8u331 中得到了改进，并且只允许在 IPv6 地址周围使用括号 (JDK-8278972)。

nodetool使用较新的 Java 版本运行会中断，因为 RMI URL 中的主机包含在方括号中（来自NodeProbe.java类）：
```bash
private static final String fmtUrl = "service:jmx:rmi:///jndi/rmi://[%s]:%d/jmxrmi";
```

解决方法:

选项 1 - 在运行时添加“传统”解析标志nodetool，例如：

$ nodetool -Dcom.sun.jndi.rmiURLParsing=legacy status

选项 2 - 指定带有 IPv6 子网前缀的主机名，例如：

$ nodetool -h ::FFFF:127.0.0.1 status

选项 3 

此问题已在Apache Cassandra 3.0.27、3.11.13、4.0.4 和 4.1 及以后版本 ( CASSANDRA-17581 ) 中得到解决

References:

[1][Cassandra集群搭建](https://www.cnblogs.com/chinaops/p/16998722.html)
