---
title: postgresql扩展oracle_fdw
tags:
  - PostgresQL
id: '7661'
categories:
  - - Database
date: 2016-11-09 20:00:40
---


<!-- more -->
postgresql通过fdw(Foreign Data Wrapper)插件来支持各种各种的外部数据，外部文件和关系数据库都可以，通过插件oracle_fdw可以从postgresq来访问oracle数据库。

**安装**

安装postgresql开发库
```js
# apt install postgresql-server-dev-all
```

[安装oracle instant client](https://openwares.net/linux/debian_amd64_install_oracle_10g_instant_client.html)，并配置好oracle环境变量，特别是ORACLE_HOME
特别注意要建几个符号链接：
```js
$ cd /opt/oracle/instantclient_12_1
$ sudo ln -sf libclntsh.so.12.1 libclntsh.so
$ sudo ln -sf libclntshcore.so.12.1 libclntshcore.so
$ sudo ln -sf libocci.so.12.1 libocci.so
```

下载oracle_fdw源代码，解压，编译，安装：
```js
$ wget https://github.com/laurenz/oracle_fdw/archive/ORACLE_FDW_1_5_0.tar.gz
$ tar zxvf ORACLE_FDW_1_5_0.tar.gz
$ cd ORACLE_FDW_1_5_0
$ make
$ sudo make install
/bin/mkdir -p '/usr/lib/postgresql/9.4/lib'
/bin/mkdir -p '/usr/share/postgresql/9.4/extension'
/bin/mkdir -p '/usr/share/postgresql/9.4/extension'
/bin/mkdir -p '/usr/share/doc/postgresql-doc-9.4/extension'
/usr/bin/install -c -m 755 oracle_fdw.so '/usr/lib/postgresql/9.4/lib/oracle_fdw.so'
/usr/bin/install -c -m 644 oracle_fdw.control '/usr/share/postgresql/9.4/extension/'
/usr/bin/install -c -m 644 oracle_fdw--1.1.sql oracle_fdw--1.0--1.1.sql '/usr/share/postgresql/9.4/extension/'
/usr/bin/install -c -m 644 README.oracle_fdw '/usr/share/doc/postgresql-doc-9.4/extension/'
```

查看插件是否安装成功：
```js
sql=> select * from pg_available_extensions ;
...
oracle_fdw 1.1 (null) foreign data wrapper for Oracle access
...
```

可以看到已经安装了插件oracle_fdw

**创建扩展**

确保运行postgresql的用户(一般为postgres)可以使用sqlplus正确链接到oracle数据库(其实只要当前系统用户正确连接到oracle即可)

```js
$ sqlplus orauser/password@oradb
```

创建oracle_fdw
```js
$ sudo -u postgres psql
postgres=# create extension oracle_fdw ;
ERROR: could not load library "/usr/lib/postgresql/9.4/lib/oracle_fdw.so": libclntsh.so.12.1: cannot open shared object file: No such file or directory
```

检查$LD_LIBRARY_PATH设置无误，但仍然找不到libclntsh.so.12.1，只好修改ld配置文件
添加/etc/ld.so.conf.d/oracle.conf
```js
# oracle instant client
/opt/oracle/instantclient_12_1/
```

然后刷新ld缓存,
```js
$ sudo ldconfig
```
重新创建oracle_fdw扩展成功。
为什么ldconfig可以而$LD_LIBRARY_PATH不行呢？因为
```js
If you manually start the server, it will inherit the environment setting from your shell.
But if PostgreSQL is started from a startup script, e.g. when the machine is booted,
you will not have the environment setting, and things will suddenly stop working.

That's why I recommended to set the variables in the PostgreSQL startup script.
As I said before, using ldconfig is much better
```
更详细参见参考\[2\]

**创建外部服务器、用户映射和外部表**

创建外部oracle服务器
首先确保运行postgresql服务的用户(一般为postgres)可以通过sqlplus正确连接到配置的oracle数据库实例，比如此处的orcl

注意：要确保tnsname.ora文件位于默认的$ORACLE_HOME/network/admin目录下，指定$TNS_ADMIN环境变量是没用的。

```js
postgres=# CREATE SERVER oradb FOREIGN DATA WRAPPER oracle_fdw OPTIONS (dbserver 'oradb');
```

查看创建的外部服务器：
```js
postgres=# select * from pg_foreign_server ;
```

还需要创建一个postgresql用户到oracle用户的映射表
```js
postgres=# CREATE USER MAPPING FOR pguser SERVER oradb OPTIONS (user 'orauser', password 'orapwd');
```

删除用户映射:
```js
postgres=# DROP USER MAPPING FOR postgres SERVER oradb;
```

如果不想在postgresql数据库中保存oracle的密码，可以将user后面的内容置空，从而使用外部密码方式。

创建外部表
```js
postgres=# CREATE FOREIGN TABLE tb_ora_test (
 id integer OPTIONS (key 'true') NOT NULL,
 text character varying(30),
 floating double precision NOT NULL
 ) SERVER oradb OPTIONS (schema 'ORASCHEMA', table 'ORATAB');
```
外部表的字段来自于指定的oracle表，字段数量可以少于oracle表的字段数量，也可以多于oracle表的字段数量，但多出来的字段只会返回空值。
然后就可以通过查询外部表来访问到oracle数据库表的内容，除了select,也可以insert,update,delete原始oracle表的内容。

授权其他用户使用外部oracle服务器
```js
postgres=# GRANT USAGE ON FOREIGN SERVER oradb TO pguser;
```


References:
\[1\][PostgreSQL Foreign Data Wrapper for Oracle](http://laurenz.github.io/oracle_fdw/)
\[2\][Why LD_LIBRARY_PATH is bad](http://xahlee.info/UnixResource_dir/_/ldpath.html)

**\===
\[erq\]**