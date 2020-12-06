---
title: PostgreSQL初步
tags:
  - Debian
  - PostgresQL
id: '2497'
categories:
  - - Database
date: 2012-10-04 12:47:17
---

mysql已纳入oracle囊中,PostgreSQL才是开源数据库的未来,而且PostgresQL比mysql更优秀。
<!-- more -->
**安装**

#apt-get install postgresql postgresql-client

**登录**

psql是PostgreSQL的交互式管理控制台,就像MySQL的mysql,Oracle的sqlplus

PostgreSQL默认安装的管理员账户名字为postgres,其有对应的linux系统账户postgres,但是这个系统账户是锁定的,无法使用密码登录该账户,这是为了系统安全。不要试图修改密码启用postgres系统账户。

可以这样登录PostgreSQL
$sudo su - postgres
$psql

或者
$sudo -u postgres psql

这样会进入psql控制台
psql (9.1.5)
Type "help" for help.

postgres=#

输入\\q可以退出psql控制台

这种登录方式使用的是peer认证,PostgreSQL会获取当前linux用户,然后匹配认证配置文件/etc/postgresql/\[version\]/\[cluster\]/pg_hba.conf文件,如果匹配成功则会让用户登录。
hba是host-based authentication的缩写。



这种登录方式与oracle的OS认证登录方式类似
$ sqlplus / as sysdba;

也可以使用密码认证方式登录PostgreSQL,首先要为PostgreSQL管理的管理员账户postgres设置密码,注意这里不是指linux系统用户postgres

有两种方法为postgres设置密码,一种是使用SQL,另一种是使用psql命令

使用SQL:
postgres=# ALTER USER postgres WITH PASSWORD 'passwd';

使用psql命令：
postgres=# \\password postgres
Enter new password: 

设置好密码后可以这样登录
$ psql -U postgres -h localhost
Password for user postgres: 
这种方式使用的是MD5认证方式,而不是PEER认证方式,匹配了pg_hba.conf中的不同的行。

**管理**

psql控制台下可以create database,create user,create table,alter ...等等日常管理工作。详细用法参见PostgresQL手册。

References:
\[1\][The pg_hba.conf File](http://www.postgresql.org/docs/9.3/static/auth-pg-hba-conf.html)

**\===
\[erq\]**