---
title: 废除rman备份对象记录
tags:
  - Oracle
id: '2464'
categories:
  - - Database
date: 2012-09-14 14:28:51
---

可以直接从rman中删除备份、备份集、拷贝等备份对象的记录信息。
<!-- more -->
使用CHANGE ... UNCATALOG来删除记录,rman会从控制文件中删除相应的记录,如果使用了恢复目录,rman也会从恢复目录中删除这些记录。但RMAN不会对相应的物理文件做任何动作,它只是从控制文件或恢复目录中删除这些物理文件对应的记录。

命令格式:
CHANGE \[ARCHIVELOG BACKUP BACKUPPIECE BACKUPSET COPY CONTROLFILECOPY DATAFILECOPY\] \[file specification key\] UNCATALOG;

比如:
RMAN>CHANGE DATAFILECOPY '/path/to/datafilecopy' UNCATALOG;

uncataloged datafile copy
datafile copy filename=/path/to/datafilecopy recid=xxx stamp=xxx
Uncataloged 1 objects

或者直接指定备份对象的key
RMAN>CHANGE DATAFILECOPY 63722 UNCATALOG;