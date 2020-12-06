---
title: dataguard archive gap 日志间隙处理
tags:
  - Oracle
id: '7246'
categories:
  - - Database
date: 2016-05-12 10:23:12
---


<!-- more -->
因为网络故障或资源紧张，会使standby出现日志同步间隙(archive gap)。虽然设置好了FAL_CLIENT和FAL_SERVER参数，有时候仍然无法自动解决日志间隙问题。

比如由于CONTROL_FILE_RECORD_KEEP_TIME设置导致，较旧的主库归档日志记录被循环覆盖，standby无法自动获取相应的日志文件：
```js
Fetching gap sequence in thread 1, gap sequence 19767-19866
Thu May 12 09:45:47 2016
FAL\[client\]: Failed to request gap sequence 
 GAP - thread 1 sequence 19767-19866
 DBID 1276927241 branch 874659493
FAL\[client\]: All defined FAL servers have been attempted.
-------------------------------------------------------------
Check that the CONTROL_FILE_RECORD_KEEP_TIME initialization
parameter is defined to a value that is sufficiently large
enough to maintain adequate log switch information to resolve
archivelog gaps.
-------------------------------------------------------------
```

如果standby缺少的归档日志尚未删除，可以拷贝缺少的日志到备库，然后在备库上注册，备库会apply这些归档日志。
如果归档日志已经被删除，则需要从主库做增量备份，然后在备库进行恢复来修复日志间隙。

**手工拷贝归档日志**

首先查看日志间隙:

```js
sql> select * from v$archive_gap;
THREAD# LOW_SEQUENCE# HIGH_SEQUENCE#
-------- ---------------- ----------------------
1 19767 19866
```

将对应的归档日志拷贝到备库端

最后在备库端注册这些归档日志：
```js
sql> alter database register physical logfile '\\path\\to\\archive_log'
```

备库会立即应用这些归档日志。如果日志数量过多,也可以使用以下语句来自动恢复数据库:

```js
SQL> ALTER DATABASE RECOVER AUTOMATIC STANDBY DATABASE;
```

**创建备库导致的日志不同步问题**

最近遇到的一个案例是这样的,rman dupicate创建完备库后,因为没有使用dorecovery恢复增量备份,主库上的部分归档日志又被清除掉了,导致主备库无法进行同步,备库有类似如下错误提示:
```js
Media Recovery Waiting for thread 1 sequence 23943
Fetching gap sequence in thread 1, gap sequence 23943-24042
Sun Jul 24 13:02:27 2016
FAL\[client\]: Failed to request gap sequence 
 GAP - thread 1 sequence 23943-24042
 DBID 1276927241 branch 874659493
FAL\[client\]: All defined FAL servers have been attempted.
-------------------------------------------------------------
Check that the CONTROL_FILE_RECORD_KEEP_TIME initialization
parameter is defined to a value that is sufficiently large
enough to maintain adequate log switch information to resolve
archivelog gaps.
-------------------------------------------------------------
```

主库有类似如下错误提示:
```js
FAL Redo Shipping Client Established Network Login
Failed to queue the whole gap
 GAP - thread 1 sequence 23943-24042
 DBID 1276927241 branch 874659493
```

此时备库查询v$archive_gap表是没有任何记录的,幸好还有一个备库有完整的归档日志,将相应的归档日志完整拷贝到新建的物理备库上,然后执行以下语句自动恢复数据库:

```js
SQL> ALTER DATABASE RECOVER AUTOMATIC STANDBY DATABASE;
```

所有可用日志全部恢复完毕后,会有如下提示:

```js
ALTER DATABASE RECOVER AUTOMATIC STANDBY DATABASE
*
ERROR at line 1:
ORA-00279: change 7255663631 generated at 07/25/2016 08:51:20 needed for thread 1
ORA-00289: suggestion : D:\\ARCHIVED_LOG\\ARC24380_0874659493.001
ORA-00280: change 7255663631 for thread 1 is in sequence #24380
ORA-00278: log file 'D:\\ARCHIVED_LOG\\ARC24380_0874659493.001' no longer needed for this recovery
ORA-00308: cannot open archived log 'D:\\ARCHIVED_LOG\\ARC24380_0874659493.001'
ORA-27041: unable to open file
OSD-04002: unable to open file
O/S-Error: (OS 2) 系统找不到指定的文件。
```

这是因为已经没有日志可用于恢复了,此时重新打开实时日志应用就可以开始自动同步了:

```js
SQL> alter database recover managed standby database disconnect from session;
```

如果归档日志已经找不到了,则可以采用以下增量备份方式修复备库。

**增量备份修复备库**

1.  查找恢复点SCN
备库端：
首先查看日志间隙:
```js
sql> select * from v$archive_gap;
THREAD# LOW_SEQUENCE# HIGH_SEQUENCE#
-------- ---------------- ----------------------
1 19767 19766
```

主库端：
然后主库上查找日志间隙中低端日志序号的上一个日志的first_change#
```js
sql> select SEQUENCE#, FIRST_CHANGE# from v$archived_log where SEQUENCE#=19766;
SEQUENCE# FIRST_CHANGE# 
--------- -------------
19766 7008518015
```
2.  备库停止apply log
备库端：
```js
sql> alter database recover managed standby database cancel;
```
3.  主库增量SCN备份
主库端：
```js
$ rman target /
RMAN> backup incremental from scn 7008518015 database format '/path/to/stdby_%U.bak';
```
4.  生成备库控制文件
主库端：
```js
RMAN> backup current controlfile for standby format '/path/to/stdby_%U.ctl';
```
5.  拷贝备份和控制文件到备库
6.  备库使用新生成的控制文件启动
备库端：
```js
rman> shutdown immediate;
rman> startup nomount;
rman> restore standby controlfile from '/path/to/stdby_xxx.ctl';
rman> alter database mount
```
7.  备库进行数据恢复
备库端：
```js
RMAN> catalog start with '/path/to_bak';
RMAN> recover database noredo;
```
8.  备库恢复日志应用
备库端：
```js
SQL> alter database recover managed standby database disconnect from session;
```

References:
\[1\][DataGuard 中处理archive gap的方法](http://www.programgo.com/article/9189574397/)
\[2\][Roll Forward Physical Standby Database using RMAN incremental backup](https://shivanandarao-oracle.com/2012/03/26/roll-forward-physical-standby-database-using-rman-incremental-backup/)
\[3\][Oracle Physical DataGuard使用RMAN增量备份修复GAP](http://www.zhongweicheng.com/?p=1305)
\[4\][Using RMAN Incremental Backups to Refresh a Standby Database](http://docs.oracle.com/cd/B19306_01/backup.102/b14191/rcmdupdb.htm#BRADV05444)

**\===
\[erq\]**