---
title: 2003 R2平台oracle 9206数据库冷备份恢复的路径依赖问题
tags:
  - Oracle
id: '841'
categories:
  - - Database
date: 2010-05-20 15:46:37
---

windows 2003 R2做oracle数据库冷备份恢复时遇到路径依赖问题，原库oracle安装在F分区，而恢复到的oracle安装在E分区。两边数据库的版本是完全一致的，除了安装路径不同,sid实例名都为orcl。停下服务器后，把原库的控制文件、数据文件、联机日志文件(online redo files)、初始化参数文件(spfile)、密码文件拷贝到了新库安装目录。如果数据库运行于归档模式,还应单独备份归档日志文件。实际上为了省事，把oracle的安装目录整个同步了一遍。拷贝完后oracle服务无法启动，无法启动就对了。这些关键文件的路径都变了，库肯定是打不开了。怎么办？

两个方法，一是重新安装oracle使其路径与原库一致,二是修改关键文件的路径。第一种没啥意思，就第二种吧。

因为机器名字不同了，所以要打开\\oracle\\ora92\\network\\admin下面的几个文件tnsnames.ora、snmp_ro.ora和listener.ora把里面的机器名改成正确的值,snmp_ro.ora和listener.ora文件里面的文件路径改为正确的值。

参数文件里面记录了控制文件的路径，要把这些路径更改过来。oracle 9i默认是使用spfile的，而spfile是二进制的，最好不要直接修改，导出pfile，修改控制文件路径后再导回去就ok了
<!-- more -->
\>sqlplus "/ as sysdba"
SQL>create pfile="e:\\oracle\\admin\\orcl\\pfile\\initorcl.ora" from spfile

然后打开initorcl.ora修改控制文件路径为实际的控制文件路径，再导回到spfile

SQL>create spfile from pfile="e:\\oracle\\admin\\orcl\\pfile\\initorcl.ora"

然后重建控制文件，因为控制文件里面记录了数据文件、日志文件的路径。数据文件好多啊，还是先从原库备份一下控制文件吧

SQL>alter database backup controlfile to trace;

找到生成的trc文件，路径为F:\\oracle\\admin\\orcl\\udump\\orcl_ora_xxxx.trc，看看生成时间就能知道是哪个了。从这个文件里面提取出一个sql文件来，因为日志文件是完整的，就提取NORESETLOGS这段,保存到文件createctrlfile.sql。oracle 9206生成的这个脚本有个bug,CHARACTER SET ZHS16GBK这行的上面一行多了个逗号，去掉就可以了。语句的样子大体如下

STARTUP NOMOUNT
CREATE CONTROLFILE REUSE DATABASE "ORCL" NORESETLOGS NOARCHIVELOG
-- SET STANDBY TO MAXIMIZE PERFORMANCE
 MAXLOGFILES 50
 MAXLOGMEMBERS 5
 MAXDATAFILES 100
 MAXINSTANCES 1
 MAXLOGHISTORY 2722
LOGFILE
 GROUP 1 'F:\\ORACLE\\ORADATA\\ORCL\\REDO01.LOG' SIZE 100M,
 GROUP 2 'F:\\ORACLE\\ORADATA\\ORCL\\REDO02.LOG' SIZE 100M,
 GROUP 3 'F:\\ORACLE\\ORADATA\\ORCL\\REDO03.LOG' SIZE 100M
-- STANDBY LOGFILE
DATAFILE
 'F:\\ORACLE\\ORADATA\\ORCL\\SYSTEM01.DBF',
 'F:\\ORACLE\\ORADATA\\ORCL\\UNDOTBS01.DBF',
 'F:\\ORACLE\\ORADATA\\ORCL\\CWMLITE01.DBF',
 'F:\\ORACLE\\ORADATA\\ORCL\\DRSYS01.DBF',
 ...
CHARACTER SET ZHS16GBK
;

把这个sql里面的数据文件和日志文件的路径修改成正确的路径后，执行一下语句

>sqlplus "/ as sysdba"
SQL>shutdown immediate
SQL>@createctrlfile.sql

提示控制文件重建完成就ok了，然后

SQL>alter database open

就可以启动数据库了。抱怨一句，oracle数据库的这些关键文件为什么不用相对路径呢？相对于$ORACLE_HOME不就得了吗，真烦！