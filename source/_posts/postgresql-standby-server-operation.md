---
title: PostgreSQL Standby Server Operation
tags:
  - PostgresQL
id: '7051'
categories:
  - - Database
date: 2015-12-10 23:08:31
---


<!-- more -->
当standby备库启动时,首先会调用restore_command来恢复所有可用的归档日志。

如果没有配置restore_command或者恢复了所有的归档日志restore_command失败之后，stanby备库会尝试pg_xlog目录下所有可用的WAL日志。

pg_xlog目录下没有WAL日志或者已有的WAL日志全部恢复完毕后，如果配置了流复制，standby会尝试连接到主库，开始进行流式复制。

如果失败，或者没有配置流式复制，或者连接中断，standby会重新开始一个新的恢复循环。

从WAL归档日志，到pg_xlog,再到流式复制的恢复循环会一直持续到服务器停止或者退出standby模式。

可以使用pg_ctl promote命令或者找到触发文件时，备库退出standby模式并切换到正常操作模式，可以接受正常的读写请求。
在failover完成之前，所有restore_command可以访问的以及pg_xlog目录下的WAL日志会被恢复，但是不会连接到主库进行流式恢复。

References:
\[1\]25.2.2. Standby Server Operation

**\===
\[erq\]**