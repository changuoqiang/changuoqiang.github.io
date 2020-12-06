---
title: FAL_CLIENT和FAL_SERVER参数详解
tags:
  - Oracle
id: '1626'
categories:
  - - Database
date: 2011-11-01 21:04:11
---

FAL_CLIENT和FAL_SERVER是配置dataguard用到的两个参数,FAL指获取归档日志(Fetch Archived Log)
<!-- more -->
在一定的条件下，或者因为网络失败，或者因为资源紧张，会在primary和standby之间产生裂隙，也就是有些归档日志没有及时的传输并应用到standby库。因为MRP(managed recovery process)/LSP(logical standby process)没有与primary直接通讯的能力来获取丢失的归档日志。因此这些gaps通过FAL客户和服务器来解决，由初始化参数定义FAL_CLIENT和FAL_SERVER。

FAL_SERVER指定一个Oracle Net service name,standby数据库使用这个参数连接到FAL server,这个参数适用于standby站点。比如,FAL_SERVER = PrimaryDB,此处PrimaryDB是一个TNS name,指向primary库。

FAL_CLIENT指定一个FAL客户端的名字，以便FAL Server可以引用standby库，这也是一个TNS name，primary库必须适当配置此TNS name指向stanby库。这个参数也是在standby库端设置。比如，FAL_CLIENT = StandbyDB,StandbyDB是standby库的TNS name。

FAL_CLIENT和FAL_SERVER应该成对设置或改变。

这两个参数只需在standby库设置，但也可以在primary库设置这两个参数，以方便switchover或failover时primary库转变为standby角色。