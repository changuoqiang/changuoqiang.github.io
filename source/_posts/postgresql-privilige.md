---
title: PostgreSQL权限
tags:
  - PostgresQL
id: '3900'
categories:
  - - Database
date: 2013-11-06 14:57:37
---

PostgreSQL权限系统
<!-- more -->
当一个对象被创建时，它被赋予一个所有者，这通常就是执行CREATE语句的角色。对于大多数对象，在初始状态，只有对象的所有者(和超级用户)才能对对象做任何事情。允许其他角色使用这个对象，必须赋予其适当的权限。

有许多不同种类的权限SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER, CREATE, CONNECT, TEMPORARY, EXECUTE, 和 USAGE.不同的对象类型有不同的权限种类。

修改或者移除对象始终是对象所有者的权限。

使用ALTER命名可以为对象赋予一个新的所有者。超级用户总是可以这样做，而普通角色只有是当前对象的所有者(或者所有者角色的成员)，并且是新所有者角色的成员，才可以这样做。

**赋予权限**

赋予权限使用GRANT语句,比如
\[sql\]
GRANT UPDATE ON tb_accounts TO joe;
\[/sql\]
使用ALL来赋予角色对象类型具有的所有权限，特殊的用户PUBLIC用来给系统所有的用户赋予权限。

PostgreSQL为PUBLIC赋予某些类型对象的默认权限。对于tables, columns, schemas和tablespaces，没有默认权限赋予PUBLIC角色。对于其他类型，PUBLIC被赋予如下的默认权限：

*   数据库的CONNECT和CREATE TEMP TABLE权限
*   函数的EXECUTE权限
*   语言的USAGE权限

对象的所有者可以剥夺默认的或显式赋予的权限。并且，初始默认权限可以使用ALTER DEFAULT PRIVILEGES来改变。

CONNECT权限只适用于数据库。

详细的授权语法见[GRANT](http://www.postgresql.org/docs/9.3/static/sql-grant.html)

**查询权限**

使用psql命令\\z或\\dp查询表，视图或者序列的访问权限

**撤销权限**

使用REVOKE语句
\[sql\]
REVOKE ALL ON tb_accounts FROM PUBLIC;
\[/sql\]

(对象所有者的)特殊权限，比如DROP,GRANT和REVOKE，是由对象所有者隐式拥有的，并且不能被赋予或剥夺。但是对象所有者可以选择撤销它自己在所拥有的对象上的普通权限。

通常，只有对象的所有者(或者超级用户)可以授予或者剥夺其他角色对其所拥有对象的权限。然而，可以通过WITH GRANT OPTION赋予接受权限的角色有能力为其他角色赋予当前对象的权限。如果GRANT OPTION随后被剥夺，那么所有直接或间接得到GRANT OPTION的角色都将失去其对当前的GRANT权限。

参考：

\[1\][5.6. Privileges](http://www.postgresql.org/docs/9.3/static/ddl-priv.html)
\[2\][GRANT](http://www.postgresql.org/docs/9.3/static/sql-grant.html)

**\===
\[erq\]**