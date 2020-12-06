---
title: postgresql reset xlog
tags:
  - PostgresQL
id: '7767'
categories:
  - - Database
date: 2016-11-26 14:24:22
---


<!-- more -->
**切记：永远不要手工删除postgresql数据库目录下的文件。**

一个测试库，因为开启了归档，而归档命令又失败了，导致归档日志暴涨，把根文件系统撑爆了，因为只是测试库，所以没在意，从配置文件中关了归档，
直接去pg_xlog目下手工干掉了所有的归档日志，然后问题就来了。

重新启动postgresql服务失败，错误日志：
```js
2016-11-26 13:47:53 CST \[24422-1\] LOG: database system was shut down at 2016-11-26 13:42:38 CST
2016-11-26 13:47:53 CST \[24422-2\] LOG: invalid primary checkpoint record
2016-11-26 13:47:53 CST \[24422-3\] LOG: invalid secondary checkpoint record
2016-11-26 13:47:53 CST \[24422-4\] PANIC: could not locate a valid checkpoint record
2016-11-26 13:47:53 CST \[24421-1\] LOG: startup process (PID 24422) was terminated by signal 6: Aborted
2016-11-26 13:47:53 CST \[24421-2\] LOG: aborting startup due to startup process failure
```
检查点丢失了，只好reset log

```js
$ sudo -u postgres ./pg_resetxlog /var/lib/postgresql/9.4/main/
Transaction log reset
```

如果不行，请加-f参数强制reset

然后再启动，提示：
```js
2016-11-26 13:55:24 CST \[27330-1\] LOG: database system was shut down at 2016-11-26 13:54:28 CST
2016-11-26 13:55:24 CST \[27330-2\] PANIC: too many replication slots active before shutdown
2016-11-26 13:55:24 CST \[27330-3\] HINT: Increase max_replication_slots and try again.
2016-11-26 13:55:24 CST \[27329-1\] LOG: startup process (PID 27330) was terminated by signal 6: Aborted
2016-11-26 13:55:24 CST \[27329-2\] LOG: aborting startup due to startup process failure
```

因为以前添加了复制槽，现在max_replication_slots又设置成了0，所以出错了，重新修改配置文件：
```js
archive_moe=archive
max_replication_slots=5
```

启动后删除replication slots:
\[sql\]
=> select pg_drop_replication_slot('slotname');
\[/sql\]

这样关闭归档参数就没问题了。

再一次，永远不要手工删除postgresql数据目录下的文件，归档日志太多撑爆了硬盘，postgresql panic，是因为归档命令或者复制槽出问题了，因此数据库无法自动清理wal日志。
如果故障无法排除，可以首先将pg_xlog目录下的文件拷贝到其他地方，然后使用pg_archivecleanup命令来清理归档日志。

迫不得已，实在每办法了，再reset log，但是这时的数据库状态是不对的，不应该再使用了。如果有其他备份，请恢复这些备份。
没有的话，可以先pg_dump,然后停止数据库，重新initdb初始化数据库,然后再pg_restore。

References:
\[1\][How can I solve postgresql problem after deleting wal files?](http://dba.stackexchange.com/questions/80317/how-can-i-solve-postgresql-problem-after-deleting-wal-files)

**\===
\[erq\]**