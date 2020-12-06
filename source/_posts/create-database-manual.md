---
title: 手工创建oracle 10g数据库
tags:
  - Debian
  - Oracle
id: '2027'
categories:
  - - Database
date: 2012-04-01 09:48:31
---

操作系统为Debian Wheezy(当前仍为testing) AMD64,数据库为oracle 10g 10.2.0.4
<!-- more -->
安装oracle 10g 10.2.0.4时,因为要先安装10.2.0.1,然后再升级到10.2.0.4,所以没有建库,省却升级数据库的麻烦。

新建oracle数据库可以使用图形化的工具DBCA(Database Configuration Assistant),也可以使用CREATE DATABASE语句手工创建数据库。这里采用后者手工建库。

**手工新建oracle数据库**

**1、确定数据库实例标识符并设置相关环境变量,建立相关路径**

为数据库确定一个SID,并设置操作系统环境变量ORACLE_SID,此处新建数据库拟定的SID为catlogdb

设定环境变量
```js
export ORACLE_SID=catlogdb
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
```
创建需要的路径,相关路径设置参照[Optimal Flexible Architecture for 10.2](http://docs.oracle.com/cd/B19306_01/install.102/b15660/app_ofa.htm)
```js
$ mkdir -p $ORACLE_BASE/admin/$ORACLE_SID/{a,b,c,u}dump
//$ mkdir -p $ORACLE_BASE/admin/$ORACLE_SID/pfile
//$ mkdir -p $ORACLE_BASE/admin/$ORACLE_SID/create
//$ mkdir -p $ORACLE_BASE/admin/$ORACLE_SID/arch
$ mkdir -p /u01/oradata/$ORACLE_SID
$ mkdir -p $ORACLE_BASE/flash_recovery_area/$ORACLE_SID
```
**2、创建密码文件**
```js
$ orapwd file=$ORACLE_HOME/dbs/orapw$ORACLE_SID password=passwd_for_sys force=y
```
在目录$ORACLE_HOME/dbs目录下生成[密码文件](https://openwares.net/database/oracle_passwd_file.html)orapwcatlogdb,sys用户的密码为passwd_for_sys

**3、创建初始化参数文件**

oracle提供了一个样例[参数文件](https://openwares.net/database/pfile_and_spfile.html)$ORACLE_HOME/dbs/init.ora,可以根据需要增删修改初始化参数。

初始化参数命名为initcatlogdb.ora,其内容如下：
```js
db_name=catlogdb
compatible=10.2.0.4.0

nls_language=american
nls_territory=america

control_files=(/u01/oradata/catlogdb/control01.ctl,
 /u01/oradata/catlogdb/control02.ctl,
 /u01/oradata/catlogdb/control03.ctl)

db_block_size=8192
sga_target=960M
pga_aggregate_target=270M

processes=150
sessions=150
open_cursors=150

undo_management=auto
undo_tablespace=undotbs1

audit_file_dest=/u01/app/oracle/admin/catlogdb/adump
background_dump_dest=/u01/app/oracle/admin/catlogdb/bdump
core_dump_dest=/u01/app/oracle/admin/catlogdb/cdump
user_dump_dest=/u01/app/oracle/admin/catlogdb/udump

db_recovery_file_dest=/u01/app/oracle/flash_recovery_area/catlogdb
db_recovery_file_dest_size=1G
```

三个控制文件control01.ctl,control02.ctl和control03.ctl内容是完全一样的,最好将其分散到不同的驱动器上以提高控制文件的安全性,这叫做多路镜像multiplexing

**4、创建spfile并启动实例**
```js
$ sqlplus / as sysdba;
SQL> create spfile from pfile;
```
这会在$ORACLE_HOME/dbs/目录下生成spfile参数文件spfilecatlogdb.ora,这是服务器端的参数文件,关于参数文件详见"[oracle初始化参数文件pfile和spfile](https://openwares.net/database/pfile_and_spfile.html)"

启动实例
```js
SQL> startup nomount
```
**5、创建数据库**

建库脚本createdb.sql如下：
\[sql\]
CREATE DATABASE catlogdb
 USER SYS IDENTIFIED BY oracle
 USER SYSTEM IDENTIFIED BY oracle
 LOGFILE GROUP 1 ('/u01/oradata/catlogdb/redo01.log') SIZE 100M,
 GROUP 2 ('/u01/oradata/catlogdb/redo02.log') SIZE 100M,
 GROUP 3 ('/u01/oradata/catlogdb/redo03.log') SIZE 100M
 MAXLOGFILES 5
 MAXLOGMEMBERS 5
 MAXLOGHISTORY 1
 MAXDATAFILES 100
 MAXINSTANCES 1
 CHARACTER SET AL32UTF8
 NATIONAL CHARACTER SET UTF8
 EXTENT MANAGEMENT LOCAL
 DATAFILE '/u01/oradata/catlogdb/system01.dbf' SIZE 325M REUSE
 SYSAUX DATAFILE '/u01/oradata/catlogdb/sysaux01.dbf' SIZE 325M REUSE
 DEFAULT TABLESPACE users
 DATAFILE '/u01/oradata/catlogdb/users01.dbf'
 SIZE 500M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED
 DEFAULT TEMPORARY TABLESPACE tempts1
 TEMPFILE '/u01/oradata/catlogdb/temp01.dbf' 
 SIZE 20M REUSE
 UNDO TABLESPACE undotbs1
 DATAFILE '/u01/oradata/catlogdb/undo01.dbf'
 SIZE 200M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
\[/sql\]

执行建库脚本
```js
SQL> @createdb.sql;
Database created.
Tablespace created.
Database altered.
```
**6、运行系统脚本建立数据字典视图**
```js
SQL> @?/rdbms/admin/catalog.sql;
SQL> @?/rdbms/admin/catproc.sql;
```
**7、编辑对外监听配置文件**

监听文件$ORACLE_HOME/network/admin/listener.ora内容：
```js
SID_LIST_LISTENER =
 (SID_LIST =
 (SID_DESC =
 (GLOBAL_DBNAME = catlogdb)
 (ORACLE_HOME = /u01/app/oracle/product/10.2.0/db_1)
 (SID_NAME = catlogdb)
 )
 )
 
 LISTENER =
 (DESCRIPTION_LIST =
 (DESCRIPTION =
 (ADDRESS = (PROTOCOL = TCP)(HOST = hostname.domain)(PORT = 1521))
 )
 )
```
其中hostname为主机名,domain为主机域名,也可以用ip地址来代替hostname.domain字段。

**建库完毕。**