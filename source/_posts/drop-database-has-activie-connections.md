---
title: 删除还有活动连接的PostgreSQL数据库
tags:
  - PostgresQL
id: '3915'
categories:
  - - Database
date: 2013-11-06 16:30:30
---

如果数据库尚有活动连接，则drop数据库时会失败并有错误提示。
<!-- more -->
\[sql\]
postgres=# DROP DATABASE testdb;

ERROR: database "testdb" is being accessed by other users
DETAIL: There are 3 other sessions using the database.
\[/sql\]

可以先用下面的语句把testdb的活动连接中止，然后再DROP数据库就可以了。
\[sql\]
postgres=# SELECT pg_terminate_backend(pid)
postgres-# FROM pg_stat_activity
postgres-# WHERE datname='testdb' AND pid<>pg_backend_pid();

 pg_terminate_backend 
----------------------
 t
 t
 t
(3 rows)
\[/sql\]

pg_stat_activity是一个系统视图，表中的每一行代表一个服务进程的属性和状态。

boolean pg_terminate_backend(pid int)是一个系统函数，用于终止一个后端服务进程。

int pg_backend_pid()系统函数用于获取附加到当前会话的服务器进程的ID

使用的数据库版本PostgreSQL 9.3

**\===
\[erq\]**