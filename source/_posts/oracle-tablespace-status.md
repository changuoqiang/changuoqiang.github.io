---
title: oracle查看修改表空间属性状态
tags:
  - Oracle
id: '7784'
categories:
  - - Database
date: 2016-11-29 11:11:28
---


<!-- more -->
oracle表空间有四种状态ONLINE,READ WRITE,READ ONLY和OFFLINE,READ WRITE和READ ONLY是ONLINE的特殊情况。

查询表空间状态：
\[sql\]
sql> select tablespace_name,status from dba_tablespaces;
\[/sql\]

修改表空间状态：
\[sql\]
sql> alter tablespace tablespace_name offline/online/read only/read write;
\[/sql\]

**\===
\[erq\]**