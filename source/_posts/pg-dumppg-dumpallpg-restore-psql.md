---
title: 'pg_dump,pg_dumpall,pg_restore与psql'
tags:
  - PostgresQL
id: '7502'
categories:
  - - Database
date: 2016-08-07 10:28:18
---


<!-- more -->
pg_dump可以转储数据库为一个sql脚本文件或其他归档格式文件，比如pg_restore使用的归档格式。

pg_dump默认输出普通的sql脚本，指定-F --format=format来指定pg_restore支持的格式，比如-Fc或-Ft

pg_dumpall内部使用pg_dump来转储数据库，只输出文本格式的sql脚本文件。

在转储的同时可以进行bzip2压缩，比如:
```js
$ pg_dumpall -U user -h localhost -c --if-exists --role=postgres bzip2 > db.sql.bz2
```
-c选项指定在重建数据库对象之前插入清理语句(drop)。

sql脚本文件只能使用psql来执行，如果使用pg_restore，则会有如下错误提示：
```js
pg_restore: \[archiver\] input file appears to be a text format dump. Please use psql
```

其他格式则需要使用pg_restore来恢复。

恢复pg_dumpall转储的sql脚本时，使用超级用户postgres来恢复：
```js
$ sudo -u postgres psql -f reis_2016_08_07.sql > import.log
psql:reis_2016_08_07.sql:24: ERROR: current user cannot be dropped
psql:reis_2016_08_07.sql:33: ERROR: role "postgres" already exists
```
有错误提示不能drop掉postgres用户和postgres用户已经存在，在sql脚本中有这样两行：
```js
DROP ROLE IF EXISTS postgres;
CREATE ROLE postgres;
```

因为当前用户正是postgres,所以会有这样的错误，忽略掉即可。

References:
\[1\][Postgresql 转存恢复数据经验](http://www.postgres.cn/news/viewone/1/244)