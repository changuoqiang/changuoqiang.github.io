---
title: oracle 10g 日志分析工具LogMiner简单使用
tags:
  - Oracle
id: '5013'
categories:
  - - Database
date: 2014-02-12 22:10:34
---

LogMiner用于分析REDO日志,既可以分析online redo log file,也可以分析archive redo log file。
<!-- more -->
最近因为要分析一个数据库的表结构,所以想起了logminer。这个数据库没有表结构说明,应用程序也只有一部分源代码,想了解库结构,logminer正好派上用场了。

先切换日志,然后在应用程序中做一些操作,然后分析当前redo日志,就可以看到哪些表的哪些字段做了修改。

这里使用的是windows平台上的oracle 10g 10.2.0.4数据库(一个服务器上的测试环境)。

**简单步骤**

1.  **安装logmnr包**

安装logminer的两个包DBMS_LOGMNR和DBMS_LOGMNR_D,系统默认安装自带了logminer包。
\[sql\]
> conn / as sysdba
SQL> @D:\\oracle\\product\\10.2.0\\db_1\\RDBMS\\ADMIN\\dbmslm.sql
SQL> @D:\\oracle\\product\\10.2.0\\db_1\\RDBMS\\ADMIN\\dbmslmd.sql
SQL> @D:\\oracle\\product\\10.2.0\\db_1\\RDBMS\\ADMIN\\dbmslms.sql
\[/sql\]
2.  **添加附加日志支持**

打开Supplemental Logging,可以获得更多的日志信息
使用下面的语句之一开启Supplemental Logging的不同程度的支持:
\[sql\]SQL>ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (PRIMARY KEY, UNIQUE INDEX) COLUMNS;\[/sql\]
或者
\[sql\]SQL>ALTER DATABASE ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;\[/sql\]

3.  **创建数据字典**
\[sql\]
SQL> alter system set utl_file_dir='d:\\oracle\\logmnr' scope=spfile;
SQL> EXECUTE dbms_logmnr_d.build('dictionary.ora','d:\\oracle\\logmnr'); 
SQL> shutdown immediate;
SQL> startup;
\[/sql\]
如果logminer数据库与被分析的日志文件都在同一个数据库中,也可以使用在线数据字典。
4.  **添加要分析的日志文件**

切换日志,做一些操作后,就可以将日志文件添加到logminer进行分析
\[sql\]
SQL> ALTER SYSTEM SWITCH LOGFILE;
...
SQL> EXECUTE dbms_logmnr.add_logfile(LogFileName=>'D:\\oracle\\product\\10.2.0\\
oradata\\orcl\\REDO03.log',Options=>dbms_logmnr.new);
\[/sql\]
注意第一个添加的日志使用参数dbms_logmnr.new,后续添加的日志使用dbms_logmnr.addfile,如:
\[sql\]
EXECUTE dbms_logmnr.add_logfile(LogFileName=>'D:\\oracle\\product\\10.2.0\\oradata\\orcl\\
REDO01.log',Options=>dbms_logmnr.addfile);
\[/sql\]
去掉要分析的日志文件使用如下命令:
\[sql\]
SQL>execute dbms_logmnr.remove_logfile(logfilename=>'\\path\\to\\redofile'); 
\[/sql\]
5.  **分析日志文件**

使用生成的字典分析日志文件:
\[sql\]
SQL> execute dbms_logmnr.start_logmnr(dictfilename=>'d:\\oracle\\logmnr\\dictionary.ora');
\[/sql\]
使用在线字典分析日志文件:
\[sql\]
SQL> execute dbms_logmnr.start_logmnr(Options => DBMS_LOGMNR.DICT_FROM_ONLINE_CATALOG);
\[/sql\]

可以通过指定时间段或SCN段来限定日志分析范围,提高分析速度:
\[sql\]SQL>execute dbms_logmnr.start_logmnr (dictfilename =>'dictionary.ora'，
starttime =>to_date('01-Aug-2013 08:30:00', 'DD-MON-YYYY HH:MI S'),
endtime => to_date('01-Aug-2013 08:50:00', 'DD-MON-YYYY HH:MI S'));\[/sql\]
或
\[sql\]
SQL> execute dbms_logmnr.start_logmnr (dictfilename =>'dictionary.ora',
startscn =>1000,endscn =>1050);
\[/sql\]
6.  **查询结果**

分析结果在表v$logmnr_contents中,表中关键的字段有:
sql_redo - 所做的sql语句
username - 执行sql的数据库用户名
operation - sql操作类型,比如INSERT,DELETE等
table_name - sql操作的表名字
比如根据特征字符串这样查询:
\[sql\]
SQL> select sql_redo,table_name from v$logmnr_contents 
where operation='INSERT' and sql_redo like '%foobar%';
\[/sql\]

可以使用DESC获取v$logmnr_contents完整的字段列表。

7.  **退出logminer**

\[sql\]SQL> execute dbms_logmnr.end_logmnr;\[/sql\]

**\===
\[erq\]**