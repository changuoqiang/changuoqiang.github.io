---
title: oracle 10g使用物理备库恢复主库损坏/丢失的数据文件
tags: []
id: '8723'
categories:
  - - Database
date: 2019-09-25 13:54:48
---


<!-- more -->
**0 症状**

oracle 10g dataguard主库某一数据文件发现有损坏，使用dbv检测数据文件:
```js
cmd> dbv file=E:\\oracle\\product\\10.2.0\\db_1\\database\\afsts.dbf feedback=100
....
DBV-00102: File I/O error on FILE (E:\\oracle\\product\\10.2.0\\db_1\\database\\afsts.dbf) during verification read operation (-2)
```

操作系统中拷贝数据文件会出现错误"无法复制 AFSTS: 数据错误(循环冗余检查)。"，事件查看器中发现错误“设备 \\Device\\Harddisk1\\DR1 有一个不正确的区块。”，数据文件有物理损坏。

此时数据文件无法拷贝和删除，需要将数据文件离线，然后用chkdsk系统工具修复，或者使用“分区”右键属性里的"工具"->"查错"->“开始检查”,选中“自动修复文件系统错误”
```js
cmd> chkdsk e: /F /I /C
```
/I和/C用于跳过部分检查，减少扫描时间。
修复错误后，数据文件的内容可能已经不正确了，需要使用standby数据库数据文件恢复。

**注：使用rman restore数据文件可以直接恢复，无需提前修复文件系统错误。**

**1 修复**

1.1 首先确保用于恢复的数据文件是没有损坏的

备库端:

a. dbv检查
```js
cmd> dbv file=E:\\oracle\\product\\10.2.0\\db_1\\database\\afsts.dbf feedback=100
........
Total Pages Examined : 61440
Total Pages Processed (Data) : 70
Total Pages Failing (Data) : 0
Total Pages Processed (Index): 58217
Total Pages Failing (Index): 0
Total Pages Processed (Other): 1009
Total Pages Processed (Seg) : 0
Total Pages Failing (Seg) : 0
Total Pages Empty : 2144
Total Pages Marked Corrupt : 0
Total Pages Influx : 0
Highest block SCN : 1519113269 (2.1519113269)
```
确保Total Pages Failing (Data),Total Pages Failing (Index),Total Pages Failing (Seg) 和Total Pages Marked Corrupt皆为0

b. rman检查

找出数据文件的编号
```js
sql> select FILE#,NAME,STATUS from v$datafile where name like '%AFSTS.DBF%';
```

数据文件检查
```js
$ rman target sys/password@db_feich;
RMAN> backup validate check logical datafile 20;
SQL> select * from v$database_block_corruption;
```
因为物理standby是mounted状态，是不可写的。所以此检查对于正在进行日志恢复的standby是无法实施的。

1.2 备库端操作

备份数据文件
```js
$ rman target sys/password@db_standby;
RMAN> backup as copy datafile 20 format 'd:\\afsts.bak';
//RMAN> backup datafile 20 format 'd:\\afsts.bak';
```

1.3 主库端操作

a. 将备库备份的数据文件拷贝到主库相同的目录结构下

b. 将备份加入恢复目录catalog
```js
$ rman target sys/password@db_primary;
RMAN> catalog datafilecopy 'd:\\afsts.bak';
RMAN> list datafilecopy all;
RMAN> list datafilecopy 'd:\\afsts.bak';
//RMAN> catalog backuppiece 'd:\\afsts.bak';
//RMAN> list backup of datafile 20;
//RMAN> list backuppiece 'd:\\afsts.bak';
```

c. 数据文件离线
```js
$ sqlplus sys/password@db_primary as sysdba;
SQL> alter database datafile 20 offline;
```

d. restore/recover数据文件
```js
$ rman target sys/password@db_primary;
RMAN> restore datafile 20;
RMAN> recover datafile 20;
```

e. 数据文件上线
```js
RMAN> sql 'alter database datafile 20 online';
//SQL> alter database datafile 20 online;
```

f. 检查数据文件完整性
```js
RMAN> backup validate check logical datafile 20;
SQL> select * from v$database_block_corruption;
no rows selected
```
也可以再用dbv检查一下

完毕，也可以用主库数据文件恢复备库丢失或损坏的数据文件，只不过操作方向不同而已。

References:
\[1\][Recovering the primary database's datafile using the physical standby, and vice versa (Doc ID 453153.1)](https://support.oracle.com/knowledge/Oracle%20Database%20Products/453153_1.html#aref_section22)
\[2\][Recover the Primary Database's datafile using a copy of a Physical Standby Database's Datafile](http://yvrk1973.blogspot.com/2012/08/recover-primary-databases-datafile.html)
\[3\][Recovering a corrupted/lost datafile on Primary database from the Standby database](https://shivanandarao-oracle.com/2014/05/03/recovering-a-corruptedlost-datafile-on-primary-database-from-the-standby-database/)
\[4\][Steps to recover the standby database’s datafile using a backup of the primary database’s data file](http://oracle-help.com/dataguard/steps-to-recover-the-standby-databases-datafile-using-backup-of-primary-databases-datafile/)