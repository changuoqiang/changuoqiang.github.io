---
title: linux系统卸载oracle 10g
tags:
  - Debian
  - Oracle
id: '2084'
categories:
  - - Database
date: 2012-04-10 11:14:53
---

debian squeezy amd64系统,卸载oracle 10.2.0.4 64bits版本
<!-- more -->
1、停止服务

以oracle用户登陆系统,停止监听和数据库

$lsnrctl stop

SQL>shutdown immediate

2、删除文件

#rm -rf $ORACLE_BASE
#rm /etc/oraInst.loc
#rm /etc/oratab
#rm /usr/local/bin/coraenv
#rm /usr/local/bin/dbhome
#rm /usr/local/bin/oraenv

3、删除用户和组

#userdel oracle
#groupdel oinstall
#groupdel dba