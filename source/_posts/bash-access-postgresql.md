---
title: bash shell脚本访问PostgreSQL的三种方式
tags:
  - PostgresQL
id: '3977'
categories:
  - - Database
date: 2013-11-07 21:04:04
---

bash脚本里有三种方式访问PostgreSQL数据库
<!-- more -->
但前提是要设置密码文件。当然对于有系统对应账户的数据库角色可以绕过密码登录环节，如
```js
$ sudo -u postgres psql
```
或
```js
$ sudo su - postgres
$ psql
```

但是对于没有系统账户对应的数据库角色，如要使用脚本登录则必须使用[PostgreSQL密码文件](https://openwares.net/database/postgresql_passwd_file.html)

*   heredoc方式
[heredoc](http://en.wikipedia.org/wiki/Here_document)是一种很常用的方式，在bash环境下还可以使用变量替换，用法示例
```js
psql -U ${role} -h ${host} -d mydb << EOF
 CREATE SCHEMA ${role};
EOF
```
也可以在循环语句中，向数据库批量插入数据，类似
```js
for ...
do
psql -U ${role} -h ${host} -d mydb << EOF
 INSERT INTO ${table} VALUES(${value1},${value2},...);
EOF
done 
```
但这种方式，每次插入一条语句都重新登录一次数据库，效率肯定不咋地。
**UPDATE(05/05/2014):既然可以使用变量替换,可以将所有插入语句组合到一个变量中，然后就可以在一次登录中批量插入数据了。**

还可以用以下方式来获取查询结果

```js
result=\`psql -U role -h localhost -d mydb << EOF
 SELECT * FROM products;
EOF\`

echo ${result}
```

*   使用psql命令行选项-f执行sql脚本文件
```js
psql -U ${role} -h ${host} -d mydb -f ${scriptname} 
```
*   使用psql命令行选项-c执行SQL语句或psql命令

psql的-c选项可以指定SQL语句或者psql命令，但二者不能混合，除非使用管道。如果命令参数中有多条SQL语句，则它们在一个事务里执行，除非使用BEGIN/COMMIT明确的指定事务。这与交互式使用psql终端不同，如果不明确指定事务，则每条SQL属于一个单独的事务并自动提交。只有最后一条SQL语句的结果被返回。
详见psql(1)。

可以看出，虽然有三种方式，但其实都是利用了PostgreSQL提供的外部命令psql,所以更复杂的数据库操作可以考虑使用Python

P.S.
事实证明用bash脚本插入大量数据，其效率相当低下，3510行的两个简单字段的数据竟然用了4分多种。

**\===
\[erq\]**