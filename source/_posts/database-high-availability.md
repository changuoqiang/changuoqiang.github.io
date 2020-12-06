---
title: 数据库高可用概念(database high availability)
tags: []
id: '6843'
categories:
  - - Database
date: 2015-11-03 22:13:33
---


<!-- more -->
数据库高可用是为了降低停机时间，提高数据库服务器的持续服务能力，减少数据丢失，减少服务恢复时间。

大体可以有以下几个分类：

*   cold standby
最传统的备份/恢复模式属于此类。主库定期备份，备份数据可以存储到主库以外的其他存储介质上。当主库当机时，启动备机，从备份中恢复主库最近的一次备份，然后接替主库对外提供服务。这种模式数据丢失的风险极大，最后一次备份到当机之间的数据丢失的可能性很大。而且，当数据库很大时，备机的恢复时间可能会相当长，达几个小时甚至几十个小时。
*   warm standby
主备库同时运行，主库数据以同步或异步方式复制到备库，主库崩溃时的恢复时间很短，但是备库在正常状态下是无法提供服务的。
*   hot standby
主备库同时运行，主库数据以同步或异步方式复制到备库，主库崩溃时的恢复时间很短，备库可以提供只读查询服务。如果是流式复制方式，一般提交的事务都不会丢失。数据丢失的风险很低。
*   active-active
这就是传说中的双活或多活，或叫master-master模式，多个数据库互为主备，一起对外提供服务，一个崩溃，不影响系统对外提供服务，只是服务的性能会有下降。这种模式又可以称作负载均衡load balance。

postgresql对warm standby和hot standby的定义:

A standby server that cannot be connected to until it is promoted to a master server is called a warm standby server, and one that can accept connections and serves read-only queries is called a hot standby server.

**\===
\[erq\]**