---
title: PostgreSQL 11数据库参数优化
tags:
  - PostgresQL
id: '8797'
categories:
  - - Database
  - - GNU/Linux
date: 2019-10-08 17:07:53
---


<!-- more -->
服务器资源状况：
32GB内存
4路8核心CPU，逻辑核心32颗

postgresql.conf配置文件部分参数：

**shared_buffers**
设置为系统内存的40%，过多无益

**work_mem**
单个查询排序所用内存，work_mem*所有用户数的全部查询数=占用系统内存，因此如果并发用户很多，此参数不宜设置多大，比如设置为128MB，如果同时有10个并发查询，则会占用1280MB系统内存

**maintenance_work_mem**
维护类工作使用的内存，比如VACUUM, CREATE INDEX, and ALTER TABLE ADD FOREIGN KEY等，因为每一个数据库session同时只能执行一个此类操作，因为可以将其设置的大一点儿，可以提高此类操作的性能。

**effective_cache_size**
用于query planner估算系统可用内存，并不是真正的分配内存，可以设置为系统内存的1/2到3/4大小。


调优参数汇总:
```js
shared_buffers = 12GB
work_mem = 128MB
maintenance_work_mem = 2GB
effective_cache_size = 24GB
max_connections = 2000
max_prepared_transactions = 2000
```


References:
\[1\][Tuning Your PostgreSQL Server](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)
\[2\][PGTune](https://pgtune.leopard.in.ua/#/)