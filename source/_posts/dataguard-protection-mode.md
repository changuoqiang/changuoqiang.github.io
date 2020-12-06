---
title: Oracle 10g DataGuard手记之保护模式配置
tags:
  - Oracle
id: '1812'
categories:
  - - Database
date: 2011-12-31 22:36:29
---

DataGuard共有三种数据保护模式,默认配置下运行于最大性能模式
<!-- more -->
最大保护,最大可用和最大性能三种模式对LOG_ARCHIVE_DEST_n参数的属性以及是否需要standby redo logs有不同的要求

最大保护和最大可用模式要求使用LGWR日志写进程,需要SYNC模式来传输redo日志,需要AFFIRM磁盘写操作模式,并且需要standby redo logs。使用AFFIRM磁盘写模式时,所有的归档日志和standby redo log日志的磁盘I/O是同步执行的,日志写进程要等待这些磁盘I/O执行完毕后才会继续运行,而NOAFFIRM磁盘写模式则是异步的。

最大性能模式则要求低一些,可以使用LGWR或者ARCH日志写进程,使用ARCH时需要使用SYNC模式,而使用LGWR时则SYNC和ASYNC模式皆可。磁盘写模式使用AFFIRM或NOAFFIRM皆可,可以不使用standby redo logs但推荐使用。

下面将DataGuard运行模式由默认的最大性能模式升级为最大可用模式。数据保护模式是由primary决定的,standby只能被动的接受这一切,没有特别说明的话以下步骤默认是在primary端执行。

**1、查看当前保护模式**
\[sql\]
SQL>select protection_mode,protection_level from v$database;
PROTECTION_MODE PROTECTION_LEVEL
-------------------- --------------------
MAXIMUM PERFORMANCE MAXIMUM PERFORMANCE
\[/sql\]
表明现在dataguard运行于默认的最高性能模式

**2、修改primary的初始化参数log_archive_dest_2**
\[sql\]
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='SERVICE=standby01
 2> OPTIONAL LGWR SYNC AFFIRM
 3> VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE)
 4> DB_UNIQUE_NAME=standby01';
\[/sql\]
主要就是增加了AFFIRM选项,在参数文件中增加该选项也是可以的。

**3、设置保护模式为最高可用模式**

如果是升级保护模式,比如从最高性能模式升级到最高可用模式,则需要先关闭数据库,然后mount数据库,如果是降级保护模式则直接从下面的alter语句开始执行
\[sql\]
SQL>shutdown immediate;
SQL>startup mount;
SQL>alter database set standby database to maximize availability;
SQL>alter database open;
\[/sql\]
**4、确认primary是否运行于最高可用模式**
\[sql\]
SQL>select protection_mode,protection_level from v$database;

PROTECTION_MODE PROTECTION_LEVEL
-------------------- --------------------
MAXIMUM AVAILABILITY MAXIMUM AVAILABILITY
\[/sql\]
dataguard已经运行于最高可用模式

**5、修改standby库(standby01)初始化参数log_archive_dest_2方便备库转变为主库角色(此步骤非必须)**
\[sql\]
SQL> ALTER SYSTEM SET LOG_ARCHIVE_DEST_2=’SERVICE=primary OPTIONAL LGWR ASYNC AFFIRM VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=primary’;
\[/sql\]
顺便看下standby01现在运行的保护模式,应该与主库是一致的
\[sql\]
SQL>select protection_mode,protection_level from v$database;
PROTECTION_MODE PROTECTION_LEVEL
-------------------- --------------------
MAXIMUM AVAILABILITY MAXIMUM AVAILABILITY
\[/sql\]
配置成功。

PS:可以在配置dataguard时一并配置好适用于最高可用模式的初始化参数LOG_ARCHIVE_DEST_n,以后切换数据保护模式就更简单了。
 **===
\[erq\]**