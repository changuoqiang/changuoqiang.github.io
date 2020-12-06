---
title: ora-04031 无法分配共享内存
tags:
  - Oracle
id: '1029'
categories:
  - - Database
date: 2011-02-23 15:32:42
---

错误"ora-04031 无法分配XXX字节的共享内存(XXX)"的解决办法：
<!-- more -->
**oracle 9i:**
sys用户以sysdba身份登录
先查看当前shared_pool_size值
sql>show parameter shared_pool_size;
然后
sql>alter system set shared_pool_size='比原先值适当增加' scope=spfile;
然后
sql>shutdown immediate
sql>startup

**oracle 10g:**
oracle 10g shared_pool_size默认值为0，也就是系统自动管理shared pool内存，这时可以适当增加shared_pool_reserved_size的值,仍然让系统自动管理这部分内存

sql>alter system set shared_pool_reserved_size='比原先值适当增加' scope=spfile;
sql>shutdown immediate
sql>startup