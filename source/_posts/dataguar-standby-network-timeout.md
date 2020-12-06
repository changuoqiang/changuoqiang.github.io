---
title: Dataguard配置中phsycia standby备库网络超时故障一例
tags:
  - Oracle
id: '6517'
categories:
  - - Database
date: 2015-07-17 13:35:44
---


<!-- more -->
本来DG已经配置为最大可用模式(maximize availability)了，也就是说如果物理备库无法访问，不应该影响主库的运行才对。
但是有一条光纤物理链路出现故障严重丢包，导致主库向其传输归档日志时出现超时错误，无法归档，导致主库运行十分缓慢，直至无法正常访问。

alert_orcl.log文件中有如下错误记录:
```js
Fri Jul 17 00:34:32 2015
ORA-16198: LGWR received timedout error from KSR
LGWR: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (16198)
LGWR: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 00:34:32 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Network asynch I/O wait error 16198 log 1 service 'db_feich'
Fri Jul 17 00:34:32 2015
Destination LOG_ARCHIVE_DEST_3 is UNSYNCHRONIZED
LGWR: Failed to archive log 1 thread 1 sequence 4526 (16198)
Fri Jul 17 00:34:32 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Error 16198 closing archivelog file 'db_feich'
LGWR: Error 16198 disconnecting from destination LOG_ARCHIVE_DEST_3 standby host 'db_feich'
Fri Jul 17 00:34:42 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4527
LGWR: Standby redo logfile selected for thread 1 sequence 4527 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:34:43 2015
Thread 1 advanced to log sequence 4527 (LGWR switch)
 Current log# 2 seq# 4527 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 00:37:18 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4528
LGWR: Standby redo logfile selected for thread 1 sequence 4528 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:37:18 2015
Thread 1 advanced to log sequence 4528 (LGWR switch)
 Current log# 3 seq# 4528 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 00:40:00 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4529
LGWR: Standby redo logfile selected for thread 1 sequence 4529 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:40:00 2015
Thread 1 advanced to log sequence 4529 (LGWR switch)
 Current log# 1 seq# 4529 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
Fri Jul 17 00:40:05 2015
ARC1: LGWR is actively archiving destination LOG_ARCHIVE_DEST_3
ARC1: Standby redo logfile selected for thread 1 sequence 4528 for destination LOG_ARCHIVE_DEST_3
Fri Jul 17 00:40:06 2015
Thread 1 cannot allocate new log, sequence 4530
Checkpoint not complete
 Current log# 1 seq# 4529 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
LNSc started with pid=88, OS id=3680
Fri Jul 17 00:40:16 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4530
LGWR: Standby redo logfile selected for thread 1 sequence 4530 for destination LOG_ARCHIVE_DEST_3
LGWR: Standby redo logfile selected to archive thread 1 sequence 4530
LGWR: Standby redo logfile selected for thread 1 sequence 4530 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:40:21 2015
Thread 1 advanced to log sequence 4530 (LGWR switch)
 Current log# 2 seq# 4530 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 00:40:21 2015
ARC0: LGWR is actively archiving destination LOG_ARCHIVE_DEST_3
Fri Jul 17 00:40:44 2015
ARC0: Standby redo logfile selected for thread 1 sequence 4529 for destination LOG_ARCHIVE_DEST_3
Fri Jul 17 00:48:36 2015
ORA-16198: LGWR received timedout error from KSR
LGWR: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (16198)
LGWR: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 00:48:36 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Network asynch I/O wait error 16198 log 2 service 'db_feich'
Fri Jul 17 00:50:58 2015
LGWR: Failed to archive log 2 thread 1 sequence 4530 (16198)
Fri Jul 17 00:50:58 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Error 16198 closing archivelog file 'db_feich'
LGWR: Standby redo logfile selected to archive thread 1 sequence 4531
LGWR: Standby redo logfile selected for thread 1 sequence 4531 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:51:07 2015
Thread 1 advanced to log sequence 4531 (LGWR switch)
 Current log# 1 seq# 4531 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
Fri Jul 17 00:54:12 2015
Thread 1 cannot allocate new log, sequence 4532
All online logs needed archiving
 Current log# 1 seq# 4531 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
Fri Jul 17 00:56:10 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4532
LGWR: Standby redo logfile selected for thread 1 sequence 4532 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:56:10 2015
Thread 1 advanced to log sequence 4532 (LGWR switch)
 Current log# 2 seq# 4532 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 00:56:10 2015
ARC0: LGWR is actively archiving destination LOG_ARCHIVE_DEST_3
ARC0: Standby redo logfile selected for thread 1 sequence 4531 for destination LOG_ARCHIVE_DEST_3
Fri Jul 17 00:58:53 2015
ARC1: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (12571)
ARC1: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 00:58:53 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-12571: TNS:packet writer failure

ARC1: I/O error 12571 archiving log 3 to 'db_feich'
Fri Jul 17 00:58:54 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-01041: internal error. hostdef extension doesn't exist

ARC1: Error 1041 Closing archive log file 'db_feich'
LNSc started with pid=46, OS id=3000
Fri Jul 17 00:59:30 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4533
LGWR: Standby redo logfile selected for thread 1 sequence 4533 for destination LOG_ARCHIVE_DEST_3
LGWR: Standby redo logfile selected to archive thread 1 sequence 4533
LGWR: Standby redo logfile selected for thread 1 sequence 4533 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 00:59:35 2015
Thread 1 advanced to log sequence 4533 (LGWR switch)
 Current log# 3 seq# 4533 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 01:05:13 2015
ORA-16198: LGWR received timedout error from KSR
LGWR: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (16198)
LGWR: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 01:05:13 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Network asynch I/O wait error 16198 log 3 service 'db_feich'
Fri Jul 17 01:07:52 2015
Thread 1 cannot allocate new log, sequence 4534
All online logs needed archiving
 Current log# 3 seq# 4533 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 01:23:03 2015
ARC1: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (12571)
ARC1: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 01:23:03 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-12571: TNS:packet writer failure

FAL\[server, ARC1\]: FAL archive failed, see trace file.
Fri Jul 17 01:23:03 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-16055: FAL request rejected

ARCH: FAL archive failed. Archiver continuing
Fri Jul 17 02:01:41 2015
>>> WAITED TOO LONG FOR A ROW CACHE ENQUEUE LOCK! pid=128
System State dumped to trace file e:\\oracle\\product\\10.2.0\\admin\\orcl\\udump\\orcl_ora_2960.trc
Fri Jul 17 02:05:22 2015
ARC1: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (12571)
ARC1: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 02:05:22 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-12571: TNS:packet writer failure

FAL\[server, ARC1\]: FAL archive failed, see trace file.
Fri Jul 17 02:05:22 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-16055: FAL request rejected

ARCH: FAL archive failed. Archiver continuing
Fri Jul 17 02:05:25 2015
LGWR: Failed to archive log 3 thread 1 sequence 4533 (16198)
Fri Jul 17 02:05:25 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-16198: Timeout incurred on internal channel during remote archival

LGWR: Error 16198 closing archivelog file 'db_feich'
LGWR: Error 16198 disconnecting from destination LOG_ARCHIVE_DEST_3 standby host 'db_feich'
Fri Jul 17 02:05:36 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4534
LGWR: Standby redo logfile selected for thread 1 sequence 4534 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:05:36 2015
Thread 1 advanced to log sequence 4534 (LGWR switch)
 Current log# 2 seq# 4534 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 02:07:39 2015
Thread 1 cannot allocate new log, sequence 4535
All online logs needed archiving
 Current log# 2 seq# 4534 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
LNSc started with pid=44, OS id=3356
Fri Jul 17 02:11:42 2015
Error 12637 received logging on to the standby
Fri Jul 17 02:11:42 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-12637: Packet receive failed

PING\[ARC1\]: Heartbeat failed to connect to standby 'db_feich'. Error is 12637.
Fri Jul 17 02:12:02 2015
Error 28547 received logging on to the standby
Fri Jul 17 02:12:06 2015
LGWR: Error 28547 creating archivelog file 'db_feich'
Fri Jul 17 02:12:06 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-28547: connection to server failed, probable Oracle Net admin error

LGWR: Standby redo logfile selected to archive thread 1 sequence 4535
LGWR: Standby redo logfile selected for thread 1 sequence 4535 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:12:11 2015
Thread 1 advanced to log sequence 4535 (LGWR switch)
 Current log# 3 seq# 4535 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 02:14:11 2015
Thread 1 cannot allocate new log, sequence 4536
All online logs needed archiving
 Current log# 3 seq# 4535 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 02:17:20 2015
LGWR: Failed to archive log 3 thread 1 sequence 4535 (28547)
LNSc started with pid=46, OS id=4036
Fri Jul 17 02:17:33 2015
Error 12170 received logging on to the standby
Fri Jul 17 02:17:33 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc1_2584.trc:
ORA-12170: TNS:Connect timeout occurred

PING\[ARC1\]: Heartbeat failed to connect to standby 'db_feich'. Error is 12170.
Fri Jul 17 02:17:44 2015
Error 12170 received logging on to the standby
Fri Jul 17 02:17:48 2015
LGWR: Error 12170 creating archivelog file 'db_feich'
Fri Jul 17 02:17:48 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_lgwr_1568.trc:
ORA-12170: TNS:Connect timeout occurred

Fri Jul 17 02:17:53 2015
ARC0: Attempting destination LOG_ARCHIVE_DEST_3 network reconnect (12571)
ARC0: Destination LOG_ARCHIVE_DEST_3 network reconnect abandoned
Fri Jul 17 02:17:53 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc0_2784.trc:
ORA-12571: TNS:packet writer failure

ARC0: I/O error 12571 archiving log 1 to 'db_feich'
Fri Jul 17 02:17:53 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4536
LGWR: Standby redo logfile selected for thread 1 sequence 4536 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:17:53 2015
Thread 1 advanced to log sequence 4536 (LGWR switch)
 Current log# 2 seq# 4536 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 02:17:57 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc0_2784.trc:
ORA-01041: internal error. hostdef extension doesn't exist

Fri Jul 17 02:17:57 2015
ARC0: Error 1041 Closing archive log file 'db_feich'
Fri Jul 17 02:19:45 2015
LGWR: Failed to archive log 2 thread 1 sequence 4536 (12170)
LGWR: Standby redo logfile selected to archive thread 1 sequence 4537
LGWR: Standby redo logfile selected for thread 1 sequence 4537 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:19:51 2015
Thread 1 advanced to log sequence 4537 (LGWR switch)
 Current log# 1 seq# 4537 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
Fri Jul 17 02:21:23 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4538
LGWR: Standby redo logfile selected for thread 1 sequence 4538 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:21:23 2015
Thread 1 advanced to log sequence 4538 (LGWR switch)
 Current log# 3 seq# 4538 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO03.LOG
Fri Jul 17 02:22:55 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4539
LGWR: Standby redo logfile selected for thread 1 sequence 4539 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 02:22:55 2015
Thread 1 advanced to log sequence 4539 (LGWR switch)
 Current log# 2 seq# 4539 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO02.LOG
Fri Jul 17 02:22:55 2015
ARC0: LGWR is actively archiving destination LOG_ARCHIVE_DEST_3
Fri Jul 17 02:23:16 2015
Error 12170 received logging on to the standby
Fri Jul 17 02:23:16 2015
Errors in file e:\\oracle\\product\\10.2.0\\admin\\orcl\\bdump\\orcl_arc0_2784.trc:
ORA-12170: TNS:Connect timeout occurred

ARC0: Error 12170 Creating archive log file to 'db_feich'
Fri Jul 17 05:22:08 2015
LGWR: Standby redo logfile selected to archive thread 1 sequence 4540
LGWR: Standby redo logfile selected for thread 1 sequence 4540 for destination LOG_ARCHIVE_DEST_2
Fri Jul 17 05:22:08 2015
Thread 1 advanced to log sequence 4540 (LGWR switch)
 Current log# 1 seq# 4540 mem# 0: E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\REDO01.LOG
Fri Jul 17 05:23:19 2015
Suppressing further error logging of LOG_ARCHIVE_DEST_3.
Fri Jul 17 05:23:40 2015
Error 12170 received logging on to the standby
Suppressing further error logging of LOG_ARCHIVE_DEST_3.
```

这错误从早上０点多就出现了。
trace文件中有如下错误：
```js
*** 2015-07-17 00:34:32.348 57480 kcrr.c
Making upinblc request to LNSc (ocis 0x000000001677E828). Begin time is <07/17/2015 00:34:32> and NET_TIMEOUT is <180> seconds
NetServer pid:2832
LGWR had received a timeout previously. return timeout again
LGWR had received a timeout previously. return timeout again
Error 16198 closing standby archive log file at host 'db_feich'
ORA-16198: Timeout incurred on internal channel during remote archival
Archive destination LOG_ARCHIVE_DEST_3 made inactive: File close error
*** 2015-07-17 00:34:32.351 62692 kcrr.c
LGWR: Error 16198 closing archivelog file 'db_feich'
LGWR had received a timeout previously. return timeout again
Error 16198 detaching RFS from standby instance at host 'db_feich'
*** 2015-07-17 00:34:32.392 57269 kcrr.c
Making upidhs request to LNSc (ocis 0x000000001677E828). Begin time is <07/17/2015 00:34:32> and NET_TIMEOUT <180> seconds
NetServer pid:2832
*** 2015-07-17 00:34:36.392
*** 2015-07-17 00:34:36.392 57391 kcrr.c
Cleaninup up LNS12 \[pid 2832\] after network detach
*** 2015-07-17 00:34:36.397 54392 kcrr.c
LNSc \[pid 2832\] receiving termination signal..
 .... killed successfully
 .. pmon posted for async lns cleanup
*** 2015-07-17 00:34:37.597 62692 kcrr.c
LGWR: Error 16198 disconnecting from destination LOG_ARCHIVE_DEST_3 standby host 'db_feich'
Ignoring krslcmp() detach error 16198
Receiving message from LNSb
*** 2015-07-17 00:34:42.863 57625 kcrr.c
Making upinbls request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:34:37> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
*** 2015-07-17 00:37:13.051
*** 2015-07-17 00:37:13.051 57480 kcrr.c
Making upinblc request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:37:13> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
Receiving message from LNSb
Receiving message from LNSb
*** 2015-07-17 00:37:18.509 57625 kcrr.c
Making upinbls request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:37:13> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
*** 2015-07-17 00:39:54.545
*** 2015-07-17 00:39:54.545 57480 kcrr.c
Making upinblc request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:39:54> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
Receiving message from LNSb
Receiving message from LNSb
*** 2015-07-17 00:40:00.802 57625 kcrr.c
Making upinbls request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:39:54> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
*** 2015-07-17 00:40:12.967
*** 2015-07-17 00:40:12.967 57480 kcrr.c
Making upinblc request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:40:12> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
Receiving message from LNSb
*** 2015-07-17 00:40:13.066 55452 kcrr.c
Initializing NetServer\[LNSc\] for dest=db_feich mode SYNC
LNSc is not running anymore. 
New SYNC LNSc needs to be started
Waiting for subscriber count on LGWR-LNSc channel to go to zero
Subscriber count went to zero - time now is <07/17/2015 00:40:13>
Starting LNSc ...
Waiting for LNSc to initialize itself
*** 2015-07-17 00:40:16.083 55743 kcrr.c
Netserver LNSc \[pid 3680\] for mode SYNC has been initialized
Performing a channel reset to ignore previous responses
Successfully started LNSc \[pid 3680\] for dest db_feich mode SYNC ocis=0x000000001677E828
*** 2015-07-17 00:40:16.083 56246 kcrr.c
Making upiahm request to LNSc \[pid 3680\]: Begin Time is <07/17/2015 00:40:13>. NET_TIMEOUT = <180> seconds
Waiting for LNSc to respond to upiahm
*** 2015-07-17 00:40:16.156 56410 kcrr.c
 upiahm connect done status is 0
Receiving message from LNSc
Receiving message from LNSc
Receiving message from LNSc
*** 2015-07-17 00:40:16.508 57625 kcrr.c
Making upinbls request to LNSc (ocis 0x000000001677E828). Begin time is <07/17/2015 00:40:13> and NET_TIMEOUT is <180> seconds
NetServer pid:3680
Receiving message from LNSb
*** 2015-07-17 00:40:21.818 57625 kcrr.c
Making upinbls request to LNSb (ocis 0x000000001677E580). Begin time is <07/17/2015 00:40:16> and NET_TIMEOUT is <180> seconds
NetServer pid:3584
*** 2015-07-17 00:40:42.129
LGWR found LNSc alive.. waiting for msg
*** 2015-07-17 00:40:52.140
LGWR found LNSc alive.. waiting for msg
*** 2015-07-17 00:41:03.356
LGWR found LNSc alive.. waiting for msg
*** 2015-07-17 00:41:18.972
```

按官方文档讲，DG最大可用模式下备库不可用是可以自动降级到最大性能模式的，但这次没有，主库的运行受到了影响。
因为物理链路修复没有时间表，因此当务之急时先略过或禁用出故障的备库。

首先尝试将DG降级到最大性能模式：
\[sql\]
SQL>alter database set standby database to maximize performance;
\[/sql\]

无果

禁用出故障的备库：
\[sql\]
SQL>alter system set log_archive_dest_state_3 = defer;
SQL>shutdown immediate
SQL>startup
\[/sql\]
故障解除。而且需要重新启动数据库。

LOG_ARCHIVE_DEST_STATE_n参数，可以取值alternate reset defer enable，其含义如下：

*   alternate
备用。只有当其他归档目标失效时才尝试使用本归档目标。
*   defer
保留配置信息，但从归档目标中删除，直到重新启用。
*   enable
启用。这是默认值。

 **UPDATE(06/05/2016):**

在未禁用有网络故障的standby备库的情况下，如果重新启动数据库，有可能startup过程会一直卡在Database mounted.处

从alert.log看，主库正在向有网络故障的备库同步归档日志文件，因为网络不通畅就卡住了，此时将备库禁用后，重新启动数据库就可以了。

**\====
\[erq\]**