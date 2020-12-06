---
title: datagurad实时应用日志错误
tags:
  - Oracle
id: '7526'
categories:
  - - Database
date: 2016-08-17 13:44:31
---


<!-- more -->
物理备库执行实时日志应用时有如下错误：
```js
sql> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
ORA-38500: USING CURRENT LOGFILE option not available without stand
```js

是因为没有standby redo log日志组，这次好像是丢失了。
查看日志组:
```js
idle>select member from v$logfile;

MEMBER
----------------------------------------------------------------------------------------------------
E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
```
只有online redo日志文件，没有standby redo日志文件，因此添加：
```js
SQL>alter database add standby logfile group 4 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO01.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 5 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO02.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 6 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO03.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 7 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO04.LOG') size 50M;
Database altered.
```

重新执行日志实时应用就没问题了。

**\===
\[erq\]**