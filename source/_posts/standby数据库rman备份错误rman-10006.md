---
title: standby数据库rman备份错误RMAN-10006
tags:
  - Oracle
id: '8751'
categories:
  - - Database
date: 2019-09-29 10:02:49
---


<!-- more -->
在物理备库上执行rman备份时出现错误:
```js
MAN-00601: fatal error in recovery manager
RMAN-03004: fatal error during execution of command
RMAN-10006: error running SQL statement: select sofar, context, start_time from v$session_longops where (start_time > nvl(:1, sysdate-100) or start_time = nvl(:2, sysdate+100)) and sid = :3 and serial# = :4 and opname like 'RMAN:%' order by start_time desc, context desc
RMAN-10002: ORACLE error: ORA-00000: normal, successful completion
```

这是oracle的一个bug

Metalink NoteID：1080134.1.
Cause
Unpublished Bug 4230058: FAIL TO CONNECT TO RMAN AFTER PHYSICAL STANDBY IS OPENED READ ONLY

If the standby database is opened readonly and then managed recovery is restarted without bouncing the database, queries against v$session_longops will fail with:

ORA-01219: database not open: queries allowed on fixed tables/views only

RMAN likewise will fail trying to access this view with RMAN-10006 error.

Solution
Restart the standby database after opening it in READ ONLY mode before restarting the Managed Recovery process.

最简单的解决方案就是重启standby实例，还有一个方法是修改数据库参数，但是如果备库转换为主库，这个参数可能会有影响，所以还是重启实例最简单。


References:
\[1\][RMAN backup of physical standby fails RMAN-10006 querying v$session_longops (Doc ID 1080134.1)](https://support.oracle.com/knowledge/Oracle%20Database%20Products/1080134_1.html)
\[2\][Standby上执行RMAN报错RMAN-10006错误处理](https://www.linuxidc.com/Linux/2013-09/90095.htm)
\[3\][9208物理standby备份报错](http://blog.itpub.net/79499/viewspace-616835/)