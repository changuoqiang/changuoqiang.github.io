---
title: PostgreSQL高可用之log-shiping based hot standby
tags:
  - PostgresQL
id: '7017'
categories:
  - - Database
date: 2015-12-08 21:45:01
---


<!-- more -->
传统的备份恢复问题在于恢复时间过长，恢复时间有时候是无法接受的。因此有了高可用(High Availability)的概念。

高可用的实现方式多种多样，PostgreSQL内置支持基于WAL日志文件传输或流复制的方式来实现warm/hot standby备库从而实现数据库的高可用性。

这一篇文章只讲基于日志文件传输方式的warm/hot standby配置。
hot standby与warm standby的区别在于，hot standby在日志恢复的同时还可以提供只读查询，而warm standby只能进行日志恢复。

**先决条件**

主备库硬件可以不同，但硬件架构必须相同，字长也必须相同。PostgreSQL的主版本号必须相同，小版本号可以不同。
但是推荐主备库使用完全相同的版本号。

主备库升级时，要先升级备库，因为新版本的程序会兼容旧版本传输过来的wal日志，但反过来却不一定。

**搭建warm standby备库**

首先参考"[PostgreSQL使用连续归档备份恢复数据库](https://openwares.net/database/postgresql_restore_using_continuous_archiving_backup.html)"在主库上进行一次基础备份，然后将其在备机上恢复。

然后recovery.conf文件中除了restore_comman参数之外，再打开standby_mode参数：
```js
restore_command = 'cp /var/backups/postgresql/archive/%f %p'
standby_mode = 'on'
#archive_cleanup_command = ’pg_archivecleanup /path/to/archive %r’
```

如果需要清理standby不再需要的归档日志，可以配置archive_cleanup_command。不过一般来讲，为了备份的目的，归档日志应该dump到永久存储介质之后再行删除。

可以看到，此处与前文恢复数据库的主要区别既在于在recovery.conf中打开了standby_mode参数。这样以来，备库就会一直处于WAL归档日志恢复循环之中，直到主库失败,备库通过failover升级为主库，或者通过switchover升级为主库。

还可以在recovery.conf文件通过trigger_file参数指定一个触发文件，当standby服务器检测到这个文件时，就会结束恢复模式进入正常操作模式。
```js
trigger_file = '/var/lib/postgresql/trigger'
```
此参数在standby_mode为off时无效。即使设置了此参数，仍然可以使用pg_ctl promote命令来结束恢复模式，从而可以升级为master数据库。

**提升为hot standby备库**

warm standby是不可查询的：
```js
$ sudo -u postgres psql
psql: FATAL: the database system is starting up
```

在warm standby备库的基础上，主备库只需做少许参数配置即可升级到hot standby模式。

主库端postgresql.conf文件中：
```js
wal_level = hot_standby
```
然后重新启动主库，并切换归档日志，从而使下一个归档日志具有hot standby信息:
```js
$ sudo service postgresql restart
$ sudo -u postgres psql -c "select pg_switch_xlog()"
```

备库端postgresql.conf文件中:
```js
hot_standby = on
```

然后重新启动备库即可。

如果启动备库时有类似如下错误:
```js
FATAL: hot standby is not possible because max_connections = 100 is a lower setting than on the master server (its value was 500)
FATAL: hot standby is not possible because max_prepared_transactions = 0 is a lower setting than on the master server (its value was 50)
```

需要将standby上的max_connections，max_prepared_transactions参数设置为大于或等于master上对应参数的值，然后再重新启动。

启动成功后日志中会有类似的输出:
```js
2015-12-09 21:53:19 CST \[23100-3\] LOG: entering standby mode
2015-12-09 21:53:19 CST \[23100-4\] LOG: restored log file "0000000100000001000000A9" from archive
2015-12-09 21:53:19 CST \[23100-5\] LOG: redo starts at 1/A9000090
2015-12-09 21:53:19 CST \[23100-6\] LOG: restored log file "0000000100000001000000AA" from archive
2015-12-09 21:53:19 CST \[23100-7\] LOG: consistent recovery state reached at 1/AB000000
2015-12-09 21:53:19 CST \[23099-1\] LOG: database system is ready to accept read only connections
```

可用使用以下命令进一步确认备库处于日志恢复状态:
```js
sudo -u postgres psql -c "select pg_is_in_recovery()"
 pg_is_in_recovery 
-------------------
 t
(1 row)
```
此命令在主库上执行会返回false。

可以在主库上修改数据库并切换归档，然后查询备库，检查数据是否有一样的变化。因为备库是基于日志文件传输的，所以如果不强制切换归档，备库要等到主库日志切换之后才能看到修改。

流复制有更高的实时性，从而数据丢失的风险更低。

References:
\[1\][Chapter 26. Recovery Configuration](http://www.postgresql.org/docs/current/static/recovery-config.html)

**\===
\[erq\]**