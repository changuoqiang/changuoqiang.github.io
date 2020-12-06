---
title: PostgreSQL导出数据到CSV文件
tags:
  - PostgresQL
id: '7349'
categories:
  - - Database
date: 2016-06-14 08:40:20
---


<!-- more -->
postgresql支持在表和文件之间拷贝数据，可以使用PostgreSQL扩展的SQL函数COPY或者psql内部命令\\copy来做这件事。

导出数据的格式：
```js
COPY table_name (query) TO 'filename' PROGRAM 'command' STDOUT \[ WITH OPTIONS \];
```

导入数据的格式：
```js
COPY table_name (query) FROM 'filename' PROGRAM 'command' STDIN \[ WITH OPTIONS \];
```

更详细的格式描述见\[1\]

**COPY函数**

COPY函数在服务器上执行，如果输出到文件，要注意postgresql服务器进程有没有对指定目录的执行权限，比如:

```js
=# COPY (SELECT * FROM base.tb_dictionary WHERE ...) TO '/tmp/designusage.csv' WITH CSV DELIMITER ',';
```

将查询结果输出到临时目录下的指定文件。debian系统postgresql系统进程用户postgres的主目录是/var/lib/postgresql,也可以将文件输出到此目录。
如无写权限，会提示:

```js
ERROR: could not open file "..." for writing: Permission denied
```

**\\copy命令**

psql命令\\copy在客户端执行，如果输出到文件是输出到客户端的文件系统，要注意当前执行psql的用户权限。比如：

```js
=# \\copy (SELECT * FROM base.tb_dictionary WHERE ...) TO '/tmp/designusage.csv' WITH CSV DELIMITER ','
```

如果要输出列名，可以指定HEADER选项，HEADER只用于CSV格式。
可以写到临时目录，也可以写到当前用户的主目录。

其实\\copy命令实际上是使用了COPY FROM STDIN或者COPY TO STDOUT，然会通过STDIN或STDOUT与文件交互。

所以可以这样:

```js
$ psql -c "COPY (SELECT * FROM base.tb_dictionary WHERE ...) TO STDOUT WITH CSV DELIMITER ',' " -U role -h host dbname > export.csv
```

使用COPY函数输出到STDOUT，然后重定向到文件。

References:
\[1\][copy data between a file and a table](https://www.postgresql.org/docs/current/static/sql-copy.html)
\[2\][Outputting to CSV in Postgresql](http://blogs.harvard.edu/dlarochelle/2011/12/11/outputing-to-csv-in-postgresql/)

**\===
\[erq\]**