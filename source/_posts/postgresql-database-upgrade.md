---
title: postgresql数据库存储结构升级
tags:
  - PostgresQL
id: '6125'
categories:
  - - GNU/Linux
date: 2015-01-08 16:16:04
---


<!-- more -->
如果使用brew升级postgresql到新版时，数据库存储结构升级了，那么原来的数据库就不能在新版本下运行了,/usr/local/var/postgres/server.log里会有错误提示。

有以下升级方式:

1、使用pg_dump备份旧版数据库，将原来的数据库目录整个干掉，重新初始化一个新库，最后使用pg_restore恢复数据。

```js
# rm -rf /usr/local/var/postgres
$ initdb -D /usr/local/var/postgres
```

2、使用pg_upgrade命令升级数据库

详细的升级方法见参考\[1\]和\[2\]。

References:
\[1\][升级 PostgreSQL 到 9.3 小记](http://david-chen-blog.logdown.com/posts/169428-postgresql-upgrade-to-93)
\[2\][postgresql upgrade](http://stackoverflow.com/questions/24379373/how-to-upgrade-postgres-from-9-3-to-9-4-without-losing-data)
===
\[erq\]