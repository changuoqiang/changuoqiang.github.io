---
title: Yosemite升级导致的postgresql启动问题
tags:
  - PostgresQL
id: '5991'
categories:
  - - Database
date: 2014-10-28 12:35:26
---


<!-- more -->
升级yosemite后，启动postgesql时报以下错误:
```js
...
FATAL: could not open directory "pg_twophase": No such file or directory
Is the server running locally and accepting
connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
```

据说可能是因为yosemite删除了pg的一些空目录导致的,所以解决方案也十分简单:

如果/usr/local/var/postgres/目录下没有pg_tblspc,pg_twophase和pg_stat_tmp子目录,直接新建这几个目录即可。

然后可以正常启动postgresql

**\===
\[erq\]**