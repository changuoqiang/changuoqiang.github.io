---
title: Oracle 10g 超过最大进程数
tags:
  - Oracle
id: '1419'
categories:
  - - Database
date: 2011-05-07 09:30:11
---

Oracle 10g 超过最大进程数错误ORA-00020的解决办法
<!-- more -->
今天升级业务系统,升级完毕后遇到,打开应用出现错误提示

> Microsoft OLE DB Provider for Oracle 错误 '80004005 ORA-12518: TNS: 监听程序无法分发客户机连接

查看oracle\\product\\10.2.0\\admin\\orcl\\udump\\目录下的trc文件(trace file),发现有如下提示：

> ORA-00020: maximum number of processes 150 exceeded

原来是超过了默认的最大进程数150，这主要是因为应用程序写的有问题，彻底解决还要找出应用程序的问题。

临时的解决办法是适当增加oracle 10g的最大进程数

SQL>alter system set processes=300 scope=spfile;
SQL>shutdown immediate;
SQL>startup;

查看数据库设置的进程数
SQL> select value from v$parameter where name = 'processes';
或者
SQL>show parameter process;

查看已经存在的进程数
SQL> select count(*) from v$process;