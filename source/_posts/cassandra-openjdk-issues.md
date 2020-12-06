---
title: Cassandra竟然歧视OpenJDK
tags:
  - cassandra
  - Java
id: '6099'
categories:
  - - Database
date: 2014-12-25 20:08:34
---


<!-- more -->
cassandra 2.1.2的启动日志中出现如下字样:
```js
WARN \[main\] 2013-11-24 10:54:30,423 CassandraDaemon.java (line 155) OpenJDK is not recommended. Please upgrade to the newest Oracle Java release
```

查看CassandraDaemon.java源代码,有如下行:
```js
 String javaVmName = System.getProperty("java.vm.name");
logger.info("JVM vendor/version: {}/{}", javaVmName, javaVersion);
if (javaVmName.contains("OpenJDK"))
{
 // There is essentially no QA done on OpenJDK builds, and
 // clusters running OpenJDK have seen many heap and load issues.
 logger.warn("OpenJDK is not recommended. Please upgrade to the newest Oracle Java release");
}
else if (!javaVmName.contains("HotSpot"))
{
 logger.warn("Non-Oracle JVM detected. Some features, such as immediate unmap of compacted SSTables, may not work as intended");
}
```

OpenJDK没这么差吧！

===
\[erq\]