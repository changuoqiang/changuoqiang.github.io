---
title: PostgreSQL 11 流复制Hot Standby HA
tags:
  - PostgresQL
id: '8860'
categories:
  - - Database
  - - GNU/Linux
date: 2019-10-16 21:36:25
---


<!-- more -->
PostgreSQL 11 on Debian buster使用带有复制槽的流复制实现高可用只读热备库

**主库端操作**

1、主库参数配置
配置文件/etc/postgresql/11/main/postgresql.conf
```js
# wal_level = replica #默认配置即可
# max_wal_senders = 10 #默认配置即可
wal_keep_segments = 100 #虽然使用复制槽，但仍然防御性设置此参数，防止建立备库的过程中需要的wal log被循环覆盖
# max_replication_slots = 10 # 默认配置即可
```

2、主库复制用户认证配置

使用超级用户postgres或者新建一个具有replication权限的用户作为备库连接到主库进行复制的用户
创建用于复制的用户repl_usr
```js
postgres=# create role repl_usr with login replication password 'repl_passwd';
CREATE ROLE
```
修改/etc/postgresql/11/main/pg_hba.conf文件
```js
host replication repl_usr 0.0.0.0/0 md5
```
postgres用户默认没有启用密码，只能本地peer方式访问，如果需要远程使用此用户，需要先启用密码访问。

3、创建复制槽
名字设定为repl_slot_1
```js
postgres=# SELECT * FROM pg_create_physical_replication_slot('repl_slot_1');
slot_name lsn 
-------------+-----
 repl_slot_1 
(1 row)
postgres=# SELECT slot_name, slot_type, active FROM pg_replication_slots;
 slot_name slot_type active 
-------------+-----------+--------
 repl_slot_1 physical f
(1 row)
```

**备库端操作**

1、使用基础备份恢复数据库作为备库

a. 停止备库
```js
$ sudo systemctl stop postgresql
```

b. 删除备库现有集群数据
将备库postgresql集群数据目录下的所有文件删除，删除debian默认安装postgresql集群数据：
```js
# rm -rf /var/lib/postgresql/11/main/*
```

c. 恢复基础备份
```js
$ sudo -u postgres tar zxvf baseback20191019.tgz -C /var/lib/postgresql/11/main/
```
一定要注意恢复的数据文件的属主是运行PostgreSQL服务的系统用户，debian系统上为postgres,还应该保持原来的权限。
这里使用的基础备份包含了备份完成时所有需要的WAL日志，所以可以不配置restore_command进行日志恢复，而且wal_keep_segments设置了较大的数值，基础备份之后生成的WAL日志可以通过流复制从master获取。

2、参数配置
配置文件/etc/postgresql/11/main/postgresql.conf
```js
# hot_standby = on #默认配置
``` 
配置文件/var/lib/postgresql/11/main/recovery.conf
```js
standby_mode = 'on'
primary_conninfo = 'host=192.168.3.6 port=5432 user=repl_usr password=repl_passwd'
primary_slot_name = 'repl_slot_1'
```
3、启动备库
```js
$ sudo systemctl start postgresql.service
```

**检查复制状态**

1、主库端
检查复制槽状态
```js
postgres=# SELECT slot_name, slot_type, active FROM pg_replication_slots;
 slot_name slot_type active 
-------------+-----------+--------
 repl_slot_1 physical t
(1 row)
```
可以看到复制槽repl_slot_1已经处于活动状态。

当前WAL日志的位置：
```js
postgres=# select pg_current_wal_lsn();
 pg_current_wal_lsn 
--------------------
 0/D000140
(1 row)
```

复制状态：
```js
postgres=# \\x
Expanded display is on.
postgres=# select * from pg_stat_replication;
-\[ RECORD 1 \]----+------------------------------
pid 1567
usesysid 16386
usename repl_usr
application_name walreceiver
client_addr 192.168.3.7
client_hostname 
client_port 58492
backend_start 2019-10-20 17:36:05.768654+08
backend_xmin 
state streaming
sent_lsn 0/D000140
write_lsn 0/D000140
flush_lsn 0/D000140
replay_lsn 0/D000140
write_lag 
flush_lag 
replay_lag 
sync_priority 0
sync_state async
```

2、备库端
最后一个收到的WAL日志
```js
postgres=# select pg_last_wal_receive_lsn();
 pg_last_wal_receive_lsn 
-------------------------
 0/D000140
(1 row)
```

References:
\[1\][Chapter 26. High Availability, Load Balancing, and Replication](https://www.postgresql.org/docs/11/high-availability.html)
\[2\][26.5. Hot Standby](https://www.postgresql.org/docs/11/hot-standby.html)
\[3\][Failover](https://www.postgresql.org/docs/11/warm-standby-failover.html)
\[4\][PostgreSQL Switchover vs. Failover](https://blog.51cto.com/heyiyi/1917655)
\[5\][PostgreSQL主备切换](https://www.cnblogs.com/lottu/p/7490759.html)
\[6\][PostgreSQL 流复制的主备切换](https://blog.csdn.net/qq_43303221/article/details/85777529)