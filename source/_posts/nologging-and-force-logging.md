---
title: oracle数据库nologging和force logging模式
tags:
  - Oracle
id: '1601'
categories:
  - - Database
date: 2011-10-27 14:25:00
---

**查询force logging模式**

SQL> select log_mode,force_logging from v$database;
<!-- more -->
LOG_MODE FORCE_LOGGING
------------ -------------
ARCHIVELOG NO

**将数据库置为force logging模式**

SQL>alter database force logging;
Database altered.

**取消force logging模式**

SQL> ALTER DATABASE no force logging;
Database altered.