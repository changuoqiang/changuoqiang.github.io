---
title: PostgreSQL dblink
tags:
  - PostgresQL
id: '7693'
categories:
  - - Database
date: 2016-11-11 08:16:00
---


<!-- more -->
dblink是postgresql内置的一个扩展模块，支持从当前postgresql数据库连接到其他postgresql数据库来存取数据。
除dblink外，还可以使用postgres_fdw来访问外部postgresql,二者功能基本一致，但postgres_fdw更优。

dblink有一系列的函数，支持连接外部postgresql,执行select,insert,update,delete等语句，以及在外部数据库中执行命令。

**创建**

```js
=> CREATE EXTENSION dblink;
```
会创建dblink相关的函数

**使用**

dblink的语法：
\[sql\]
dblink(text connname, text sql \[, bool fail_on_error\]) returns setof record
dblink(text connstr, text sql \[, bool fail_on_error\]) returns setof record
\[/sql\]
dblink函数可以使用已有的连接，或者直接提供连接字符串来访问外部服务器

下面的语句直接提供连接串来访问外部postgresql的表：
\[sql\]
=> select id, land_using_type from dblink('host=192.168.0.9 dbname=pgdbname user=pguser password=passwd', 
'select id, land_using_type from reg.tb_relevant_cert where cert_type=1') 
as t1 (id integer, land_using_type varchar(50));
\[/sql\]

使用dblink访问外部表数据，必须指定alias,下面是个综合的用法，用外部postgresql数据库的表更新本地表的数据：
\[sql\]
=> update reg.tb_relevant_cert c set land_using_type=t2.land_using_type
from 
(select id, land_using_type from dblink('host=192.168.0.9 dbname=pgdbname user=pguser password=passwd', 
'select id, land_using_type from reg.tb_relevant_cert where cert_type=1') 
as t1 (id integer, land_using_type varchar(50))
) as t2
where c.id=t2.id;
\[/sql\]

**创建视图**

每次写dblink比较麻烦，可以创建一个视图来简化此项工作:
\[sql\]
=> CREATE VIEW view_tbl_foo AS
select * from dblink('host=192.168.0.9 dbname=pgdbname user=pguser password=passwd', 
'select id, land_using_type from reg.tb_relevant_cert where cert_type=1') 
as t1 (id integer, land_using_type varchar(50));
\[/sql\]

然后访问就比较简单了：
\[sql\]
=> SELECT * FROM view_tbl_foo;
\[/sql\]

References:
\[1\][F.10. dblink](https://www.postgresql.org/docs/9.6/static/dblink.html)

**\===
\[erq\]**