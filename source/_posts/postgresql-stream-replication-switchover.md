---
title: PostgreSQL流复制主备切换
tags:
  - PostgresQL
id: '9330'
categories:
  - - Database
date: 2020-07-09 13:46:31
---


<!-- more -->
**一、判断主备角色**
有几个方法可以判断：
1、查看wal进程
```js
$ ps aux grep wal
```
如果进程名有"postgres: 11/main: walwriter"字样，则为主库，walwriter为wal发送方。
如果进程名有"postgres: 11/main: walreceiver streaming 2A/ACAA1088"字样，则为备库，walreceiver为wal接收方。
2、pg_is_in_recovery函数
```js
$ sudo -u postgres psql
postgres=# select pg_is_in_recovery();
pg_is_in_recovery
-------------------
 f
(1 row)
```
显示f说明是主库，显示t说明为备库。
3、查看数据库控制信息
```js
$ sudo -u postgres /usr/lib/postgresql/11/bin/pg_controldata -D /var/lib/postgresql/11/main/
g_control version number: 1100
Catalog version number: 201809051
Database system identifier: 6745356148899875633
Database cluster state: in production
pg_control last modified: Thu 09 Jul 2020 02:40:49 PM CST
Latest checkpoint location: 825/245660D8
Latest checkpoint's REDO location: 825/245660A0
...
```
Database cluster state这行为in production说明位主库，为in archive recovery说明为备库。
4、通过recovery.conf 文件判断
一般的，备库才有recovery.conf，主库一般没有或是改名为recovery.done

**二、主备切换**
1、使用trigger文件切换

a. 在备库启动时在 recovery.conf 文件中加入一个触发文件的路径（新加则需要重启备库）
```js
trigger_file='/var/lib/postgresql/11/main/.postgresql.trigger'
```

b. 关闭主库：
```js
$ sudo systemctl stop postgresql@11-main.service
```
或者
先查看postgresql集群信息
```js
$ pg_lsclusters
Ver Cluster Port Status Owner Data directory Log file
11 main 5432 online postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
```
然后执行：
```js
$ sudo pg_ctlcluster 11 main stop
```

c.在备库上创建trigger文件
```js
$ sudo touch /var/lib/postgresql/11/main/.postgresql.trigger
```
可以看到备库上的recovery文件已经成为done了,此时备库已经被激活为主库，可以直接做读写操作了
在新主库上创建复制槽

d. 原主库搭建为新备库
准备recovery.conf文件，primary_conninfo指向新主库，使用合适的复制槽，然后重新启动数据库即可。
```js
recovery_target_timeline='latest'
standby_mode = 'on'
primary_conninfo = 'host=59.206.31.149 port=5432 user=xxxx password=xxxx'
primary_slot_name = 'repl_slot_2'
```
这里必须添加recovery_target_timeline='latest'，因为主备切换时timeline更新了。
注意pg_hba_conf中对replication的权限设定

2、使用pg_ctlcluster命令切换
a. 停止应用程序，关闭主库
b. 备库提升为主库
备库端执行：
```js
$ sudo pg_ctlcluster 11 main promote
```
c. 老主库上配置recovery.conf文件，启动原主库为新的备库

References:
\[1\][26.3. Failover](https://www.postgresql.org/docs/11/warm-standby-failover.html)
\[2\][PostgreSQL 流复制的主备切换](https://blog.csdn.net/qq_43303221/article/details/85777529)
\[3\][PostgreSQL Switchover vs. Failover](https://blog.51cto.com/heyiyi/1917655)
\[4\][PostgreSQL主备切换](https://www.cnblogs.com/lottu/p/7490759.html)