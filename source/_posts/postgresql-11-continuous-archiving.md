---
title: PostgreSQL 11 连续归档备份
tags:
  - PostgresQL
id: '8858'
categories:
  - - Database
  - - GNU/Linux
date: 2019-10-16 21:34:12
---


<!-- more -->
主配置路径/etc/postgresql/11/main/postgresql.conf
连续归档备份主要涉及三个参数

**参数配置**

wal_level
默认值为replica，支持WAL归档，replication以及hot standby，所以此参数保持默认值即可。

archive_mode 
归档模式，默认为off，关闭状态，还有两个选项值on和always。on表示打开归档模式，always表示在日志恢复和replication状态下，仍然会将恢复的日志继续进行归档，所以一般设置为on就可以了。

archive_command
归档命令,指定一个shell命令字符串来保存WAL文档，其中%p代表归档文件路径，%f代表归档文件的名字，不包含路径。归档命令返回0表示归档成功，非0表示归档失败，服务器会保留未归档的WAL日志文档，直到重新归档成功，或者服务器耗尽存储空间，进入panic关闭状态。
不要将WAL归档日志存储在本机，可以挂载NFS或其他远程文件系统来存储日志，也可以使用scp拷贝到远程服务器，总之archive_command十分灵活。
下面的命令写入挂载在本地/mnt/wals目录的远程NFS文件系统
```js
archive_command='test ! -f /mnt/wals/%f && cp %p /mnt/wals/%f'
``` 

要注意archive_command是以运行postgresql数据库的postgres用户来执行的，要注意权限问题，所以/mnt/wals目录postgres用户要有写入权限。

wal_keep_segments
指定在pg_wal目录下保留的wal日志数量。如果replication使用log ship方式可以防止standby跟不上primary产生wal log的速度导致standby需要的日志被循环覆盖而失效。如果流复制replication时使用复制槽则不会存在这个问题，只要wal log没有被standby apply则primay永远不会删除这些wal log,此参数是没有影响的。还有就是pg_basebackup时如果同时备份需要的wal log则，需要设置此参数以防止需要备份的wal log被循环覆盖。
这是设置为100
```js
wal_keep_segments = 100
```

修改wal_level、archive_mode、wal_keep_segments需要重新启动postgresql才能生效。

查看归档设置是否生效:
```js
$ sudo -u postgres psql
psql (11.5 (Debian 11.5-1+deb10u1))
Type "help" for help.

postgres=# select name, setting from pg_catalog.pg_settings where name like 'archive%' or name = 'wal_level';
 name setting 
-----------------+----------------------------------------------
 archive_command test ! -f /mnt/wals/%f && cp %p /mnt/wals/%f
 archive_mode on
 archive_timeout 0
 wal_level replica
(4 rows)
```

手动切换WAL日志测试归档是否成功:
```js
postgres=# select pg_current_wal_lsn();
 pg_current_wal_lsn 
--------------------
 0/1659450
(1 row)

postgres=# select pg_switch_wal();
 pg_switch_wal 
---------------
 0/1659468
(1 row)
```
查看/mnt/wals目录下是否有了新归档的WAL日志文件

**基础备份**

开启归档后，应该立即进行一次基础备份，基础备份加上WAL日志可以完整的恢复整个数据库集群。
这里使用pg_basebackup在本地服务器进行基础备份，使用postgresql用户进行操作，要注意输出文件写入权限问题
```js
$ sudo -u postgres sh -c 'pg_basebackup -l 20191019 -RPv -Ft -D - | gzip -c > baseback20191019.tgz'
```
出现错误提示：
```js
pg_basebackup: cannot stream write-ahead logs in tar mode to stdout
Try "pg_basebackup --help" for more information.
```
这是因为pg_basebackup有一个参数`-X --wal-method`默认设置为s，但此方法与tar格式写入stdout不兼容,可见postgresql源代码
```js
if (format == 't' && includewal == STREAM_WAL && strcmp(basedir, "-") == 0)
 {
 pg_log_error("cannot stream write-ahead logs in tar mode to stdout");
 fprintf(stderr, _("Try \\"%s --help\\" for more information.\\n"),
 progname);
 exit(1);
 }
```

`-X --wal-method`参数可以使pg_basebackup直接包含恢复需要的WAL日志文档，形成一个完整的直接用于恢复的备份，不需要再单独拷贝归档日志文件。但是要注意，wal_keep_segments参数要设置的大一些，防止在备份期间生成的归档日志被循环覆盖，这样基本备份会失败。每个WAL日志有16MB大小，wal_keep_segments设置数乘以16MB就是服务器保存这些wal log需要使用的额外存储空间。
当然`-X --wal-method`参数也可以设置为n，这样恢复时需手动管理自基础备份以来的生成的WAL日志。

在postgres用户的主目录/var/lib/postgresql或postgres可以写的其他目录下执行基础备份完整的命令：
```js
sudo -u postgres sh -c 'pg_basebackup -l 20191019 -RPv -Ft --wal-method=f -D - | gzip -c > baseback20191019.tgz'
pg_basebackup: initiating base backup, waiting for checkpoint to complete
pg_basebackup: checkpoint completed
pg_basebackup: write-ahead log start point: 0/6000028 on timeline 1
40157/40157 kB (100%), 1/1 tablespace 
pg_basebackup: write-ahead log end point: 0/60000F8
pg_basebackup: base backup completed
```
pg_basebackup备份时会生成一个.backup文件标识出保证此次备份完整性所需要的最后一个WAL日志，使用此次基础备份恢复系统时，不再需要之前的WAL日志。生成的备份文档内也有一个文件叫做backup_label，与此文件内容相同。
此文件的内容类似如下：
```js
START WAL LOCATION: 0/6000028 (file 000000010000000000000006)
STOP WAL LOCATION: 0/60000F8 (file 000000010000000000000006)
CHECKPOINT LOCATION: 0/6000060
BACKUP METHOD: streamed
BACKUP FROM: master
START TIME: 2019-10-19 20:20:44 CST 
LABEL: 20191019
START TIMELINE: 1
STOP TIME: 2019-10-19 20:20:45 CST 
STOP TIMELINE: 1
```

也可以远程使用pg_basebackup制作基础备份，pg_basebackup使用复制协议，因此需要配置pg_hba.conf文件以允许replication连接
```js
host replication all 192.168.0.0/24 
```

还需要设置postgresql.conf文件中的max_wal_senders参数以允许至少一个session连接来进行备份，postgresql 11默认设置为10，够用了。

References:
\[1\][25.3. Continuous Archiving and Point-in-Time Recovery (PITR)](https://www.postgresql.org/docs/11/continuous-archiving.html)
\[2\][19.5. Write Ahead Log](https://www.postgresql.org/docs/11/runtime-config-wal.html)
\[3\][19.6. Replication](https://www.postgresql.org/docs/11/runtime-config-replication.html)
\[4\][pg_basebackup](https://www.postgresql.org/docs/11/app-pgbasebackup.html)
\[5\][9.26. System Administration Functions](https://www.postgresql.org/docs/11/functions-admin.html)