---
title: PostgreSQL性能诊断与处理
tags:
  - PostgresQL
id: '7746'
categories:
  - - Database
date: 2016-11-23 20:36:26
---


<!-- more -->
CPU负载居高不下，可以从这几方面入手查找原因，一个比较大的可能是有查询在长期占用CPU资源。

**查看当前连接数**

```js
=> SELECT count(*) FROM pg_stat_activity;
=> select client_addr, count(*) from pg_stat_activity group by client_addr;
```

可以查看总的连接数，以及每个客户端的连接数，判断是否有客户端泄露连接。

**查看连接状态**
```js
=> SELECT state, count(*) FROM pg_stat_activity GROUP BY state;
```

连接有以下几种状态：

*   idle
连接对应的后端进程处于空闲状态
*   actvie
连接对应的后端进程正在执行查询
*   idle in transaction
连接对应的后端进程在一个事务中，但当前并没有执行查询
*   idle in transaction (aborted)
在一个事务中，但是事务中的语句出现了错误，事务没有正确回滚
*   fastpath function call
正在执行fastpath函数调用
*   disabled
后端进程被配置为禁止跟踪

**等待锁的连接**

```js
=> SELECT count(distinct pid) FROM pg_locks WHERE granted = false;
```

查看是否有连接在等待排它锁导致效率低下

**查看事务最大执行时间**

```js
=> SELECT max(now() -xact_start) FROM pg_stat_activity WHERE state IN ('idle in transaction','active'); 
```
查看当前所有事务中最长事务的执行时间，一般来讲事务应该在数秒内结束，数分钟已经是很长的事务了。如果有事务的执行时间达到了小时的级别，那一定是出现了错误，但是事务还在占用系统资源，应该将其干掉。

**查看事务执行时间**

```js
=> SELECT pid, xact_start FROM pg_stat_activity ORDER BY xact_start ASC;
```
以事务的起始时间为顺序，如果某事务的运行时间过长，比如达到了小时级别，应该查清原因，然后搞掉它。

**杀掉后端进程**

```js
=> SELECT pg_cancel_backend(1234);
```

1234就是pg_stat_activity表里的pid,也是postgres进程的系统进程pid，不要用操作系统命令去搞死进程，要用postgresql提供的命令。

References:
\[1\][28.2. The Statistics Collector](https://www.postgresql.org/docs/9.6/static/monitoring-stats.html)
\[2\][Debug Slow Performance & High Resource Utilisation Issue in PostgreSQL](https://jee-appy.blogspot.in/2016/10/debug-postgresql-performance-issues.html)
\[3\][Find and Kill Long Running Process in PostgreSQL](https://jee-appy.blogspot.com/2016/10/find-and-kill-long-running-process-in.html)

**\===
\[erq\]**