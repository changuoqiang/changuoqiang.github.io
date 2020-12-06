---
title: sqlplus输出xls
tags:
  - Oracle
id: '7522'
categories:
  - - Database
date: 2016-08-10 15:04:46
---


<!-- more -->
sql脚本文件内容如下:

```js
set linesize 200 
set term off verify off feedback off pagesize 999 
set markup html on entmap ON spool on preformat off
spool result.xls
@query.sql
spool off
exit
```

entmap是指html实体映射,ent是entity的简写

将输出文件的名称改为.html后缀,即可输出html文档.其实输出的内容是完全一样的,只是文件扩展名不同.

sqlplus set指令详见\[1\]

References:
\[1\][SET System Variable Summary](https://docs.oracle.com/cd/E11882_01/server.112/e16604/ch_twelve040.htm#SQPUG060)

**\===
\[erq\]**