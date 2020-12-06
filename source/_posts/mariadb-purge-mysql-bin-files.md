---
title: mariadb清除mysql-bin文件
tags: []
id: '8509'
categories:
  - - Database
date: 2019-07-09 21:12:09
---


<!-- more -->
如果/etc/mysql/my.cnf中打开了log-bin选项，即使没有做主从复制，数据目录下仍然会持续的生成大量的mysql-bin.0000*文件，这玩意儿就像归档日志吧。

如果你做了主从复制，下面就不要看了。
没做主从复制的话，可以先清除掉这些文件
```js
mysql> reset master;
```
这样会删除掉所有的log-bin，重新生成一个mysql-bin.000001
然后修改/etc/mysql/my.cnf，注释掉下面的行
```js
#log-bin=mysql-bin
```
重新启动mariadb服务，以后就不会再生成这些文件了。