---
title: PostgreSQL连续归档备份
tags:
  - PostgresQL
id: '6975'
categories:
  - - Database
date: 2015-12-04 20:55:48
---


<!-- more -->
pg_dump/pg_dumpall属于一致性逻辑备份，可以用其进行跨PostgreSQL版本，跨系统平台的数据迁移。用于常规备份则其速度和灵活性略显不足。

而连续归档模式则类似于oracle的rman备份方式，可用于大型数据库的增量备份和恢复，以及用于搭建高可用standby镜像备份。

**设置归档**

PostgreSQL默认处于非归档模式。开启归档模式，主要涉及到三个参数：wal_level,archive_mode和archive_command

wal_level参数默认为mininal,设置此参数为archive或者之上的级别都可以打开归档。
当postgresql需要传输归档日志时，会调用archive_command指定的shell命令。归档文件传输成功时，shell命令要返回0，此时，postgresql会认为归档文件已经传输成功，因此可以删除或者重新循环利用归档文件。当shell命令返回非0值时，postgresql会保留所有未成功传输的归档日志，并不断尝试重新传输，直到成功。如果归档命令一直不成功，pg_xlog目录会持续增长，有耗尽服务器存储空间的可能，此时postgresql会PANIC关闭，直到释放存储空间。

将归档WAL日志存储在本机上是风险极高，不被推荐的。postgresql通过archive_command提供了存储WAL日志的灵活性，可以将归档日志存储到挂装的NFS目录，磁带，刻录到光盘，也可以将WAL日志通过ssh/scp传输到异机保存。

要注意，archive_command将以运行PostgreSQL的系统用户的身份运行。debian系统里，这个系统用户是postgres。

修改/etc/postgresql/$PG_VERISON/main/postgresql.conf文件以启动归档:
```js
wal_level = archive
archive_mode = on
#archive_command = 'test ! -f /mnt/server/archivedir/%f && cp %p /mnt/server/archivedir/%f'
archive_command = 'ssh arc_svr test ! -f /path/to/archive/%f && scp %p arc_svr:/path/to/archive/%f'
```

arc_svr是用于存储WAL日志的ssh服务器别名
然后重新启动postgresql
```js
$ sudo service postgresql restart
```

手动切换WAL日志,看配置是否正确，WAL是否正确传输了:
```js
$ sudo -u postgres psql -c 'select pg_switch_xlog()'
pg_switch_xlog 
----------------
 1/6A0006A8
(1 row)
```

查看归档目录下出现了归档WAL日志文件。

**使用pg_start_backup进行基础备份**

1.  确保postgesql运行于归档模式
```js
postgres=# select name, setting from pg_catalog.pg_settings where name like 'archive%' or name = 'wal_level';
 name setting 
-----------------+---------------------------------------------------------------------------
 archive_command ssh node5 test ! -f /var/backups/postgresql/archive/%f && scp %p node5:/var/backups/postgresql/archive/%f
 archive_mode on
 archive_timeout 0
 wal_level archive
(4 rows)
```
2.  使用超级用户执行pg_start_backup
```js
postgres=# select pg_start_backup('basebackup-20151205');
 pg_start_backup 
-----------------
 1/6F000028
(1 row)
```
basebackup-20151205是一个标签，用户自行指定用于标识本次基础备份。pg_start_backup会创建一个备份标签文件(backup label file),文件内保存有此次基本备份的相关信息。

3.  使用文件系统备份工具备份整个集群的数据文件
```js
$ sudo -u postgres tar cjvf /var/backups/postgresql/base/20151205.tbz2 -P \\
--exclude=/var/lib/postgresql/9.4/main/postmaster.pid \\
--exclude=/var/lib/postgresql/9.4/main/postmaster.opts \\
--exclude=/var/lib/postgresql/9.4/main/pg_xlog \\
--exclude=/var/lib/postgresql/9.4/main/pg_replslot \\
--warning=no-file-changed --warning=no-file-removed \\
/var/lib/postgresql/9.4/main 
```

备份时需要排除掉postmaster.pid和postmaster.opts文件，以及pg_xlog和pg_replslot目录。

生成的基础备份应该与归档WAL日志采用一样的存储策略，存储到异机保存，并可以进一步保存到永久介质保存，比如磁带或者CDROM。
4.  以超级用户身份执行pg_stop_backup
```js
postgres=# select pg_stop_backup();
NOTICE: pg_stop_backup complete, all required WAL segments have been archived
 pg_stop_backup 
----------------
 1/6F1A64F8
(1 row)
```
pg_stop_backup会将备份期间活动的WAL日志文件归档，一旦这些日志完成归档，则整个备份过程就结束了。
pg_stop_backup会生成一个.backup文件标识出保证此次备份完整性所需要的最后一个WAL日志，使用此次基础备份恢复系统时，不再需要之前的WAL日志。
比如:
```js
-rw------- 1 admin admin 306 Dec 5 21:37 00000001000000010000006F.00000028.backup
-rw------- 1 admin admin 16M Dec 5 21:37 00000001000000010000006F
```
说明此次备份所需的归档WAL日志文件从00000001000000010000006F往后即可，包含此文件和对应的.backup文件。
backup文件的内容类似如下：
```js
START WAL LOCATION: 1/6F000028 (file 00000001000000010000006F)
STOP WAL LOCATION: 1/6F1A64F8 (file 00000001000000010000006F)
CHECKPOINT LOCATION: 1/6F000028
BACKUP METHOD: pg_start_backup
BACKUP FROM: master
START TIME: 2015-12-05 21:03:03 CST 
LABEL: basebackup-20151205
STOP TIME: 2015-12-05 21:37:58 CST 
```

**使用pg_basebackup进行基础备份**

pg_basebackup使用复制协议，因此需要配置pg_hba.conf文件以允许replication连接,无论本地还是通过网络。
比如:
```js
local replication postgres peer 
host replication postgres 192.168.0.0/24 md5 
```

还需要设置postgresql.conf文件中的max_wal_senders参数以允许至少一个session连接来进行备份。
修改两个参数文件后，重新启动postgresql。

然后执行以下命令:
```js
$ sudo -u postgres pg_basebackup -RPv　-X fetch -D baseback20151205-1 
transaction log start point: 1/72000028 on timeline 1
498974/498974 kB (100%), 1/1 tablespace 
transaction log end point: 1/72000430
pg_basebackup: base backup completed
```

这会生成一个备份目录，其目录结构与数据库集群的目录结构一致。如果要将数据打包到一个bz2文件，可以执行如下命令:
```js
$ sudo -u postgres sh -c 'pg_basebackup -RPv -Ft -D - -X fetch | bzip2 > baseback20151205-1.tbz2'
```
请注意输出文件的写入权限

pg_basebackup命令同样会在备份中生成backup_label文件和.backup归档日志文件。
其.backup文件内容类似如下:
```js
START WAL LOCATION: 1/7C000028 (file 00000001000000010000007C)
STOP WAL LOCATION: 1/7C000998 (file 00000001000000010000007C)
CHECKPOINT LOCATION: 1/7C000550
BACKUP METHOD: streamed
BACKUP FROM: master
START TIME: 2015-12-05 22:52:23 CST 
LABEL: pg_basebackup base backup
STOP TIME: 2015-12-05 22:53:20 CST 
```

可以远程使用pg_basebackup来进行基础备份。

pg_basebackup的详细参数见man pg_basebackup或参考\[2\]。

References:
\[1\][24.3. Continuous Archiving and Point-in-Time Recovery (PITR)](http://www.postgresql.org/docs/current/static/continuous-archiving.html)
\[2\][pg_basebackup](http://www.postgresql.org/docs/9.4/static/app-pgbasebackup.html)