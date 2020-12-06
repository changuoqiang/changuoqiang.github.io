---
title: oracle 临时表空间扩容
tags:
  - Oracle
id: '3211'
categories:
  - - Database
date: 2013-09-29 10:16:48
---

临时表空间主要用途是在数据库进行排序运算、管理索引、访问视图等操作时提供临时的运算空间，当运算完成之后系统会自动清理。临时表空间不足时会影响系统性能。
<!-- more -->
**查询临时表空间**
\[sql\]
sql> select file_name,tablespace_name,bytes/1024/1024 as "total temp space(M)" from dba_temp_files;
FILE_NAME TABLESPACE_NAME total temp space(M)
-------------------------------------- --------------------- ----------------
D:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\TEMP01.DBF TEMP 1000
\[/sql\]
**查看临时表空间剩余容量**
\[sql\]
SQL> select tablespace_name,bytes_free/1024/1024 "free temp space(M)" from v$temp_space_header;
TABLESPACE_NAME free temp space(M)
-------------------------- ------------------
TEMP 805
\[/sql\]
**重新设定临时表空间容量**
\[sql\]
SQL> alter database tempfile 'D:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\TEMP01.DBF' resize 1024M;
Database altered
\[/sql\]