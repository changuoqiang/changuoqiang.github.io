---
title: Oracle 10g dataguard手记之READ ONLY模式打开物理Standby
tags:
  - Oracle
id: '1873'
categories:
  - - Database
date: 2012-01-10 13:30:35
---

通常情况下物理standby处于mounted模式
<!-- more -->
当standby正常应用redo数据时其打开模式处于mounted模式
\[sql\]
SQL> select open_mode from v$database;
OPEN_MODE
----------
MOUNTED
\[/sql\]
要将物理Standby数据库从REDO应用状态启动到READ ONLY状态,并不能直接ALTER DATABASE OPEN打开数据库,首先要取消redo应用
\[sql\]
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
\[/sql\]
然后再打开数据库：
\[sql\]
SQL> alter database open;
\[/sql\]
查询打开模式
\[sql\]
SQL> select open_mode from v$database;
OPEN_MODE 
---------- 
READ ONLY 
\[/sql\]
要从OPEN状态切换回REDO应用状态，并不需要SHUTDOWN数据库再启动，直接执行启用REDO应用的语句即可
\[sql\]
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION; 
\[/sql\]

**\===
\[erq\]**