---
title: Dataguard配置中primary不更新v$_archived_log的'APPLIED'列
tags:
  - Oracle
id: '7258'
categories:
  - - Database
date: 2016-05-13 08:28:48
---


<!-- more -->
Dataguard配置中因为网络故障出现了日志gap,修复gap后，恢复自动同步。

备库看一切正常：
```js
SQL> SELECT max(sequence#), applied FROM v$archived_log GROUP BY applied;
MAX(SEQUENCE#) APPLIED
-------------- ---------
 20114 YES
```

但主库确显示日志并未应用:
```js
SQL> SELECT max(sequence#), applied FROM v$archived_log GROUP BY applied;

MAX(SEQUENCE#) APPLIED
-------------- ---------
 20114 NO
```

其实日志已经正确的同步并应用了，只是primary没有更新applied列的值而已，这是个bug, 编号1369630.1

主库上有一个指定的ARCn进程与远程的RFS进程通讯来更新applied列的值，如果此进程挂起，无法与远程通讯也就无法更新v$archived_log的applied列值。

**解决方案**

主库ALERT_sid.LOG文件查找最新的,包含以下类似信息的行:
```js
ARCn: Becoming the heartbeat ARCH
```

说明ARCn进程/线程出问题挂起了,n是数字,比如ARC0

然后查找ARC0的进程/线程号,*nix平台是进程,windows平台是线程:

windows平台输出：
```js
SQL> SELECT spid, osuser, s.program FROM v$process p, v$session s WHERE p.addr=s.paddr and p.program like '%ARC0%'
SPID OSUSER PROGRAM
---------- ----------------- -----------------------
2616 SYSTEM ORACLE.EXE (ARC0)
```

将对应的进程/线程kill掉就可以了,oracle会重新启动相应的进程/线程。

*nix平台:

```js
# kill -9 processid 
```

windows平台:
```js
cmd> orakill sid threadid
```

sid是oracle实例名

**或者更简单粗暴的重新启动oracle实例**

alert_sid.log文件中可能会出现错误提示：
```js
ORA-16401: archivelog rejected by RFS
```

sid_arc0_xxxx.trc文件中也会有：
```js
Error 16401 creating standby archive log file at host 'xxx'
ORA-16401: archivelog rejected by RFS
```

这是出现重复归档的错误提示，因为ARC0想重新归档已经应用到备库的日志，可以安全的忽略掉这些信息，ARC0会更新已经传输到备库的日志的APPLIED列。

ORA-16401也可能出现在多个主库和/或备库向同一个备库归档的情形下，这种情况一般是因为LOG_ARCHIVE_DEST_n参数配置错误。

References:
\[1\][Oracle Data-guard Issues - 'APPLIED'-Column not updated in v$archived_log table](http://oracle-artifacts.blogspot.com/2012/04/oracle-data-guard-issues-applied-column.html)
\[2\][Bug Note: 1369630.1](https://docs.google.com/document/d/1drYAr6VVQh652kl7cvHFZXEmFlN5eYMrJr6q3hPtWO4/edit?pref=2&pli=1)
\[3\][ORACLE在windows上使用orakill结束oracle会话的线程](http://topmanopensource.iteye.com/blog/1171271)

**\===
\[erq\]**