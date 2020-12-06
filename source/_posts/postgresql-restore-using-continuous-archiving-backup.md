---
title: PostgreSQL使用连续归档备份恢复数据库
tags:
  - PostgresQL
id: '7002'
categories:
  - - Database
date: 2015-12-06 21:29:27
---


<!-- more -->
当数据库因为各种原因损坏时，连续归档备份就派上用场了，不过这种恢复在对停机时间很苛刻的环境下并不是很合适。
如果数据库很大的话，恢复时间可能是不可接受的，这时候就应该配置高可用实时复制系统，比如配置warm/hot standby备用机。

此文中的$PG_VERISON代表postgresql的主次版本号，比如当前为9.4。

**数据恢复**

1.  停止服务器
如果服务器还在运行中，应该先将其停止。如果硬件故障已无法开机，则可以在异机恢复。这里以异机恢复为例讲解。
```js
$ sudo service postgresql stop
```
2.  删除现有集群数据
将当前postgresql集群数据目录下的所有文件删除，删除debian默认安装postgresql集群数据：
```js
$ sudo rm -rf /var/lib/postgresql/$PG_VERSION/main/*
```
3.  恢复基础备份
将最近的基础备份恢复到集群的数据目录：
```js
$ sudo -u postgres tar jxvf 20151207.tbz2 -C /var/lib/postgresql/$PG_VERSION/main/
```
一定要注意恢复的数据文件的属主是运行PostgreSQL服务的系统用户，debian系统上为postgres,还应该保持原来的权限。
4.  pg_xlog目录
如果进行基础备份时，pg_xlog目录下有未归档日志，恢复后应将目录下的所有文件删除，因为这些文件已经过时。如果没有pg_xlog目录则建立此目录，注意目录的属主和权限。
主服务器崩溃后如果尚未归档的WAL日志还能访问，则应将其拷贝到pg_xlog目录，以尽最大可能恢复数据。
5.  配置recovery.conf文件
如果使用pg_basebackup命令进行备份时使用了-R(--write-recovery-conf)参数,则恢复后的数据目录中已经有了一个recovery.conf文件。如果没有，则可以拷贝一个模板到数据目录：
```js
$ sudo -u postgres cp /usr/share/postgresql/$PG_VERSION/recovery.conf.sample /var/lib/postgresql/$PG_VERSION/main/
```

然后修改文件中的restore_command为适当的shell脚本以在恢复时可以读取到归档的WAL日志：
```js
restore_command = 'cp /var/backups/postgresql/archive/%f %p'
```

因为此案例没有使用流复制，因此应该注释掉primary_conninfo参数。

恢复期间还应该修改pg_hba.conf文件或其他途径以阻止客户端连接。
6.  启动服务器，开始恢复
```js
$ sudo service postgresql start
```
当所有的归档WAL恢复完毕,无法读取到其他更新的归档日志后，恢复就会自动结束，并且recovery.conf会被更名为recovery.done,防止意外重新进入restore过程。
恢复完毕后，可以允许客户端连接到服务器。
注意，恢复的最后阶段，日志中会出现No such file or directory字样的提示，这是正常的，因为恢复过程已经无法读取到其他的归档日志文件或时间线history文件。
```js
2015-12-07 09:24:42 CST \[4906-5\] LOG: consistent recovery state reached at 1/86008798
cp: cannot stat ‘/var/backups/postgresql/archive/000000010000000100000087’: No such file or directory
2015-12-07 09:24:42 CST \[4906-6\] LOG: redo done at 1/86008798
2015-12-07 09:24:42 CST \[4906-7\] LOG: last completed transaction was at log time 2015-12-07 08:57:51.075265+08
2015-12-07 09:24:42 CST \[4906-8\] LOG: restored log file "000000010000000100000086" from archive
cp: cannot stat ‘/var/backups/postgresql/archive/00000002.history’: No such file or directory
2015-12-07 09:24:42 CST \[4906-9\] LOG: selected new timeline ID: 2
cp: cannot stat ‘/var/backups/postgresql/archive/00000001.history’: No such file or directory
2015-12-07 09:24:42 CST \[4906-10\] LOG: archive recovery complete
2015-12-07 09:24:42 CST \[4906-11\] LOG: MultiXact member wraparound protections are now enabled
2015-12-07 09:24:42 CST \[4924-1\] LOG: autovacuum launcher started
2015-12-07 09:24:42 CST \[4905-1\] LOG: database system is ready to accept connections
```

**时间点恢复Point-in-Time Recovery (PITR)**

默认情况下，恢复过程会一直持续到最后一个可用的WAL归档日志。
但是也可以在recovery.conf中设置参数来控制恢复到的目标点，这四个参数recovery_target,recovery_target_name，recovery_target_time和recovery_target_xid可以用来指定恢复的目标点，但同时只能有一个生效，如果指定多个，则以最后一个为准。

这几个参数的含义如下：

*   recovery_target
该参数目前只有一个取值'immediate',指示恢复应该在达到一直状态后尽快的结束。对于连续归档备份来说，基础备份结束时就处于一致状态。
*   recovery_target_name
指定使用pg_create_restore_point()函数设定的恢复点名称。pg_create_restore_point()可以创建一个命名的恢复日志记录作为恢复目标，此函数只有超级用户可以访问。
*   recovery_target_time
指定恢复所要到达的时间戳。注意，recovery_target_time 设置的时间格式,使用pg的now函数输出的格式。比如：
```js
recovery_target_time = '2015-02-13 20:04:49.63197+08' 
```
*   recovery_target_xid
指定恢复过程要到达的事务id。要注意，事务id在事务开始时顺序赋值，但每个事务的完成不一定会遵循先后顺序，因此指定这个参数，只有那些在此事务id之前启动的事务会被恢复。

还有几个参数会影响恢复目标的设定以及到达恢复目标时的动作：

*   recovery_target_inclusive
此参数只影响recovery_target_time和recovery_target_xid参数。当设定为true时，会包含恢复目标，而设定为false时，会恢复到恢复目标之前而不包含恢复目标。此参数默认为true。
*   recovery_target_timeline
指定在一个特定的时间线上恢复。默认在与制作基础备份相同的时间线上恢复。设置为latest会在归档日志中最新的时间线上恢复。
*   pause_at_recovery_target
指定当到达恢复目标是是否应该暂停，默认为true。此参数的意图是允许查询数据库来检查当前的恢复目标是否是想要的恢复点。
如果当前恢复目标并不是想要的，可以停止服务器，修改恢复目标设置，重新开始恢复数据库。
可以使用pg_xlog_replay_resume()函数来结束暂停继续恢复数据库，此时会一直恢复到最后的一致状态。

没有指定恢复目标，或者没有处于hot_standby状态时，这个参数并不生效。

**恢复时间线timeline**

在做数据恢复时，如果能像时间旅行或者并行宇宙中那样来来回回随意穿梭就好了。比如，恢复一次之后，发现不满意，可以从头再来，直到找到满意的恢复点为止。

幸好，PostgreSQL支持时间线timeline，正好支持了这种“超能力”。如果没有时间线，每次恢复之后新产生的WAL日志极有可能会将部分之前的WAL日志覆盖，从而再也无法恢复到那些状态。

时间线是这样的，无论何时，一个恢复完成后，会创建一个新的时间线来标识此次恢复之后产生的WAL日志。时间线的id号是WAL日志文件名字的一部分，因此不会覆盖其他时间线上的WAL日志文件。

每次创建一个新的时间线时，PostgreSQL会创建一个新的时间线历史文件，后缀为.history。历史文件会标识此时间线是什么时候从那个时间线分支而来的。有了时间线历史文件，PostgreSQL就可以在含有多个时间线的归档文件中找到正确的WAL归档日志。

虽然时间线看起来的确很高能，但是无论如何也不可能恢复到制作基础备份之前的时间。

References:
\[1\][24.3. Continuous Archiving and Point-in-Time Recovery (PITR)](http://www.postgresql.org/docs/9.2/static/continuous-archiving.html)
\[2\][26.2. Recovery Target Settings](http://www.postgresql.org/docs/current/static/recovery-target-settings.html)
\[3\][postgresql在线备份与恢复(三)](http://my.oschina.net/hippora/blog/378415)

**\===
\[erq\]**