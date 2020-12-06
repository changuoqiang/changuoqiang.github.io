---
title: psql变量
tags:
  - PostgresQL
id: '7392'
categories:
  - - Database
date: 2016-06-15 22:34:17
---


<!-- more -->
psql 提供变量替换特性，类似于shell的变量。

psql的变量就是简单的名字/值对，名字只能有字母、数字和下划线组成。

使用\\set命令来设置变量:
```js
=> \\set foo bar
```

这样设置了变量foo,其值为bar。这样来显示变量的值:

```js
=> \\echo :foo
bar
```

使用\\set只指定变量名，不指定值时，会设置该变量，只不过其值为空。

使用\\unset命令来销毁变量：
```js
=> \\unset foo
```

使用\\set命令，不提供任何参数，显示全部的变量。
下面展示的是系统预置的变量:
```js
=> \\set
AUTOCOMMIT = 'on'
PROMPT1 = '%/%R%# '
PROMPT2 = '%/%R%# '
PROMPT3 = '>> '
VERBOSITY = 'default'
VERSION = 'PostgreSQL 9.4.8 on x86_64-unknown-linux-gnu, compiled by gcc (Debian 4.9.2-10) 4.9.2, 64-bit'
DBNAME = 'reis'
USER = 'reis'
HOST = 'localhost'
PORT = '5432'
ENCODING = 'UTF8'
```

**查看PostgreSQL版本**

因此获取postgresql版本就有了另外一种方法：
```js
=> \\echo :VERSION
PostgreSQL 9.4.8 on x86_64-unknown-linux-gnu, compiled by gcc (Debian 4.9.2-10) 4.9.2, 64-bit
```

另一种方法是:
```js
=> SELECT VERSION();
 version 
-----------------------------------------------------------------------------------------------
 PostgreSQL 9.4.8 on x86_64-unknown-linux-gnu, compiled by gcc (Debian 4.9.2-10) 4.9.2, 64-bit
(1 row)
```

二者结果是一样的。

**\===
\[erq\]**