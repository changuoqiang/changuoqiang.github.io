---
title: rman删除控制文件拷贝(control file copy)
tags:
  - Oracle
id: '2138'
categories:
  - - Database
date: 2012-04-20 10:02:35
---

rman备份日志出现了如下警告：
<!-- more -->
 Deleting the following obsolete backups and copies:  
Type                 Key    Completion Time    Filename/Handle  
-------------------- ------ ------------------ --------------------  
Control File Copy     25208  25-JAN-12          D:\\CONTROL01.CTL  
  
RMAN-06207: WARNING: 1 objects could not be deleted for DISK channel(s) due  
RMAN-06208:          to mismatched status.  Use CROSSCHECK command to fix status  
RMAN-06210: List of Mismatched objects  
RMAN-06211: ==========================  
RMAN-06212:   Object Type   Filename/Handle  
RMAN-06213: --------------- ---------------------------------------------------  
RMAN-06214: Datafile Copy   D:\\CONTROL01.CTL 

看文件日期和路径,发现是配置dataguard环境时通过以下SQL语句为standby生成的控制文件

SQL>alter database create standby controlfile as ‘d:\\control01.ctl’;

此文件早已物理删除,但数据库的控制文件中仍然留有此文件的信息。通过RMAN日志可以看出,此文件为控制文件的copy,而不是backup,所以rman针对backup的命令无法删除此文件。

**关于copy**

oracle 9i及早期版本的rman有两个命令backup和copy用来备份数据文件。backup命令将数据文件合并到一个备份片,并以特有的格式保存。而copy命令则一对一产生数据文件的拷贝。从10g开始,copy命令已经过时,不再推荐使用,其功能被合并到增强的backup命令中,通过在backup命令中添加BACKUP AS COPY来执行拷贝功能。

**RMAN中删除控制文件copy**

1.  首先物理删除copy文件,这里早已经删除了,用以下命令查看控制文件copy
    
    RMAN> list copy of controlfile;
    
    List of Control File Copies
    Key S Completion Time Ckp SCN Ckp Time Name
    ------- - --------------- ---------- --------------- ----
    25208 A 25-JAN-12 1705616069 25-JAN-12 D:\\CONTROL01.CTL
    
  
3.  crosscheck控制文件拷贝
    RMAN> crosscheck copy of controlfile;
    
    starting full resync of recovery catalog
    full resync complete
    released channel: ORA_DISK_1
    allocated channel: ORA_DISK_1
    channel ORA_DISK_1: sid=70 devtype=DISK
    validation failed for control file copy
    control file copy filename=D:\\CONTROL01.CTL recid=1 stamp=773453607
    Crosschecked 1 objects
    
  

5.  删除控制文件copy
    RMAN> delete copy of controlfile;
    
    released channel: ORA_DISK_1
    allocated channel: ORA_DISK_1
    channel ORA_DISK_1: sid=70 devtype=DISK
    
    List of Control File Copies
    Key S Completion Time Ckp SCN Ckp Time Name
    ------- - --------------- ---------- --------------- ----
    25208 X 25-JAN-12 1705616069 25-JAN-12 D:\\CONTROL01.CTL
    
    Do you really want to delete the above objects (enter YES or NO)? YES
    deleted control file copy
    control file copy filename=D:\\CONTROL01.CTL recid=1 stamp=773453607
    Deleted 1 objects
    
  
7.  重新查看控制文件copy
    RMAN> list copy of controlfile;
    RMAN>
    
    可以看到已经没有控制文件copy存在了
  

copy 命令支持archivelog, controlfile, database, datafile, spfile, tablespace这几个选项。