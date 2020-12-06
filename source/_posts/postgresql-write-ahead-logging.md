---
title: postgresql预写日志(Write-Ahead Logging)
tags:
  - PostgresQL
id: '6848'
categories:
  - - Database
date: 2015-11-03 22:47:12
---


<!-- more -->
postgresql WAL日志是为了保证数据的完整性，基本上是与oracle的redo log十分类似的东西。
WAL也是在线复制备份，时间点恢复等高级特性的基石。

References:
\[1\][29.2. Write-Ahead Logging (WAL)](http://www.postgresql.org/docs/9.4/static/wal-intro.html)
\[2\][PostgreSQL WAL vs. Oracle Redo Log](http://www.moeding.net/archives/37-PostgreSQL-WAL-vs.-Oracle-Redo-Log.html)

**\===
\[erq\]**