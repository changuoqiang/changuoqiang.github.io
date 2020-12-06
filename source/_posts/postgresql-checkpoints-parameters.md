---
title: postgresql checkpoints相关参数
tags:
  - PostgresQL
id: '7632'
categories:
  - - Database
date: 2016-10-10 09:36:29
---


<!-- more -->
数据库日志中出现警告：
```js
2016-10-10 03:04:29 CST \[26586-131\] LOG: checkpoints are occurring too frequently (17 seconds apart)
2016-10-10 03:04:29 CST \[26586-132\] HINT: Consider increasing the configuration parameter "checkpoint_segments".
```

checkpoint_segments参数按默认设置3过小了，这里有几个相互关联的参数，有时间好好看看。

References:
\[1\][PgSQL · 特性分析 · 谈谈checkpoint的调度](http://mysql.taobao.org/monthly/2015/09/06/)
\[2\][PostgreSQL 中 checkpoint 和 WAL 日志量的关系以及优化](http://www.weixinkd.com/n/8244035)
\[3\][postgresql之checkpoint(检查点)](http://blog.csdn.net/sszgg2006/article/details/26826501)

**\===
\[erq\]**