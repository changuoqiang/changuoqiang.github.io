---
title: cassandra copy导入数据时batch too large错误
tags:
  - cassandra
id: '7430'
categories:
  - - Database
date: 2016-07-15 15:21:12
---


<!-- more -->
执行COPY命令时,出现Batch too large错误:
```js
cqlsh:reis> COPY image FROM 'image.csv';
Using 7 child processes

Starting copy of reis.image with columns \['id', 'content', 'name'\].
Failed to import 11 rows: InvalidRequest - code=2200 \[Invalid query\] message="Batch too large", will retry later, attempt 1 of 5
Failed to import 16 rows: InvalidRequest - code=2200 \[Invalid query\] message="Batch too large", will retry later, attempt 1 of 5
Failed to import 18 rows: InvalidRequest - code=2200 \[Invalid query\] message="Batch too large", will retry later, attempt 1 of 5
...
```

/var/log/cassandra/system.log文件中可见:
```js
 ERROR \[SharedPool-Worker-1\] 2016-07-15 15:07:20,725 BatchStatement.java:267 - Batch of prepared statements for \[reis.image\] is of size 2732525, exceeding specified threshold of 614400 by 2118125. (see batch_size_fail_threshold_in_kb)
```

batch就是批量执行DML语句. 因为我的image表中有大字段,用于存储图片,每个图片不超过500K,所以遭遇了batch too large错误.

/etc/cassandra/cassandra.yaml文件中,参数batch_size_fail_threshold_in_kb的默认值只有50,一条DML语句就超过了这个阈值.
所以将此参数设置为600
```js
batch_size_fail_threshold_in_kb: 600
```
然后将COPY命令的批操作限制为1:
```js
cqlsh:reis> COPY image FROM 'image.csv' WITH MAXBATCHSIZE = 1 and MINBATCHSIZE = 1;
Using 7 child processes

Starting copy of reis.image with columns \['id', 'content', 'name'\].
Processed: 826 rows; Rate: 30 rows/s; Avg. rate: 60 rows/s
826 rows imported from 1 files in 13.682 seconds (0 skipped).
```

顺利的导入了所有数据.

**\===
\[erq\]**