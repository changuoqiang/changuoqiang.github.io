---
title: PostgresQL终止活动连接/会话
tags:
  - PostgresQL
id: '5999'
categories:
  - - Database
date: 2014-10-30 20:35:32
---


<!-- more -->
执行建库脚本时需要drop数据库,那么问题来了,脚本出现如下错误提示:
```js
ERROR: database "reis" is being accessed by other users
DETAIL: There are 5 other sessions using the database.
ERROR: tablespace "ts_reis" is not empty
ERROR: role "reis" cannot be dropped because some objects depend on it
DETAIL: owner of database reis
owner of tablespace ts_reis
```
也就是该库上还有会话存在,drop请求被拒绝。那么把活动连接drop掉就可以了吧。

可以使用pg_terminate_backend()函数和pg_stat_activity视图来终止数据库上的活动连接。
先查看下pg_stat_activity视图的详细信息：
\[sql\]
$ psql -U postgres -h localhost -d postgres
postgres=# \\d pg_stat_activity ;

View "pg_catalog.pg_stat_activity"
 Column Type Modifiers 
------------------+--------------------------+-----------
 datid oid 
 datname name 
 pid integer 
 usesysid oid 
 usename name 
 application_name text 
 client_addr inet 
 client_hostname text 
 client_port integer 
 backend_start timestamp with time zone 
 xact_start timestamp with time zone 
 query_start timestamp with time zone 
 state_change timestamp with time zone 
 waiting boolean 
 state text 
 query text 

\[/sql\]

\\d+ 命令可以获取表或视图更详细的信息。

然后就有了下面的sql语句来终止活动连接：
```js
SELECT 
 pg_terminate_backend(pid) 
FROM 
 pg_stat_activity 
WHERE 
 -- 不终止当前连接
 pid <> pg_backend_pid()
 -- 只终止target_database上的连接
 AND datname = 'target_database';
```

世界一下子就清净了。

**\===
\[erq\]**