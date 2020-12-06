---
title: 'oracle 10g 修改SGA,PGA大小'
tags:
  - Oracle
id: '981'
categories:
  - - Database
date: 2011-02-15 20:38:54
---

一、概念
SGA指系统全局区域(System Global Area),是用于存储数据库信息的内存区，该信息为数据库进程所共享。
<!-- more -->
PGA指进程全局区域(Process Global Area),包含单个服务器进程或单个后台进程的数据和控制信息，与几个进程共享的SGA 正相反,PGA 是只被一个进程使用的区域，PGA 在创建进程时分配,在终止进程时回收。 Oracle 10g提供了PGA内存的自动管理。参数pga_aggregate_target可以指定PGA内存的最大值。当参数 pga_aggregate_target大于0时，Oracle将自动管理pga内存，并且各进程的所占PGA之和，不大于 pga_aggregate_target所指定的值。

二、配置
oracle推荐OLTP(on-line Transaction Processing)系统oracle占系统总内存的80%,然后再分配80%给SGA,20%给PGA。也就是
SGA=system_total_memory*80%*80% 
PGA=system_total_memory*80%*20%

三、操作
用SYS用户以SYSDBA身份登录系统
alter system set sga_max_size=2000m scope=spfile;
alter system set sga_target=2000m scope=spfile;
alter system set pga_aggregate_target=500m scope=spfile;

然后重新启动数据库
最后查看一下是否生效
show parameter sga_max_size;
show parameter sga_target;
show parameter pga_aggregate_target;