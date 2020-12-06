---
title: rman中obsolete和expired的区别
tags:
  - Oracle
id: '6180'
categories:
  - - Database
date: 2015-03-18 19:07:04
---


<!-- more -->
obsolete是过期的备份，是指超过备份集保留策略(retention policy)的备份。

而expired是指无效的备份，比如已经从存储介质上物理删除，但rman的信息中仍然有这些备份的信息，这些备份被crosscheck命令标记为无效的。

\[sql\]
delete obsolete; //删除过期的备份
crosscheck archivelog all; 
delete expired archivelog all; //删除无效的归档日志
crosscheck backup;
delete expired backup; //删除无效的备份集
\[/sql\]

**\===
\[erq\]**