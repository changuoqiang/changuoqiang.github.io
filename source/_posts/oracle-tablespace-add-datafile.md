---
title: oracle 10g为表空间增加数据文件
tags:
  - Oracle
id: '2522'
categories:
  - - Database
date: 2012-10-15 14:10:42
---

使用ALTER TABLESPACE语句,比较简单,记录以备忘。
<!-- more -->
先查询一下表空间数据文件:
\[sql\]
select tablespace_name, file_id,file_name, round(bytes/(1024*1024),0) total_space 
from dba_data_files order by tablespace_name;
\[/sql\]

增加数据文件：
\[sql\]
SQL> ALTER TABLESPACE tbsname
ADD DATAFILE '/path/to/datafile'
SIZE 500M
AUTOEXTEND ON
NEXT 500M
MAXSIZE UNLIMITED;
\[/sql\]

虽然此处设置MAXSIZE为UNLIMITED,但数据文件的最大大小受制于其表空间类型和block_size的大小。
使用小文件表空间,block_size为8K时,单个数据文件的最大大小约在8k*(222\-1)=33554424K≈32767.99M。