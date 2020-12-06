---
title: oracle expdp and impdp
tags:
  - Oracle
id: '7473'
categories:
  - - Database
date: 2016-08-05 22:18:39
---


<!-- more -->
expdp是10g及以后新增的数据导出工具，数据导出速度有了很大的提升。而且expdp比exp有了更细粒度的导出支持，比如可以排除指定的表。

expdp真正的数据导出是在服务器端执行的，因此需要先建立directory数据库对象。

**创建directory对象**

```js
sql> CREATE DIRECTORY dir_expdp as '\\\\192.168.0.82\\exp';
```

directory对象可以使用网络路径，这样可以从数据库服务器expdp到网络上的远程机器。

查询目录对象:
```js
sql> SELECT * FROM dba_directories;
```

当前并没有alter directory对象的支持，如果修改只能先drop，然后再create。

**导出数据**

expdp使用schemas来指定需要导出的schema，类似于exp的owner参数，可以理解为用户名，其实二者并不同，只是一般二者同名而已。
directory指定使用哪个目录对象，就是上一步创建的目录对象。
dumpfile指定导出的数据文件
logfile指定导出日志文件
exclude指定需要排除的数据库对象，包括table等很多种对象

比如：
```js
$ expdp system/passwd@orcl schemas=user1,user2 EXCLUDE=TABLE:"IN('table1','table2')"
directory=dir_expdp dumpfile=${dmp_file} logfile=${explog_file}
```

**expdp优化**
expdp的优化主要在于提高并行度，也就是指定parallel参数，一般此参数等于cpu个数，并且要小于dump文件的个数,可以在dumpfile中指定％U让expdp自动按需要按顺序生成dump文件

查看cpu数量：
```js
sql> show parameter cpu
```

列如：
```js
$ expdp system/passwd@orcl schemas=user1,user2 EXCLUDE=TABLE:"IN('table1','table2')"
directory=dir_expdp dumpfile=db_%U.dmp logfile=explog_file parallel=16
```

还可以使用filesize来限制每个dump文件的最大尺寸。

**impdp导入**
```js
$ impdp system/passwd@orcl schemas=user1,user2 directory=dir_impdp dumpfile=db_%U.dmp logfile=explog_file parallel=16
```

impdp导入时也可以使用%U来指定输入的dump文件,也可以使用parallel参数来提速.

如果出现错误:
```js
ora-31684 object type user already exists
```
是因为在导入之前已经创建了user的原因,可以忽略掉此错误,或者impdp添加参数exclude=user

**使用参数文件**

可以将所有的expdp,impdp参数写入一个参数文件,然后在命令行上引用此文件,比如编辑一个expdp.par参数文件:
expdp.par
```js
schemas=user1,user2,user3
exclude=TABLE:"IN('table1','table2','table3','table4','table5')"
directory=dir_expdp
dumpfile=db_%U.dmp
logfile=db.log
parallel=4
version=10.2.0.3.0 
```

然后这样使用参数文件:
```js
$ expdp parfile=expdp.par
```

**排除对象**

使用exclude参数排除对象,其语法为:
```js
EXCLUDE=object_type\[:name_clause\] \[, ...\]
```

Object_type用于指定要排除的对象类型,name_clause用于指定要排除的具体对象.
```js
EXCLUDE=SCHEMA:"='HR'" #排除名字为HR的schema
EXCLUDE=USER #排除所有创建user的DDL语句
EXCLUDE=USER:"='HR'" #排除创建用户HR的DDL语句
EXCLUDE=VIEW,PACKAGE,FUNCTION #排除视图,包和函数
EXCLUDE=INDEX #排除索引
EXCLUDE=GRANT #排除授权
EXCLUDE=TRIGGER #排除触发器
EXCLUDE=TABLE:"IN ('COUNTRIES', 'REGIONS')" #排除某些表
EXCLUDE=SCHEMA:"LIKE 'SYS%'" #排除以SYS开头的schema
```

exclude参数可以多次出现,也可以将所有的排除写到一个exclude参数中.

include语法与EXCLUDE相同,但二者不能同时使用.

References:
\[1\][Data Pump Export](https://docs.oracle.com/cd/B19306_01/server.102/b14215/dp_export.htm)
\[2\][优化IMPDP/EXPDP导入导出速度](http://blog.csdn.net/tonyzhou_cn/article/details/10176783)
\[3\][expdp impdp 数据库导入导出命令详解](http://shitou118.blog.51cto.com/715507/310033)
\[4\][ORA-31684 import error Tips](http://www.dba-oracle.com/t_ora_31684_import_impdp.htm)

 **===
\[erq\]**