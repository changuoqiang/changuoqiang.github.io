---
title: Oracle $SQLPATH环境变量
tags:
  - Oracle
id: '1910'
categories:
  - - Database
date: 2012-01-18 09:34:21
---

SQL*PLUS启动时会自动查找运行两个脚本glogin.sql和login.sql
<!-- more -->
glogin.sql是sqlplus的全局登录profile,是oracle系统自带的脚本,其路径是固定的$ORACLE_HOME/sqlplus/admin。当用户启动sqlplus时,会从这个固定的路径加载glogin.sql,一般来说我们不用关心glogin.sql。

login.sql是用户登录的profile,sqlplus加载glogin.sql之后会查找并试图加载login.sql。sqlplus先从当前路径查找login.sql,如果找到就加载此脚本并停止继续查找,如果当前路径未找到该脚本,则继续从环境变量$SQLPATH指定的路径查找,如找到login.sql则加载之,之后不再继续查找。如果$SQLPATH未设定或指定的目录下未找到login.sql,则停止查找。

可以将习惯的sqlplus设置置于login.sql脚本,并设置$SQLPATH环境变量,就不用每次登录再手工设置了。

glogin.sql和login.sql类似于shell的登录脚本。

P.S.
我的login.sql
\[sql\]
--
--SQL*PLUS user login profile file
--

--the default editor for ED\[IT\] command
define _editor=vim

--enable dbms_output.put_line output
set serveroutput on size 1000000 format wrapped

--trim the spool out
set trimspool on

--for LONG,COLB display
set long 5000

--chars per line to output
set linesize 100

--lines per page
set pagesize 9999

--set prompt,format as user@dbname_ip>
set termout off
define gname=idle
column global_name new_value gname

select lower(user)'@'substr(global_name,1,decode(dot,0,length(global_name),dot-1))
'_'(select utl_inaddr.get_host_address from dual) global_name
from (select global_name,instr(global_name,'.')dot from global_name);

set sqlprompt '&gname>'
set termout on
\[/sql\]

References:
\[1\][SET System Variable Summary](https://docs.oracle.com/cd/E11882_01/server.112/e16604/ch_twelve040.htm#SQPUG060)
\[2\][define \[SQL*Plus\]](http://www.adp-gmbh.ch/ora/sqlplus/define.html)
\[3\][SET \[SQL*Plus\]](http://www.adp-gmbh.ch/ora/sqlplus/set.html)
\[4\][column \[SQL*Plus\]](http://www.adp-gmbh.ch/ora/sqlplus/column.html)

**\===
\[erq\]**