---
title: PostgreSQL密码文件
tags:
  - PostgresQL
id: '3972'
categories:
  - - Database
date: 2013-11-07 20:01:27
---

可以在用户主目录下建立一个密码文件~/.pgpass,用于存储角色的登录密码一遍自动登录数据库集群。
<!-- more -->
用脚本自动访问数据库时，无论通过管道，还是expect都无法自动登录到PostgreSQL数据库，所以只有使用密码文件~/.pgpass这一条路。

其文件格式为

hostname:port:database:username:password

除了password域，其他域都可以为指定*，PostgreSQL会使用搜索到的最匹配的第一条记录。

standby服务器上，database域指定为replication匹配到主服务器的流复制连接。database域大部分情形下无用，因为所有的角色默认都有connect到集群所有服务器上的权限。

这个文件的权限必须为0600,否则PostgreSQL拒绝使用这个文件。