---
title: PostgreSQL数据库
tags:
  - PostgresQL
id: '3826'
categories:
  - - Database
date: 2013-11-05 15:59:46
---

每一个运行的PostgeSQL服务实例管理一个或多个数据库。数据库是用于分级组织SQL对象的顶层对象。
<!-- more -->
**概览**

数据库是SQL对象(也叫数据库对象)的命名集合。一般来讲，一个数据库对象，比如表，函数等，属于且仅属于一个数据库。然而，也存在一些系统对象(system catalogs),比如pg_database属于整个集群,可以被集群的每个数据库访问。

更准确的说，一个数据库是包含表，函数等对象的模式(schema)的集合,因此完整的层级是这样的：

集群(server) -> 数据库(database) -> 模式(schema) -> 表，函数等对象(table,funcations,etc)

如果多个项目或者用户是相互关联的，并且会相互访问彼此的资源，它们应该放到同一个数据库的不同模式里。模式(schema)只是一个单纯的逻辑结构，谁能访问某个模式由权限系统来管理。

**创建数据库**

_语法_
\[sql\]
CREATE DATABASE name
 \[ \[ WITH \] \[ OWNER \[=\] user_name \]
 \[ TEMPLATE \[=\] template \]
 \[ ENCODING \[=\] encoding \]
 \[ LC_COLLATE \[=\] lc_collate \]
 \[ LC_CTYPE \[=\] lc_ctype \]
 \[ TABLESPACE \[=\] tablespace_name \]
 \[ CONNECTION LIMIT \[=\] connlimit \] \]
\[/sql\]

要创建数据库，必须要有超级用户权限或者有CREATEDB权限。默认情况下，新创建的数据库克隆系统数据库template1，可以通过TEMPLATE参数指定一个不同的数据库克隆源。特别地，指定TEMPLATE template0，可以创建一个未受到任何污染的纯净的数据库，仅仅包行当前版本PostgreSQL预定义的标准对象。

因为需要连接到数据库服务器才能执行CREATE DATABASE命令，那么任意一个节点的第一个数据库是如何建立的呢？第一个数据库总是由initdb命令在初始化数据存储区的时候创建的。这个数据库叫做postgres,因此**要创建第一个用户数据库的时候你应该连接到postgres数据库**。

第二个数据库template1， 也是在数据库集群初始化时被创建的。每创建一个新的数据库时，实际上就是克隆了 template1 数据库。这就意味着你对 template1 做的任何修改都会传播到所有随后创建的数据库。正因如此，应该避免在 template1 数据库中创建任何对象，除非你想将它们传播到后面创建的所有数据库中。

_参数_

*   name
将要创建的数据库的名字
*   user_name
将拥有新创建数据库的角色名字。默认情况下，新创建数据库的拥有者为执行命令的用户。为其他用户创建数据库，你必须是其他用户直接或间接的成员，或者是超级用户。
*   template
从哪个数据库克隆出新数据库，默认为template1
*   encoding
新数据库使用的字符集。默认使用模板数据库的字符集。最常用的为UTF8,可以使用的[字符集](http://www.postgresql.org/docs/9.3/static/multibyte.html#MULTIBYTE-CHARSET-SUPPORTED)。
*   lc_collate
本地排序规则，lc为locale之意
*   lc_ctype
语言符号及其分类
*   tablespace_name
新数据库关联的表空间的名字，默认使用模板数据库的表空间。此数据库中创建的对象默认使用此表空间，除非明确指定要使用的表空间。
*   connlimit
并发连接限制，默认为无限制。

还可以使用shell命令createdb来创建数据库，详见CREATEDB(1)。
\[sql\]
$ createdb dbname
\[/sql\]
createdb没有任何魔法，仅仅是连接到postgres数据库，发出CREATE DATABASE命令。如果不提供任何参数，CREATEDB将创建一个与当前系统用户名相同的数据库。

_注意_

*   不能在一个事务块中执行CREATE DATABASE语句。
*   如果出现像这样的错误'could not initialize database directory',可能是因为表空间的权限不足，磁盘满，或者其他文件系统错误。
*   创建数据库前如果源模板数据库已经有其他连接存在，CREATE DATABASE会失败，否则，到模板数据库的新连接会被锁定，直到CREATE DATABASE命令完成
*   选择的字符集编码必须与选择的locale设置lc_collate和lc_ctype兼容

**查看数据库**

使用SQL语句
\[sql\]
SELECT datname FROM pg_database;
\[/sql\]
或者使用psql命令
\[sql\]
=> \\l
\[/sql\]

**删除数据库**

\[sql\]
DROP DATABASE name;
\[/sql\]

只有数据库的所有者，或者超级用户可以删除数据库。删除数据库会删除数据库中包括的所有对象。数据库的删除是不可恢复的。
你不能使用 DROP DATABASE 删除与你连接的数据库。不过，你可以联接到其他数据库去执行，包括template1数据库，template1也是你删除集群中最后一个用户数据库的唯一方法。

也可以使用shell命令删除数据库
```js
$ dropdb dbname
```
[Chapter 21. Managing Databases](http://www.postgresql.org/docs/9.3/static/managing-databases.html)