---
title: oracle 10g 增量备份机制
tags:
  - Oracle
id: '1989'
categories:
  - - Database
date: 2012-03-21 13:51:53
---

oracle从10g开始有了真正的增量备份机制。
<!-- more -->
**块变化跟踪**

为什么说“真正”呢,因为之前的版本在做增量备份时需要全扫描数据库,查找变化了的数据块,其实这样还不如做全备份,所以十分鸡肋。而10g开始对增量备份机制进行了改进,可以实时跟踪自上次备份以来变化了的数据块,这样进行增量备份时只要读取这个列表然后备份变化了的数据块即可,不用全库扫描自然会快很多,减轻系统IO负载。

但默认情况下这种跟踪机制并没有打开。

1、查询跟踪机制是否打开

SQL>select filename,status from v$block_change_tracking;
STATUS
-------
DISABLED

2、打开块变化跟踪机制

SQL>alter database enable block change tracking using file '/u01/app/oracle/product/10.2.0/oradata/db_target/block_change.log';

Database altered.

**增量备份类型和级别**

RMAN提供了两种增量备份类型:DIFFERENTIAL(差异增量)和CUMULATIVE(累积增量)。默认情况下RMAN创建的增量备份是DIFFERENTIAL方式,如果要建立CUMULATIVE方式的增量备份,需要要在执行BACKUP命令时显式指定。

DIFFERENTIAL方式备份自上次更高级别或同级别的备份以来变化的数据块,而CUMULATIVE方式则备份自上次更高级别的备份以来变化的数据块。

oracle 10g只支持两个备份级别0级和1级,虽然其他级别可能也可以使用,但官方只提到了这两个备份级别。