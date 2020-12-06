---
title: cassandra导出和导入数据
tags:
  - cassandra
id: '6937'
categories:
  - - Database
date: 2015-11-24 20:47:47
---


<!-- more -->
cassandra像其他RDBMS一样提供了export/import工具：

*   cqlsh命令COPY TO/FROM
注意这不是cql命令。使用这组命令可以在cassandra与其他RDBMS或cassandra之间迁移数据。COPY TO/FROM支持CSV文件格式以及标准输出和输入。
COPY TO/FROM命令同样支持集合数据类型。
*   sstable2json/json2sstable
这组工具已经过时，在3.0版本中已被删除。所以不应该再使用这组工具。
*   sstableloader
Cassandra bulk loader,可以装载外部数据到cassandra,也可以恢复snapshot,装载sstable到不同配置的cassandra集群。
如果数据量很大，应该使用sstableloader，如果数据量比较小的话，使用COPY TO/FROM更省时省力。
*   Snapshots
snapshots是cassandra正牌的备份恢复工具，而不是用于与其他数据库系统进行数据迁移的工具。所以严格来说它不应该算作export/import工具。
*   ETL工具
很多第三方的ETL(Extract-Transform-Load)工具支持从其他数据库向cassandra数据库迁移数据。

**COPY TO/FROM**

这里只讲一下COPY TO/FROM命令。

命令格式:
```js
COPY table_name ( column, ...)
FROM ( 'file_name' STDIN )
WITH option = 'value' AND ...

COPY table_name ( column , ... )
TO ( 'file_name' STDOUT )
WITH option = 'value' AND ...
```

COPY FROM 用于从csv文件或标准输入import数据到表，而COPY TO用于将表数据export到csv文件或标准输出。

WITH option='value' 用于指定csv文件的格式,分隔符，引用，转移字符，文件编码，时间格式等等，详见官方文档。

如果不指定列名，会按表元数据中记载的列顺序输出所有的列。同样，如果csv也是按相同的顺序组织数据，COPY FROM时也可以忽略所有的列名。

COPY TO/FROM时，可以只指定部分列进行部分数据的导出和导入，而且可以以任意顺序指定列名。

如果表中已经存在数据，COPY FROM不会truncate已有的数据。

导出数据的示例：
```js
cqlsh> use test ;
cqlsh> COPY airplanes (name, mach, year, manufacturer) TO 'export.csv' ;
```

导入数据的示例:
```js
cqlsh> COPY airplanes (name, mach, year, manufacturer) FROM 'import.csv' ;
```

如果使用标准输入导入数据，要使用只包含 `\.` 字符的单独一行来结束数据输入。

如果导入数据时出现如下错误提示：
```js
Error starting import process:

field larger than field limit (131072)
%d format: a number is required, not NoneType
```
这是因为csv文件包含大容量字段，python的csv模块需要设置更大的字段尺寸限制。

修改/usr/bin/cqlsh.py文件,在导入csv模块之后，添加如下行:
```js
csv.field_size_limit(sys.maxsize)
```

**注意：含有counter列的表无法使用COPY TO/FROM来导出和导入数据。**

References:
\[1\][Ways to Move Data To/From DataStax Enterprise and Cassandra](http://www.datastax.com/dev/blog/ways-to-move-data-tofrom-datastax-enterprise-and-cassandra)
\[2\][Consider deprecating sstable2json/json2sstable in 2.2](https://issues.apache.org/jira/browse/CASSANDRA-9618)
\[3\][_csv.Error: field larger than field limit (131072)](http://stackoverflow.com/questions/15063936/csv-error-field-larger-than-field-limit-131072)
\[4\][cassandra数据迁移](http://alongwith.me/cassandra/cassandra%E6%95%B0%E6%8D%AE%E8%BF%81%E7%A7%BB)

**\===
\[erq\]**