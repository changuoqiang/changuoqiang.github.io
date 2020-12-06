---
title: PostgreSQL高可用之streaming replication based hot standby
tags:
  - PostgresQL
id: '7033'
categories:
  - - Database
date: 2015-12-10 21:26:05
---


<!-- more -->
前面讲了基于日志文件传输的warm/hot standby配置，但日志文件传输的最大问题在于延迟。

单个日志文件要空间满了或者到了归档超时时间才会传输然后应用到备库，每个日志文件有16MB大小。这会造成较大的延迟，如果主库当机，则数据损失会较大。如果缩小归档超时时间，又会造成大量的空间浪费。

基于流复制则解决了这些问题。备库会连接到主库，不用等待WAL日志文件填满就可以立即传输完成的WAL记录到备库。
流复制默认是异步的，这样主库和备库之间会有微小的延迟，极端情况下可能会有极少的数据丢失。

流复制不依赖于归档模式archive_mode和归档日志。但是部署流复制的同时，开启归档也是有必要的。不能把鸡蛋放到一个篮子里。基于日志文件传输或流复制的高可用warm/hot standby配置仍然很难防范主库误删除数据的问题。

基于流复制同样可以实现warm或者hot standby配置。

**流复制hot standby配置步骤**

1.  主库复制用户认证配置
使用超级用户postgres或者新建一个超级用户作为备库连接到主库进行复制的用户，修改pg_hba.conf文件:
```js
host replication postgres 192.168.0.0/24 md5
```
2.  主库postgresql.conf配置
```js
wal_level = hot_standby
max_wal_senders = 5
wal_keep_segments = 30
```
max_wal_senders参数要比standby备库的数量再多一些，防止某些备库连接中断但尚未完全释放连接，如果参数设置过小，重新连接时可能会失败。
流复制模式下，pg_xlog目录下的WAL日志文件会循环利用，如果备库应用日志跟不上主库产生日志的速度，或者备库故障导致无法应用主库的日志，此时，主库的日志可能会被覆盖，从而导致备库需要重新建立。
当然如果同时做了归档备份，并且备库能访问到WAL日志归档目录，则备库会从归档备份目录来获取所需要的归档日志。

wal_keep_segments这个参数只能根据实际情况来估算，并不会很精确。参数设置小了，有可能需要的日志会被覆盖,设置大了会占用主库大量的存储空间。
流复制槽可以解决WAL日志循环覆盖的问题，只要备库没有应用主库的WAL日志，则这些日志会一直保存，直到备库不再需要这些日志。设置流复制槽时，如果备库一直下线，则需要注意主库的存储空间是否充裕。
3.  使用基础备份搭建备库
详见前文所述。
4.  备库端配置
postgresql.conf文件:
```js
hot_standby = on
```
recovery.conf文件:
```js
standby_mode = 'on'
primary_conninfo = 'host=192.168.0.80 port=5432 user=postgres password=pass'
trigger_file = '/var/lib/postgresql/trigger'
```
5.  启动备库
日志中有类似如下文本:
```js
LOG: started streaming WAL from primary at 1/B0000000 on timeline 1
```
6.  复制信息查看
主库端：
```js
postgres=# select pg_current_xlog_location();
 pg_current_xlog_location 
--------------------------
 1/B0142910
(1 row)
postgres=# \\x
Expanded display is on.
postgres=# select * from pg_stat_replication;
-\[ RECORD 1 \]----+-----------------------------
pid 11471
usesysid 19670
usename reis
application_name walreceiver
client_addr 192.168.0.5
client_hostname 
client_port 44247
backend_start 2015-12-10 22:04:45.47403+08
backend_xmin 
state streaming
sent_location 1/B01572F0
write_location 1/B01572F0
flush_location 1/B01572F0
replay_location 1/B0157268
sync_priority 0
sync_state async
```

备库端:
```js
postgres=# select pg_last_xlog_receive_location();
 pg_last_xlog_receive_location 
-------------------------------
 1/B0170B90
(1 row)
```

**配置复制槽**

1.  主库端
创建流复制槽:
```js
postgres=# select pg_create_physical_replication_slot('slot_1');
ERROR: replication slots can only be used if max_replication_slots > 0
```

所以要修改postgresql.conf文件:
```js
max_replication_slots = 5 
```
重启后，重新创建复制槽即可。
```js
postgres=# select pg_create_physical_replication_slot('slot_1');
 pg_create_physical_replication_slot 
-------------------------------------
 (slot_1,)
(1 row)
```
2.  备库端
recovery.conf文件:
```js
primary_slot_name = 'slot_1'
```
重新启动备库
3.  主库端检查复制槽状态
```js
postgres=# select * from pg_replication_slots;
 slot_name plugin slot_type datoid database active xmin catalog_xmin restart_lsn 
-----------+--------+-----------+--------+----------+--------+------+--------------+-------------
 slot_1 physical t 1/B1021F18
(1 row)

```
复制槽slot_1已经启用。启用复制槽后参数wal_keep_segments就没用了。

References:
\[1\][25.2.5. Streaming Replication](http://www.postgresql.org/docs/current/static/warm-standby.html)
\[2\][25.2.2. Standby Server Operation](http://www.postgresql.org/docs/current/static/warm-standby.html)
\[3\][PostgreSQL Hot Standby](http://www.cnblogs.com/mchina/archive/2012/05/26/2518350.html)
\[4\][postgresql高可用性之备库(二)](http://my.oschina.net/hippora/blog/380416)
\[5\][25.3. Failover](https://www.postgresql.org/docs/9.4/static/warm-standby-failover.html)

**\===
\[erq\]**