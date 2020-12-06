---
title: 查询PostgreSQL默认表空间
tags:
  - PostgresQL
id: '3944'
categories:
  - - Database
date: 2013-11-06 21:32:41
---

查询数据对应的默认表空间
<!-- more -->
继续使用[数据库组织管理](https://openwares.net/database/postgresql_tablespace_database_user_schema_table-2.html)post里的示例
\[sql\]
foo=> SELECT d.datname, t.spcname FROM pg_database d, pg_tablespace t WHERE d.dattablespace = t.oid;
 datname spcname 
-----------+------------
 template1 pg_default
 template0 pg_default
 postgres pg_default
 foo ts_foo
(4 rows)
\[/sql\]