---
title: PostgreSQL角色(用户)
tags:
  - PostgresQL
id: '3824'
categories:
  - - Database
date: 2013-11-05 15:56:14
---

PostgreSQL数据库系统中，用户是角色的别名。
<!-- more -->
PostgreSQL使用角色的概念来管理数据库访问权限。一个角色可以被认为是一个数据库用户，也可以认为是一组数据库用户，这取决于角色是如何被配置的。

角色可以拥有数据库对象，比如database,table,并且可以通过把在这些对象上拥有的权限赋予其他角色来控制谁可以访问这些对象。更进一步，可以将一个角色的成员关系(把当前角色当作组角色，把其他角色当作当前角色的成员)赋予另一个角色，可以使其成员角色使用组角色的访问权限。

角色包含用户和组的概念。PostgreSQL 8.1之前，用户和组是不同的实体，但现在它们都是角色。**任何角色可以充当一个用户，组，或者兼而有之。**

**数据库角色**

数据库角色和操作系统用户概念上是完全分开的。实践上，在二者之间使用统一的名字可能是便利的，但这不是必须的。**数据库角色是跨数据库集群全局通用的，不是针对每一个单独的数据库。**

_创建角色语法_

完整语法
\[sql\]
CREATE ROLE name \[ \[ WITH \] option \[ ... \] \]

where option can be:

 SUPERUSER NOSUPERUSER
 CREATEDB NOCREATEDB
 CREATEROLE NOCREATEROLE
 CREATEUSER NOCREATEUSER
 INHERIT NOINHERIT
 LOGIN NOLOGIN
 REPLICATION NOREPLICATION
 CONNECTION LIMIT connlimit
 \[ ENCRYPTED UNENCRYPTED \] PASSWORD 'password'
 VALID UNTIL 'timestamp'
 IN ROLE role_name \[, ...\]
 IN GROUP role_name \[, ...\]
 ROLE role_name \[, ...\]
 ADMIN role_name \[, ...\]
 USER role_name \[, ...\]
 SYSID uid
\[/sql\]

主要参数

*   name
角色名字
*   CREATEDB NOCREATEDB
是否允许创建数据库,缺省值是NOCREATEDB
*   INHERIT NOINHERIT
是否继承组角色，默认是继承。如果设置为NOINHERIT，则必须用SET ROLE指明要使用的组角色。
*   LOGIN NOLOGIN
是否允许角色登录
*   PASSWORD _password_
指定登录密码
*   IN ROLE _role_name_
新创建的角色作为成员加入已经存在的一个或多个角色
*   ROLE role_name
将已经存在的一个或多个角色作为新创建角色的成员

**修改或撤销角色**

使用ALTER ROLE修改角色属性，使用DROP ROLE撤销角色。

**使用shell命令创建或撤销角色**
PostgreSQL提供了SHELL命令createuser和dropuser来创建或撤销角色，它们是SQL语句的包装，支持SQL语句支持的所有属性，具体用法见 CREATEUSER(1)和 DROPUSER(1)

**查看存在的角色**

SQL语句
\[sql\]
SELECT rolname FROM pg_roles;
\[/sql\]

或者psql命令
\[sql\]
postgres=# \\du
\[/sql\]

[Chapter 20. Database Roles](http://www.postgresql.org/docs/9.3/static/user-manag.html)