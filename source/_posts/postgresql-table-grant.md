---
title: PostgreSQL外键表引用授权
tags:
  - PostgresQL
id: '4500'
categories:
  - - Database
date: 2013-12-18 19:43:43
---


<!-- more -->
因为要引用schema base中的一张表tb_user,所以在sql文件中使用如下语句授权:
\[sql\]
\\c reis base
GRANT REFERENCES ON tb_user TO general;
\\c reis general
\[/sql\]

但仍然无法引用base.tb_user表,提示:

ERROR: permission denied for schema base

这里虽然对schema base下的对象tb_user有了参考的权限,但对schema本身却没有授予权限,所以出现这个错误提示。

所以先授权角色general有使用schema的权限就可以了。

\[sql\]
\\c reis base
GRANT USAGE ON SCHEMA base TO general;
GRANT REFERENCES ON tb_user TO general;
\\c reis general
\[/sql\]

对于schema对象,有两种权限可以授权其他角色。一个是CREATE,允许被授权的角色在当前schema内创建和修改对象。另一个权限是USAGE,允许被授权角色使用schema内的对象。

**参考:**
[GRANT的详细语法](http://www.postgresql.org/docs/9.3/static/sql-grant.html)