---
title: oracle 11g dataguard 新特性
tags:
  - Oracle
id: '5915'
categories:
  - - Database
date: 2014-10-17 20:47:11
---


<!-- more -->
**Active Dataguard**

在Oracle 11g之前，物理备库（physical Standby）在应用redo的时候，是不可以打开的，只可以mount。从11g开始，在应用redo的时候，物理备库可以处于read-only模式，这就称为Active Dataguard 。通过Active Dataguard，可以在物理备库进行查询或者导出数据，从而减少对主库的访问和压力。

Active Dataguard适用于一些只读性的应用，比如，有的应用程序只是查询数据，进行一些报表业务，不会产生redo数据，这些应用可以转移到备库上，避免对主库资源的争用。

Oracle Active Dataguard 是Oracle Database Enterprise Edition的一个功能，需要额外付费授权来使用这个功能。

如需启用Active Dataguard, 只需要将备库以 read-only 模式打开，而且执行 ALTER DATABASE RECOVER MANAGED STANDBY DATABASE语句就可以。需要注意的是：主库和备库的COMPATIBLE 参数至少要设置为11.0.0。

**Duplicate from active database** 

11g以前使用rman创建备库需要先进行备份,然后将备份传输到备库或者可以被备库直接访问到，会大量占用额外的存储空间。
11g提供了从运行的主库直接创建备库的功能,这样就不再需要提前rman备份数据库,数据库直接从target拷贝到auxiliary,方便快捷，当然其他的一些设置是省不了的。

References:
\[1\][Oracle 11g Data Guard 物理备库快速配置指南（上）](http://kyle.xlau.org/posts/oracle-data-guard-part1.html)
\[2\][Oracle 11g Data Guard 物理备库快速配置指南（下）](http://kyle.xlau.org/posts/oracle-data-guard-part2.html)
\[3\][Creating a Standby Database with Recovery Manager](http://docs.oracle.com/cd/B28359_01/server.111/b28294/rcmbackp.htm#g648533)

**\===
\[erq\]**