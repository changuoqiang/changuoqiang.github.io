---
title: Oracle 10g DataGuard手记之基础配置
tags:
  - Oracle
id: '1713'
categories:
  - - Database
date: 2011-12-27 11:12:02
---

DataGuard为企业数据的高可用性,数据安全以及灾难恢复提供支持,一般由一个primary db与几个物理或逻辑standby db组成一个DataGuard配置。
<!-- more -->
**系统环境**

操作系统为windows server 2003 r2 enterprise x64 edition service pack 2,database为oracle 10g 10.2.0.4 enterprise x64 edition。服务器均为AMD64架构,主机RAID5本地硬盘加RAID1光纤盘阵。

primary库：
ip 10.0.0.1
$ORACLE_BASE E:\\ORACLE
$ORACLE_HOME E:\\ORACLE\\PRODUCT\\10.2.0\\DB_1
$ORACLE_SID orcl

standby库standby01：
ip 10.0.0.2
$ORACLE_BASE E:\\ORACLE
$ORACLE_HOME E:\\ORACLE\\PRODUCT\\10.2.0\\DB_1
$ORACLE_SID orcl

主库primary与(第一个)物理备库standby01的oracle版本与物理结构是完全一致的,所有oracle文件的路径在两台服务器上都是一样的。

**方案**

配置DataGuard的目标是保证业务系统数据的最高可用性,迅速从硬件故障,数据损坏或灾难中恢复数据库。物理standby性能和稳定性都优于逻辑standby,并且由于备库不需要用于查询,因此备库采用物理standby模式。

DataGuard有三种保护模式,最大性能模式,最大可用模式和最大保护模式。

*   最大保护模式可以确保没有数据丢失。这种模式要求所有的事务在提交前其redo数据不但要写入本地online redo log,还要同时提交到standby的standby redo log,并确认redo数据至少在一个standby上可用,然后才会在primary上提交该事务。当出现故障导致无standby可用时,primary会shutdown,直到至少有一个standby恢复。

*   最大性能模式是dataguard默认的数据保护模式。在这种模式下,只要redo数据写到本地online redo log中事务就可以提交。primary仍然向standby写入redo logs,但这种写入是异步的,对产生redo数据的事务没有影响。最大性能模式对系统的影响最小,但有丢失数据的风险。

*   最大可用模式是这两种模式的折衷,在正常情况下,最大可用模式和最大保护模式是一样的,同样要求事务提交前其redo数据不但要写入到本地online redo log还要至少写入到一个standby的standby redo log。但在standby出现故障不可用时，最大可用模式会自动降低成最大性能模式。当故障消除并且standby的redo log与primary完全同步后,primary会自动的恢复到最大可用模式运行。这种情况下dataguard消除redo log gaps时会使用到FAL_SERVER和FAL_CLIENT这两个参数。所以standby故障不会导致primay不可用。只要至少有一个standby可用的情况下，即使primary down掉，也能保证不丢失数据。

因为系统环境较好,可以配置多个物理standby,系统可用性要求高,并且可以容忍极少量数据丢失,因此采用最高可用模式。

**DataGuard基础配置**

**主库(primary)端配置：**
 **1、打开force logging模式**
```js
SQL> alter database force logging;
```
然后查询
```js
SQL> select force_logging from v$database;
FOR
---
YES
```
说明已经开启FORCE LOGGING模式

**2、创建密码文件**
如果密码文件不存在需要[创建密码文件](https://openwares.net/database/oracle_passwd_file.html),DataGuard配置里面的每一个数据库都必须使用密码文件,并且所有数据库的SYS用户密码必须相同,这样才能成功的传输REDO LOGS。主库安装时已经自动创建了密码文件,备库安装时也使用相同的SYS密码进行安装并自动创建密码文件,所以此时不必再重复创建密码文件。

**3、配置Standby Redo Log**

最大保护模式和最大可用模式必须使用standby redo log,并且推荐所有的数据库都使用LGRW ASYNC日志传输模式。创建standby数据库时就要计划好standby redo log的配置,并创建所有需要的日志组和组成员。为了增加可用性,可以多路standby redo log文件,就像多路online redo log文件那样。多路时每个日志组内的所有日志文件内容都是一样的,可以将它们分散到不同的驱动器上以提高可用性和IO性能。

创建standby redo log的步骤如下：

1)确保日志文件的大小与主、备库online redo log文件的大小保持一致。这样日志传输和应用都比较方便。

2)确定适当数目的standby redo log日志组
standby redo log日志组至少要比online redo log日志组多一个。然而官方推荐根据primary数据库的线程数来计算standby redo log日志组的数量,参考公式如下

(每线程的日志组数+1)*线程数

这样可以降低primary库LGRW进程被阻塞的可能性。
比如,primary有两个线程,每个线程有两个日志组,那么推荐配置6个standby redo log日志组。
单实例数据库只有一个线程,所以配置比默认的3组online redo log多一组即4组standby redo log即可。 

3)创建standby redo log日志组

正常情况下standby redo log日志组仅需要在Standby库进行配置，考虑到主备切换，在primary端亦进行配置
先查询一下online redo log日志文件的大小
```js
SQL> select group#,thread#,archived,status,bytes/1024/1024 from v$log;
GROUP# THREAD# ARC STATUS BYTES/1024/1024
------ ---------- --- ---------------- ---------------
 1 1 YES INACTIVE 50
 2 1 NO CURRENT 50
 3 1 YES INACTIVE 50
```
online redo log日志文件的大小为50M,组号为1-3,所以standby redo log日志组的组号为4-7,下面创建standby redo log日志组
```js
SQL> alter database add standby logfile group 4 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO01.LOG') size 50M;
Database altered.
SQL> alter database add standby logfile group 5 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO02.LOG') size 50M;
Database altered.
SQL> alter database add standby logfile group 6 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO03.LOG') size 50M;
Database altered.
SQL> alter database add standby logfile group 7 ('E:\\ORACLE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\STDBYREDO04.LOG') size 50M;
Database altered.
```
验证standby redo log日志组是否创建成功
```js
SQL> SELECT GROUP#,THREAD#,SEQUENCE#,ARCHIVED,STATUS FROM V$STANDBY_LOG
 GROUP# SEQUENCE# ARC STATUS
---------- ---------- --- ----------
 4 0 YES UNASSIGNED
 5 0 YES UNASSIGNED
 6 0 YES UNASSIGNED
 7 0 YES UNASSIGNED
```
**4、设置oracle net service names**

在主库primary的$ORACLE_HOME/NETWORK/ADMIN/tnsname.ora文件中添加如下oracle net service name,primary标识主库和standby01标识(第一个)物理备库
```js
primary =
 (DESCRIPTION =
 (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.0.1)(PORT = 1521))
 (CONNECT_DATA =
 (SERVER = DEDICATED)
 (SERVICE_NAME = orcl)
 )
 )

standby01 =
 (DESCRIPTION =
 (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.0.2)(PORT = 1521))
 (CONNECT_DATA =
 (SERVER = DEDICATED)
 (SERVICE_NAME = orcl)
 )
 )
```
**5、设置primary初始化参数**
对于primary数据库,作为primary脚色需要定义几个初始化参数控制redo传输服务。还有几个附加的初始化参数需要定义以控制redo数据的接收和日志应用服务,当primary库转换到standby角色时会使用这些参数,方便主备库角色转换。

[DataGuard相关的初始化参数](https://openwares.net/database/dataguard_init_paras.html)详细解释见[这里](https://openwares.net/database/dataguard_init_paras.html)

因为需要修改的初始化参数较多,先从spfile导出pfile,然后用编辑pfile,最后再用pfile重建spfile
```js
SQL> create pfile from spfile;
```
会在$ORACLE_HOME/database/目录下生成INITorcl.ora

下面是primary库需要修改或添加的初始化参数：
```js
DB_NAME='orcl'
DB_UNIQUE_NAME='primary'
LOG_ARCHIVE_CONFIG='DG_CONFIG=(primary,standby01)'
LOG_ARCHIVE_DEST_1='LOCATION=D:\\archived_log\\ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=primary'
LOG_ARCHIVE_DEST_2='SERVICE=standby01 LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=standby01'
LOG_ARCHIVE_DEST_STATE_1=enable
LOG_ARCHIVE_DEST_STATE_2=enable
```
**注**：因为LOG_ARCHIVE_DEST_n与LOG_ARCHIVE_DEST(LOG_ARCHIVE_DUPLEX_DEST)参数不兼容,因此需要把LOG_ARCHIVE_DEST(LOG_ARCHIVE_DUPLEX_DEST)参数reset为空,归档日志路径问题详见[oracle 10g重做日志归档路径参数](https://openwares.net/2011/10/31/oracle_10g_archive_destination/)。

**注**：LOG_ARCHIVE_DEST_1指定的本地归档目录必须在参数生效前已经存在,不然启动数据库时会报如下错误:
```js
ORA-16032: parameter LOG_ARCHIVE_DEST_1 destination string cannot be translated
ORA-09291: sksachk: invalid device specified for archive destination
OSD-04018: Unable to access the specified directory or device.
O/S-Error: (OS 2) XXXXXXXXXXXXXXXXXXXX
```
下面是standby脚色需要的初始化参数,为primary设置这些参数以方便在primary与standby脚色之间转换
```js
FAL_SERVER=standby01
FAL_CLIENT=primary
STANDBY_FILE_MANAGEMENT=auto
```
修改完毕后用pfile创建spfile
```js
SQL> shutdown immediate
SQL> create spfile from pfile='INITorcl.ora'
SQL> startup
```
**6、确保primary处于归档模式**
```js
SQL> archive log list
Database log mode Archive Mode
Automatic archival Enabled
```
如果并未打开归档模式,执行以下命令将数据库置于归档模式
```js
SQL> shutdown immediate;
SQL> startup mount;
SQL> alter database archivelog;
SQL> alter database open;
```
**7、为物理备库生成control文件**
```js
SQL> alter database create standby controlfile as '\\path\\to\\control_file';
```
**物理备库(standby01)端配置**

**1、创建备库**
有多种方式创建物理备库,使用冷备份或RMAN或其他方法,oracle推荐使用RMAN。因为primary与standby01结构完全一致,而且primary有停库的机会,所以采用最简单的冷备份来创建物理备库standby01,方法如下：

需要拷贝的有密码文件,standby控制文件,数据文件,联机日志文件,初始化参数文件。初始化参数文件拷贝主库上生成并修改好的pfile INITorcl.ora,然后根据物理备库的实际情况做相应修改后生成spfile即可。

首先查询数据库,找到这些文件所在的位置
```js
SQL> select name from v$datafile; //数据文件
SQL> select member from v$logfile; //在线日志文件
SQL> SELECT NAME FROM V$CONTROLFILE; //控制文件
SQL> show parameter log_archive_dest; //归档日志文件
```
online redo log,standby redo log所在路径为
$ORACLE_BASE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\
密码文件PWDorcl.ora,初始化参数文件INITorcl.ora,普通用户数据文件所在路径为
$ORACLE_HOME\\database\\
系统用户数据文件所在路径为
$ORACLE_BASE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\
归档日志文件所在的路径为
D:\\ARCHIVED_LOG

对于控制文件稍微有些不同,standby库不能直接使用primary库的控制文件,不然standby会报"ORA-01665: control file is not a standby control file"错误,需要从primary库为standby生成控制文件,在primary库端执行命令
```js
SQL> alter database create standby controlfile as 'd:\\control01.ctl';
```
然后分别关闭primary和standby01
```js
SQL> shutdown immediate
```
将上述文件拷贝到standby01库相应的目录下,因为两边库结构完全一致,所以直接从primary拷贝$ORACLE_BASE\\PRODUCT\\10.2.0\\ORADATA\\ORCL和$ORACLE_HOME\\database\\这两个目录覆盖到standby对应目录下即可。

最后将生成的控制文件拷贝到standby01库初始化参数contro_files设置的路径,这里使用的是默认值,也就是standby01库的$ORACLE_BASE\\PRODUCT\\10.2.0\\ORADATA\\ORCL\\目录下。注意控制文件是有冗余的,拷贝control01.ctl为control02.ctl和control03.ctl,分别覆盖standby01原来的三个控制文件,这三个控制文件是完全一样的。为了安全可靠,也可以修改初始化参数control_files,将三个控制文件放到不同的驱动器上面。关于控制文件见[oracle 10g 控制文件冗余](https://openwares.net/database/oracle_10g_control_files.html)。

**2、设置oracle net service names**

在备库standby01的$ORACLE_HOME/NETWORK/ADMIN/tnsname.ora文件中添加如下oracle net service name,primary标识主库和standby01标识(第一个)物理备库
```js
primary =
 (DESCRIPTION =
 (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.0.1)(PORT = 1521))
 (CONNECT_DATA =
 (SERVER = DEDICATED)
 (SERVICE_NAME = orcl)
 )
 )

standby01 =
 (DESCRIPTION =
 (ADDRESS = (PROTOCOL = TCP)(HOST = 10.0.0.2)(PORT = 1521))
 (CONNECT_DATA =
 (SERVER = DEDICATED)
 (SERVICE_NAME = orcl)
 )
 )
```
**3、设置standby01初始化参数**

直接根据stanby角色修改从primary库拷贝过来的INITorcl.ora,下面是standby01库需要修改或添加的初始化参数：
```js
DB_NAME='orcl'
DB_UNIQUE_NAME='standby01'
LOG_ARCHIVE_CONFIG='DG_CONFIG=(primary,standby01)'
LOG_ARCHIVE_DEST_1='LOCATION=D:\\archived_log\\ VALID_FOR=(ALL_LOGFILES,ALL_ROLES) DB_UNIQUE_NAME=standby01'
LOG_ARCHIVE_DEST_STATE_1=enable
FAL_SERVER=primary
FAL_CLIENT=standby01
STANDBY_FILE_MANAGEMENT=auto
```
下列参数用于standby01从备库到主库角色转换
```js
LOG_ARCHIVE_DEST_2='SERVICE=primary LGWR ASYNC VALID_FOR=(ONLINE_LOGFILES,PRIMARY_ROLE) DB_UNIQUE_NAME=primary'
LOG_ARCHIVE_DEST_STATE_2=enable
```
修改完毕后用pfile创建spfile
```js
SQL> create spfile from pfile='INITorcl.ora';
```

**4、启动物理备库standby并开启redo应用**
```js
SQL> startup mount
SQL> alter database recover managed standby database disconnect from session;
```
使用下面语句停止redo应用
```js
SQL> alter database recover managed standby database cancel;
```
**5、检查物理备库standby01是否正确同步**

在primary库上手工强制归档并查询归档日志
```js
SQL> alter system switch logfile;
SQL> select max(sequence#) from v$archived_log;
MAX(SEQUENCE#)
--------------
 486
```
在standby01上查询归档日志
```js
SQL> select max(sequence#) from v$archived_log;
MAX(SEQUENCE#)
--------------
 486
```

如果从primary上做如下查询,能看到如下的记录
```js
SQL> select name,sequence# from v$archived_log order by sequence#;
NAME SEQUENCE#
------------ -------------
standby01 486
D:\\ARCHIVED_LOG\\ARC00486_0765555401.001 486
```
同一个归档文件分别写到了本地归档路径和standby01备库。

这说明dataguard数据同步是正确的。

**6、开启实时redo应用**

上面第4步的redo应用并不是实时的,只有当主库的online redo归档并触发备库的standby redo归档后才将归档日志的数据应用到备库,这样就会有较大的延迟,造成一段时间内主备库差异较大。
dataguard提供了实时应用redo日志的方法,如果开启了日志实时应用,日志应用服务会将从primary接收到的redo数据立即应用到standby库,而不会等到当前的standby redo log日志归档后再应用redo数据。实时日志应用必须要在standby库配置standby redo log文件。

开启redo实时应用
```js
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
```
默认dataguard运行于最大性能模式,如何升级到其他模式另文再叙。

P.S.:创建更多的物理standby备库并没有什么特别的,只要在primary的pfile中增加更多的网络归档路径,比如LOG_ARCHIVE_DEST_3、LOG_ARCHIVE_DEST_4等,当然对应的LOG_ARCHIVE_DEST_STATE_3、LOG_ARCHIVE_DEST_STATE_4也要设置为enable,还有参数LOG_ARCHIVE_CONFIG='DG_CONFIG=(primary,standby01,standby02,...)',再就是适当的设置FAL_SERVER和FAL_CLIENT就可以了。

**\===
\[erq\]**