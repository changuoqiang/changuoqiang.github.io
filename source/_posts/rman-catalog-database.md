---
title: 使用恢复目录catalog备份目标数据库
tags:
  - Oracle
id: '1985'
categories:
  - - Database
date: 2012-03-21 13:14:44
---

默认情况下,rman使用目标数据库的控制文件存储备份恢复需要的相关信息,显然这很不安全。
<!-- more -->
一般目标控制数据库控制文件丢失,恢复起来就相当的麻烦。所以使用rman的恢复目录来存储备份恢复信息更安全一些，这玩意儿就是catalog。

目录数据库平台:oracle 10.2.0.4 64bits on debian amd64,实例名db_catalog
目标数据库平台:oracle 10.2.0.4 64bits on windows 2003 r2 sp2 x64,实例名db_target
 **1、为恢复目录(catalog)创建表空间**

$sqlplus sys/passwd@db_catalog as sysdba; 
SQL>create tablespace rman_ts datafile '/u01/app/oracle/product/10.2.0/oradata/db_catalog/rman_ts01.dbf' size 50m;

Tablespace created.

**2、创建rman使用的schema,并授予适当的权限**

$sqlplus sys/passwd@db_catalog as sysdba;
SQL>create user rman_usr identified by rman_usr default tablespace rman_ts temporary tablespace temp quota unlimited on rman_ts;

User created.

SQL>grant recovery_catalog_owner to rman_usr;

Grant succeeded.

SQL>grant connect,resource to rman_usr;

Grant succeeded.

**3、创建恢复目录catalog**

$rman catalog rman_usr/rman_usr@db_catalog;
RMAN> create catalog tablespace rman_ts;

recovery catalog created

**4、在恢复目录中注册目标数据库**

$rman catalog rman_usr/rman_usr@db_catalog target sys/passwd@db_target;
RMAN> register database;

database registered in recovery catalog
starting full resync of recovery catalog
full resync complete

**\===
\[erq\]**