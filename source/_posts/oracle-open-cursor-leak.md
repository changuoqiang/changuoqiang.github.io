---
title: oracle 游标泄露问题查找
tags:
  - Oracle
id: '7789'
categories:
  - - Database
date: 2016-11-29 13:37:32
---


<!-- more -->
游标会占用系统资源，oracle中游标分配在shared pool内存池，用完了连接(connection)、语句(statement,preparedStatement)和结果集(resultSet)一定要记得释放，不然系统打开游标会持续上升，直到达到系统设置的阈值，无法获取游标的事务就会失败。

**查看系统配置的最大打开游标数量和当前已打开游标数量**
\[sql\]
sql> select (select count(*) from V$OPEN_CURSOR) as opened_cursors, 
(select value from v$parameter where name='open_cursors') as max_cursors from dual;
OPENED_CURSORS MAX_CURSORS
-------------- ------------------------------
 1362 65535
\[/sql\]

**查询会话打开的游标**

\[sql\]
sql> select s.sid, s.username, s.osuser,s.machine, a.value 
from v$sesstat a, v$statname b, v$session s 
where a.statistic# = b.statistic# and s.sid=a.sid and b.name = 'opened cursors current' and s.username is not null 
order by a.value desc;
 SID USERNAME OSUSER MACHINE VALUE
---------- ------------------------------ ------------------------------ ------------------------------ ----------
 405 TT NETWORK?SERVICE WORKGROUP\\VIRT-APP-EXTERN 51
 466 TT NETWORK?SERVICE WORKGROUP\\VIRT-APP 49
 491 TT Administrator WORKGROUP\\VIRT-APP 13
 422 TT Administrator WORKGROUP\\VIRT-APP 11
 475 TT Administrator WORKGROUP\\VIRT-APP 10
......
\[/sql\]
或者
\[sql\]
sql> select o.sid, s.username, s.osuser, s.machine, count(*) num 
from v$open_cursor o, v$session s 
where o.sid = s.sid 
group by o.sid,s.username, s.osuser, s.machine 
order by num desc;
 SID USERNAME OSUSER MACHINE NUM
---------- ------------------------------ ------------------------------ ------------------------------ ----------
 464 TT NETWORK?SERVICE WORKGROUP\\VIRT-APP-EXTERN 34
 471 TT NETWORK?SERVICE WORKGROUP\\VIRT-APP-EXTERN 30
 475 TT Administrator WORKGROUP\\VIRT-APP 28
 491 TT Administrator WORKGROUP\\VIRT-APP 27
......
\[/sql\]

**查询会话执行的sql语句**

\[sql\]
sql> select sid, sql_text, count(sql_text) as num
from v$open_cursor
group by sid, sql_text having count(sql_text)>5
order by num desc;
 SID SQL_TEXT NUM
---------- ------------------------------------------------------------ ----------
 464 select b.*,bb.buildno,bb.BUILDNAME from bldroom b join build 40
 464 select t2.businessname,t3.firstname,t1.opion,t1.receivedatet 36
 464 select distinct t2.certid,t2.certno from rightcertroom t1 jo 34
......
\[/sql\]

或者更直接的查询每个sql语句打开的游标数量
\[sql\]
sql> select s.sid, s.osuser,s.machine, o.sql_text, count(o.sql_text) as num
from v$open_cursor o
join v$session s on o.sid=s.sid
group by s.sid, s.osuser,s.machine,o.sql_text having count(o.sql_text)>50
order by num desc;
 SID OSUSER MACHINE SQL_TEXT NUM
---------- ---------- -------------------- ------------------------------------------------------------ ----------
 464 tomcat8 clean select t2.businessname,t3.firstname,t1.opion,t1.receivedatet 35
 464 tomcat8 clean select b.*,bb.buildno,bb.BUILDNAME from bldroom b join build 34
 464 tomcat8 clean select distinct t2.certid,t2.certno from rightcertroom t1 jo 28
......
\[/sql\]

找到对应的SQL语句就可以审计对应的代码，查找资源泄露的情况。

**\===
\[erq\]**