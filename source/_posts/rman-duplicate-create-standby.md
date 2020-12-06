---
title: RMAN DUPLICATE创建DataGuard物理备库
tags:
  - Oracle
id: '2426'
categories:
  - - Database
date: 2012-08-07 15:27:10
---

Oracle推荐使用rman来创建物理备库,可以在不影响主库的情况下,轻松完成物理备库的创建。
<!-- more -->
这里只记叙物理备库与主库位于不用的主机,并且数据库的目录结构一致的情况,这应该也是Dataguard环境比较常见的部署方式,这种方式也比较简单。

系统运行环境为windows 2003 server 64bits + oracle 10g 10.2.0.4 64bits。
 **一、创建物理备库实例(物理备库端)**

1、安装oracle 10g

只安装软件,不创建数据库。

2、创建空闲实例
```js
CMD> oradim -new -sid orcl
```

此处指定的实例名为orcl,同时会创建系统服务OracleServiceorcl和OracleJobSchedulerorcl。
之后即可使用sqlplus / as sysdba连接到这个空闲实例。

3、创建standby的初始化参数文件

从主库创建pfile根据物理备库的实际情况进行相应修改即可

主库端执行：
```js
SQL> create pfile='d:\\INITorcl.ora' from spfile;
```

将生成的INITorcl.ora拷贝到物理备机的$ORACLE_HOME/database目录下,并做相应修改,参见[Oracle 10g DataGuard手记之基础配置](https://openwares.net/database/oracle_10g_windows_x64_dataguard.html)

然后通过针对standby修改的INITorcl.ora为物理备库生成spfile

备库端执行：
```js
CMD> sqlplus / as sysdba;
SQL> create spfile from pfile; //也可以指定pfile的详细位置pfile='/path/to/pfile',此处使用的默认位置和默认文件名
```

4、创建物理备库[密码文件](https://openwares.net/database/oracle_passwd_file.html)

备库必须通过Oracle NEt并以SYSDBA权限访问,因此密码文件是必须的,因为不能使用OS认证。

备库端执行：
```js
CMD> orapwd file=PWDorcl.ora password=yourpasswd
```

这会在备库的$ORACLE_HOME/database目录下生成密码文件PWDorcl.ora

也可以直接从主库$ORACLE_HOME/database目录下将PWDorcl.ora拷贝到物理备库相应的目录下，这样更简单。

5、启动备库到nomount

备库端：
```js
CMD> sqlplus / as sysdba;
SQL> startup nomount
```

因为此时尚没有控制文件和数据文件,因此只能启动到nomount状态

如果已经mount了，可以执行以下sql命令切换到nomount状态：
```js
SQL> alter database dismount;
```

这是可能会有错误提示：
```js
ORA-02778: Name given for the log directory is invalid
```
这是因为dump文件存储路径尚未建立,根据你参数文件的设置建立相关的dump路径,这里建立了这几个路径
```js
E:\\oracle\\product\\10.2.0\\admin\\orcl\\{adump,bdump,cdump,udump}
```

然后再执行

```js
SQL> startup nomount
```

还有可能会有错误提示:
ORA-01261: Parameter db_recovery_file_dest destination string cannot be translated
ORA-01263: Name given for file destination directory is invalid
OSD-04018: Unable to access the specified directory or device.
O/S-Error: (OS 2) 系统找不到指定的文件。
这是因为参数db_recovery_file_dest指向的路径没有建立起来,这里根据参数文件创建目录
E:\\oracle\\product\\10.2.0\\flash_recovery_area

6、配置监听文件,创建监听服务 
可以从主库拷贝$ORACLE_HOME/NETWORK/ADMIN/目录下的文件tnsname.ora,listener.ora,sqlnet.ora到备库相同的位置,并作相应的修改,特别要注意主机名部分。
只安装默认没有创建监听服务,lsnrctl命令可以在没有监听服务时自动创建监听服务

备库端：
```js
CMD> lsnrctl
LSNRCTL> status
Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
 TNS-00511: No listener
 64-bit Windows Error: 61: Unknown error
```

启动监听:

```js
LSNRCTL> start
Starting tnslsnr: please wait...

Failed to open service <OracleOraDb10g_home1TNSListener>, error 1060.
TNSLSNR for 64-bit Windows: Version 10.2.0.4.0 - Production
Log messages written to E:\\oracle\\product\\10.2.0\\db_1\\network\\log\\listener.log
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=localdb)(PORT=1521)))

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias LISTENER
Version TNSLSNR for 64-bit Windows: Version 10.2.0.4.0 - Production
Start Date 07-AUG-2012 15:32:42
Uptime 0 days 0 hr. 0 min. 7 sec
Trace Level off
Security ON: Local OS Authentication
SNMP OFF
Listener Log File E:\\oracle\\product\\10.2.0\\db_1\\network\\log\\listener.log
Listening Endpoints Summary...
 (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=localdb)(PORT=1521)))
The listener supports no services
The command completed successfully
```

这样会建立起tns监听系统服务OracleOraDb10g_home1TNSListener

7、提前创建控制文件所在的目录
参数文件中有记载的控制文件详细路径，参数名称为*.control_files。物理备库需要根据此参数的设置提前建立好控制文件所需要的上层各级目录,比如提前建立好如下目录层次:
```js
E:\\oracle\\product\\10.2.0\\oradata\\orcl
```
否则执行duplicate命令时会出现如下错误:
```js
RMAN-00571: ===========================================================
RMAN-00569: =============== ERROR MESSAGE STACK FOLLOWS ===============
RMAN-00571: ===========================================================
RMAN-03002: failure of Duplicate Db command at 
RMAN-05501: aborting duplication of target database
RMAN-03015: error occurred in stored script Memory Script
RMAN-06026: some targets not found - aborting restore
RMAN-06024: no backup or copy of the control file found to restore
```

**二、RMAN全备主库并为备库生成控制文件**

1、对主库执行全备份
RMAN正常全备主库,可以使用也可以不使用恢复目录,最重要一点,在物理备库上要可以以相同的路径访问到主库的全备份。可以在备库上建立相同的备份文件存放路径,然后通过ftp等方式将主库全备份拷贝至备库主机相同位置。也可以使用NFS等网络路径,这样可以避免在主备库之间拷贝全备份。
比如:
```js
RMAN> BACKUP DATABASE FORMAT '\\\\cifs_server\\RMAN\\bak_%U' 
 INCLUDE CURRENT CONTROLFILE FOR STANDBY 
 PLUS ARCHIVELOG FORMAT '\\\\cifs_server\\RMAN\\ARC_%U';
```

2、创建物理备库控制文件

有多种方式为物理备库生成控制文件。

*   备份主库时同时为备库生成控制文件
    
    通过使用INCLUDE CURRENT CONTROLFILE FOR STANDBY语句,可以在备份集中生成备库的控制文件,类似如下：
    ```js
    RMAN> BACKUP DATABASE FORMAT 'D:\\RMAN\\bak_%U' 
     INCLUDE CURRENT CONTROLFILE FOR STANDBY 
     PLUS ARCHIVELOG FORMAT 'D:\\RMAN\\ARC_%U';
    ```
    

*   使用RMAN COPY命令
    ```js
    RMAN> COPY CURRENT CONTROLFILE FOR STANDBY TO 'D:\\RMAN\\control01.ctl';
    ```
    
*   使用alter database语句
    
    sqlplus登录主库端执行
    ```js
    SQL> alter database create standby controlfile as 'd:\\rman\\control01.ctl';
    ```
    然后rman连接target(主库)和catalog恢复目录(如果使用的话),然后执行
    ```js
    RMAN>CATALOG CONTROLFILECOPY 'd:\\rman\\control01.ctl';
    ```
    
    这样RMAN就知道去那里找物理备库的控制文件了。

**注意:物理备库中控制文件所在路径必须提前建立起来。**

**三、创建物理备库**

1、用RMAN连接主库、物理备库和恢复目录,使用target关键字连接主库,使用auxiliary关键字连接待创建的物理备库,catalog关键字连接恢复目录数据库
```js
$ rman target sys/passwd@primarydb auxiliary sys/passwd@standbydb catalog user/passwd@catalogdb
...
connected to target database: ORCL (DBID=1276927241)
connected to recovery catalog database
connected to auxiliary database: ORCL (not mounted)
...
```
然后执行
```js
rman> duplicate target database for standby nofilenamecheck;
```

因为是异机相同目录结构复制到备库,所以必须指定参数nofilenamecheck,不然rman会晕菜。
如果不指定dorecover选项,则不进行日志恢复,物理备库创建完成后打开日志恢复自然就可以同步到主库一致的状态了。
如果RMAN数据库备份有增量备份，则应该打开DORECOVER选项以便恢复增量备份集。

如果指定了DORECOVER选项,可能会遇到如下错误:
```js
RMAN-06026: some targets not found - aborting restore 
RMAN-06024: no backup or copy of the control file found to restore
```

具体原因和解决办法参见\[2\].

备库创建完成后rman将其置于mounted状态。

2、创建备库时并不会将主库的online redo log files和standby redo log files拷贝到备库,但是控制文件中包含了这些信息。

"因为在备份前主库创建了standby redo log，备库是根据主库的信息创建的，一开始它是包含了主库的standby redo log信息，如果主库设置的日志传送方式是LGWR，当主库发生日志切换时，备库的RFS会尝试使用standby redo log来存储主库传送过来的日志，因为此时备库实际上是不存在standby redo log的，所以备库会报错。当备库尝试打开字典信息的所有standby redo log失败以后，备库会自动把日志传送方式转为ARCN，并同时清除数据字典中的standby redo log信息。"参见[DG使用中遇到的几个错误](http://space6212.itpub.net/post/12157/299427)。

因此如果需要开启实时redo apply的话,需要手动提前[添加standby redo log文件](https://openwares.net/database/oracle_10g_windows_x64_dataguard.html),如下:
备库端:
\[sql\]
SQL>alter database add standby logfile group 4 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO01.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 5 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO02.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 6 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO03.LOG') size 50M;
Database altered.
SQL>alter database add standby logfile group 7 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO04.LOG') size 50M;
Database altered.
\[/sql\]
然后就可以打开realtime redo apply了,如下打开实时日志应用:
备库端:
\[sql\]
SQL>ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
\[/sql\]

3、此时会后台日志文件中会报如下错误
```js
ORA-19527: physical standby redo log must be renamed
```
物理standby并不需要在线redo日志,因为其并不以读写方式打开。但当物理standby要switch over成为主库时是必须要使用在线redo log的,在switch over之前,oracle会清除online redo log文件,为了加快switch over进度,oracle会在开启日志应用之时提前将物理standby的online redo log文件clear。oracle为了防止意外清除了主库的online redo log文件,即使物理standby与主库不在同一台主机上,只要其路径相同则必须明确的设置log_file_name_convert参数,这样才能避免此错误提示。
因此可以通过alter system set log_file_name_convert更改此参数设置或者在备库初始化文件中添加此参数并重新生成spfile启动数据库

pfile中添加:
```js
*.log_file_name_convert='E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo01.log','E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo01.log','E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo02.log','E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo02.log','E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo03.log','E:\\oracle\\product\\10.2.0\\oradata\\orcl\\redo03.log'
```
4、检查下两边的日志同步情况
\[sql\]
SQL>select sequence# from v$archived_log where applied='YES';
\[/sql\]

如果oracle后台日志出现类似错误:
```js
ORA-00313: open failed for members of log group 4 of thread 1
```

只要将对应的日志组clear就可以了：
```js
SQL>ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL; #如果正在应用redo日志，需要先取消
SQL>ALTER DATABASE CLEAR LOGFILE GROUP 4;
```

物理备库创建完成。

备注:如果重新启动物理备库，只能以mount方式打开，否则会出现错误提示：
```js
SQL> startup
ORACLE instance started.

Total System Global Area 1.9327E+10 bytes
Fixed Size 2198344 bytes
Variable Size 2273014968 bytes
Database Buffers 1.7046E+10 bytes
Redo Buffers 6488064 bytes
Database mounted.
ORA-16004: backup database requires recovery
ORA-01196: file 1 is inconsistent due to a failed media recovery session
ORA-01110: data file 1: 'E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\SYSTEM01.DBF'
```

关闭后重新以mount方式打开即可：
```js
SQL> shutdown immediate;
SQL> startup mount;
```

References:
\[1\][Creating a Standby Database with Recovery Manager](http://docs.oracle.com/cd/B19306_01/server.102/b14239/rcmbackp.htm#i639101)
\[2\][RMAN-06026 tips](http://www.dba-oracle.com/t_rman_06026.htm)

**\===
\[erq\]**