---
title: oracle 10g 重做日志归档路径参数
tags:
  - Oracle
id: '1616'
categories:
  - - Database
date: 2011-10-31 10:26:30
---

oracle 10g redo log归档路径参数
<!-- more -->
oracle 10g版本
```js
SQL> select * from v$version;

BANNER
----------------------------------------------------------------
Oracle Database 10g Enterprise Edition Release 10.2.0.4.0 - 64bi
PL/SQL Release 10.2.0.4.0 - Production
CORE 10.2.0.4.0 Production
TNS for 64-bit Windows: Version 10.2.0.4.0 - Production
NLSRTL Version 10.2.0.4.0 - Production
```

oracle 10g默认的归档路径为USE_DB_RECOVERY_FILE_DEST
```js
SQL> archive log list
Database log mode No Archive Mode
Automatic archival Disabled
Archive destination USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence 9
Current log sequence 11
```
查看该参数
```js
SQL> show parameter db_recovery_file_dest;

X:\\oracle\\product\\10.2.0\\flash_recovery_area
```
修改归档路径

LOG_ARCHIVE_DEST参数用来设置本地归档，LOG_ARCHIVE_DUPLEX_DEST参数设置第二个本地归档路径，而LOG_ARCHIVE_DEST_n既可以设置本地归档路径，也可以设置网络归档路径，dataguard环境下需要使用这组参数。

db_recovery_file_dest,LOG_ARCHIVE_DEST以及LOG_ARCHIVE_DEST_n这三组参数是互不兼容的，设置其中一组，必须将其他两组的参数置空,否则会提示错误:

```js
ORA-02097: parameter cannot be modified because specified value is invalid
ORA-16018: cannot use LOG_ARCHIVE_DEST with LOG_ARCHIVE_DEST_n or DB_RECOVERY_FILE_DEST
```
设置log_archive_dest参数
```js
SQL> alter system set db_recovery_file_dest='';
SQL> alter system set log_archive_dest='path to store redo logs';
```
当使用LOG_ARCHIVE_DEST_n参数时，还要设置LOG_ARCHIVE_DEST_STATE_n参数来启用或禁止相对应的归档路径。