---
title: PostgreSQL表空间
tags:
  - PostgresQL
id: '3802'
categories:
  - - Database
date: 2013-11-05 11:22:42
---

PostgeSQL表空间允许数据库管理员定义存储数据库对象的文件在文件系统中的位置。一旦创建了表空间，当创建数据库对象时就可以引用这个表空间。
<!-- more -->
通过使用表空间，管理员可以控制PostgreSQL数据库的磁盘布局。这有两个好处：

*   如果PostgreSQL集群初始安装所在的分区或卷耗尽了空间，并且已经无法扩展，可以在另外的分区上面创建和使用一个新的表空间，直到系统重新被配置。
*   表空间可以允许管理员根据已知的数据库对象使用模式优化系统性能。比如，一个频繁使用的index可以放在一个快速的，高可用的磁盘上，比如昂贵的固态硬盘。同时，存储很少使用或者对性能要求不高的归档数据的table，可以放在廉价低速的磁盘系统上。

**创建表空间语法**
\[sql\]
CREATE TABLESPACE tablespace_name \[ OWNER user_name \] LOCATION 'directory';
\[/sql\]

参数

*   _tablespace_name_ 表空间的名字，不能以pg_开头，这是为系统表空间保留的。

*   _user_name_ 表空间所有者的名字，如果省略，缺省为执行命令的用户。只有数据库超级用户才可以创建表空间，但可以将其所有权赋予非超级用户。

*   _directory_ 表空间使用的路径，目录必须是空的，并且owner为PostgreSQL操作系统用户。Debian默认安装PostgreSQL的系统用户为postgres。目录必须是一个绝对路径。

注意

*   只有支持符号链接的系统才能创建表空间

*   CREATE TABLESPACE不能在一个事务块中执行

示例
\[sql\]
postgres=# CREATE TABLESPACE ts_mydbspace LOCATION '/mnt/raid';
\[/sql\]

**使用表空间**

只有数据库超级用户才可以创建表空间，但是创建之后，普通的数据库用户就可以使用它了，只要用户有相应的CREATE权限。比如：
\[sql\]
auser=> CREATE TABLE foo(i int) TABLESPACE ts_mydbspace; 
\[/sql\]

或者使用缺省表空间参数

\[sql\]
SET default_tablespace = ts_mydbspace;
CREATE TABLE foo(i int);
\[/sql\]

数据库创建时指定的表空间为其默认表空间，如果没有指定，则其默认表空间与生成该数据库的模板数据库的默认表空间是同一个。数据库关联的默认表空间用于存储该数据库的系统目录信息,它是在这个数据库内创建的表，索引，临时文件等的默认表空间，如果创建这些对象时没有用TABLESPACE语句或通过default_tablespace、temp_tablespaces指定表空间。

**查看表空间**

当PostgeSQL数据集群初始化时，自动创建两个表空间。pg_global用于存储共享的系统目录信息。pg_default是模板数据库template0和template1默认的数据库，从而也是其他数据库默认的表空间，除非CREATE DATABASE时显式指定默认表空间。

查看存在的表空间

\[sql\]
postgres=# SELECT spcname FROM pg_tablespace;

 spcname 
------------
 pg_default
 pg_global
(2 rows)
\[/sql\] 


或者使用psql命令\\db

\[sql\]
postgres=# \\db

 List of tablespaces
 Name Owner Location 
------------+----------+----------
 pg_default postgres 
 pg_global postgres 
(2 rows)
\[/sql\]

[21.6. Tablespaces](http://www.postgresql.org/docs/9.3/static/manage-ag-tablespaces.html)