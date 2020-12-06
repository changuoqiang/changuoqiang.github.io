---
title: rman恢复目录中注销(unregister)目标数据库
tags:
  - Oracle
id: '5931'
categories:
  - - Database
date: 2014-10-18 11:10:34
---


<!-- more -->
如果不再需要使用rman来管理目标数据库,或者目标数据库已经崩溃,可以从rman恢复目录注销掉目标数据库。这样只会从恢复目录中移除目标数据库备份相关的元数据，物理备份不会被删除。

**连接目标数据库**

最简单的就是连上目标数据库和恢复目录，然后执行unregister database
\[sql\]
$ rman target user/passwd@tgt catalog user/passwd@catlog;
RMAN> unregister database;
database name is "orcl" and DBID is 1276927241
Do you really want to unregister the database (enter YES or NO)? 
\[/sql\]

**不连接目标数据库**

如果目标数据库已经崩溃,无法再连接时,可以通过指定目标数据库的DBID或者直接使用名字来注销数据库。

如果不知道目标数据库的DBID或名字,先通过rman数据库的rc_database视图(rc指recovery catalog)来查询相关信息。谨记rman恢复目录可以同时为多个目标数据库提供服务。
\[sql\]
$ sqlplus user/passwd@catlog;
SQL> select * from rc_database;
 DB_KEY DBINC_KEY DBID NAME RESETLOGS_CHANGE# RESETLOGS_TIME
---------- ---------- ---------- -------- ----------------- ------------------
 10161 41305 1276927241 ORCL 1981608693 28-JUL-12
\[/sql\]

使用DBID
\[sql\]
$ rman catalog user/passwd@catlog;
RMAN> set dbid=1276927241;
executing command: SET DBID
database name is "ORCL" and DBID is 1276927241
RMAN> unregister database;
database name is "ORCL" and DBID is 1276927241
Do you really want to unregister the database (enter YES or NO)? 
\[/sql\]

直接使用目标数据库名字
\[sql\]
$ rman catalog user/passwd@catlog;
RMAN> unregister database orcl;
database name is "ORCL" and DBID is 1276927241
Do you really want to unregister the database (enter YES or NO)? YES
database unregistered from the recovery catalog
\[/sql\]

**移除恢复目录**

如果rman恢复目录不再使用,可以drop掉:
\[sql\]
$ rman catalog user/passwd@catlog;
RMAN> drop catalog;
\[/sql\]

References:
\[1\][Remove a Database from a RMAN Recovery Catalog](http://www.oracledistilled.com/oracle-database/backup-and-recovery/remove-a-database-from-a-rman-recovery-catalog/)

**\===
\[erq\]**