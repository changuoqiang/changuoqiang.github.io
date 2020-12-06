---
title: 只读表空间的备份和恢复
tags:
  - Oracle
id: '7236'
categories:
  - - Database
date: 2016-05-11 16:43:32
---


<!-- more -->
查询表空间状态：
\[sql\]
sql> select tablespace_name,status from dba_tablespaces;
\[/sql\]

修改表空间状态为READ ONLY：
\[sql\]
sql> alter tablespace tablespace_name read only;
\[/sql\]

表空间置为READ ONLY之后，不再发生任何变化，只需保存一份有效的备份即可，可以使用RMAN，也可以使用OS直接拷贝数据文件来备份只读表空间。

之后日常备份时就可以skip readonly来忽略掉只读表空间的备份，加速备份速度。

但恢复数据库时记得要check readonly,即使没有只读表空间，恢复仍然会成功，但open数据库会出现错误。

如果不使用check readonly，记得要将只读表空间的数据文件拷贝到相应的位置之后再recover数据库。


References:
\[1\][Oracle Read-only Tablespace(只读表空间)](http://www.cnblogs.com/Richardzhu/articles/2890833.html)
\[2\][(09)常被人遗忘的只读表空间](http://blog.csdn.net/xcl168/article/details/20297247)
\[3\][Database Backup and Recovery Basics](https://docs.oracle.com/cd/B19306_01/backup.102/b14192/recov002.htm)
\[4\][只读表空间的备份与恢复](http://blog.csdn.net/leshami/article/details/6646492)
\[5\][READ ONLY Tablespace Restore and Recovery](http://gavinsoorma.com/2009/08/read-only-tablespace-restore-and-recovery/)
\[6\][Backing up, Restoring and Recovering Read Only tablespaces with RMAN](http://kubilaykara.blogspot.com/2008/02/backing-up-restoring-and-recovering.html)
\[7\][Read Only Tablespaces and BACKUP OPTIMIZATION](https://hemantoracledba.blogspot.com/2010/05/read-only-tablespaces-and-backup.html)
\[8\][Rman管理命令](http://www.xifenfei.com/2011/04/rman%E7%AE%A1%E7%90%86%E5%91%BD%E4%BB%A4.html)

**\===
\[erq\]**