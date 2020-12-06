---
title: PostgreSQL表空间、数据库、角色(用户)、模式、表之间的关系以及数据库组织管理模式
tags: []
id: '3902'
categories:
  - - Database
date: 2013-11-06 14:58:18
---

表空间、数据库、角色、模式及表之间的关系
<!-- more -->
表空间用于定义数据库对象在物理存储设备上的位置，不特定于某个单独的数据库。

数据库是数据库对象的物理集合，而schema则是数据库内部用于组织管理数据库对象的逻辑集合，
schema名字空间之下则是各种应用程序会接触到的对象，比如表，索引，数据类型，函数，操作符等。

角色(用户)则是数据库服务器(集群)全局范围内的权限控制系统，用于各种集群范围内所有的对象权限管理。
因此角色不特定于某个单独的数据库，但角色如果需要登录数据库管理系统则必须连接到一个数据库上。

角色可以拥有各种数据库对象。

##### 数据库管理模式

对于一个应用程序分很多相对独立的模块，每个模块有相对独立的数据结构，可以采用每个模块一个数据库用户及与其名字相同的schema来组织数据库，并且整个的物理数据库放在一个单独的表空间中。

使用这种数据库管理模式，可以撤销掉对public schema的访问许可，甚至把public schema直接移除，这样每个用户就真正的限定在了他们自己的schema里。

大致的数据库创建流程如下：

**创建数据库拥有者角色**

用超级用户postgres登录postgres数据库，然后创建角色foo
\[sql\]
$ psql -U postgres -h localhost
postgres=# CREATE ROLE foo CREATEDB CREATEROLE LOGIN PASSWORD 'password';
\[/sql\]

**创建表空间并将其所有权赋予新创建的用户**

创建表空间ts_foo并将其所有权赋予角色foo
\[sql\]
postgres=# CREATE TABLESPACE ts_foo OWNER foo LOCATION '/mnt/raid3805';
\[/sql\]

**创建数据库**

使用新创建的用户foo登录postgres数据库，然后在ts_foo表空间上创建同名数据库foo
\[sql\]
$ psql -U foo -h localhost -d postgres
postgres=> CREATE DATABASE foo TABLESPACE ts_foo;
\[/sql\]

**创建其他用户**

用新创建的角色foo登录foo数据库，然后创建其他用户bar，并为bar赋予数据库foo上的CREATE权限
\[sql\]
$ psql -U foo -h localhost
foo=> CREATE ROLE bar LOGIN PASSWORD 'password';
foo=> GRANT CREATE ON DATABASE foo TO bar;
\[/sql\]

**创建用户的schema**

使用角色bar登录数据库foo，然后创建角色bar拥有的schema bar
\[sql\]
$ psql -U bar -h localhost -d foo
foo=> CREATE SCHEMA bar;
\[/sql\]

**bar用户创建其同名schema下的表对象**

\[sql\]
foo=> CREATE TABLE foobar (id INTEGER);
\[/sql\]

**注意：**

shell命令psql连接到哪个数据库呢？情况是这样的：

如果只使用psql不提供任何参数，则psql试图连接到与当前发出命令的操作系统用户名同名的数据库，如果提供命令行参数-U指定要使用的登录角色名，那么psql试图去连接与登录名同名的数据库，如果提供了-d 命令行参数明确的指定要连接的数据库，则psql试图连接到这个指定的数据库。