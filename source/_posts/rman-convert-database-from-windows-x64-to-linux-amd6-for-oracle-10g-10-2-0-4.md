---
title: 使用rman从windows x64向linux amd64平台迁移oracle 10g 10.2.0.4
tags:
  - Oracle
id: '9218'
categories:
  - - Database
date: 2020-04-29 12:05:21
---


<!-- more -->
使用rman convert database将oracle 10g 10.2.0.4 for windows x64环境下的数据库转换到oracle 10g 10.2.0.4 for linux x64环境下。

**注意:**无法使用standby备库来进行转换。

**1、以只读方式打开数据库**

```js
SQL> shutdown immediate
SQL> startup mount
SQL> alter database open read only;
```

**2、检查可转换性和标示外部对象。**

使用DBMS_TDB.CHECK_DB检查数据库状态，是否可以顺利转换到目标平台：
```js
SQL> set serveroutput on
SQL> declare
    db_ready boolean;
  begin
    /* db_ready is ignored, but with SERVEROUTPUT set to ON any 
     * conditions preventing transport will be output to console */
    db_ready := dbms_tdb.check_db('Linux x86 64-bit', dbms_tdb.skip_none);
  end;
 /
```
DBMS_TDB.CHECK_DB返回TRUE表示可以转换到目标平台，返回FALSE则不可以，同时会输出不可已转换的原因。

使用DBMS_TDB.CHECK_EXTERNAL标识外部对象。
```js
SQL> set serveroutput on
SQL> declare
     external boolean;
  begin
    /* value of external is ignored, but with SERVEROUTPUT set to ON
     * dbms_tdb.check_external displays report of external objects
     * on console */
    external := dbms_tdb.check_external;
  end;
 /
```
如果有外部对象会在输出中显示出来。

**3、转换数据库**

可以在源数据库，也可以在目标数据库进行数据文件的转换。这里选择在目标数据库进行数据文件转换，这样可以减少源数据库的停止服务时间。

在源数据库执行rman convert database:
```js
$ rman target sys/passwd@dbinst
RMAN> CONVERT DATABASE ON TARGET PLATFORM
 CONVERT SCRIPT 'D:\\rman\\convertscript.rman'
 TRANSPORT SCRIPT 'D:\\rman\\transportscript.sql'
 new database 'orcl'
 FORMAT 'D:\\rman\\%U';
```

命令执行完成会生成一个transport脚本用于在目标平台上创建数据库，一个pfile文件包含源数据库相同的参数配置，还生成一个convert脚本用于在目标平台上转换数据文件。

**注意：**在windows平台上只能使用windows系统路径名，包括FORMAT参数使用的路径，在linux平台上做数据库转换时，根据linux平台上oracle数据库的目录结构布局来相应修改生成的convertscript.rman，pfile和transportscript.sql。

**3.1 convertscript.rman**
生成的转换脚本类似如下： 
```js
RUN {

 CONVERT DATAFILE 'E:\\ORACLE\\PRODUCT\\10.2.0\\DB_1\\DATABASE\\DIGITALSCANDATA.DAT' 
 FROM PLATFORM 'Microsoft Windows x86 64-bit' 
 FORMAT 'D:\\RMAN\\DATA_D-ORCL_I-1276927241_TS-DIGITALSCANDATA_FNO-38_HDV216EA';


 CONVERT DATAFILE 'E:\\ORACLE\\PRODUCT\\10.2.0\\DB_1\\DATABASE\\DIGITALSCANDATA01.DAT' 
 FROM PLATFORM 'Microsoft Windows x86 64-bit' 
 FORMAT 'D:\\RMAN\\DATA_D-ORCL_I-1276927241_TS-DIGITALSCANDATA_FNO-39_HEV216EA';
...
```

根据目标平台文件系统布局，修改为：
```js
RUN {

 CONVERT DATAFILE '/mnt/data/database/DIGITALSCANDATA.DAT' 
 FROM PLATFORM 'Microsoft Windows x86 64-bit' 
 FORMAT '/u01/oradata/orcl/DATA_D-ORCL_I-1276927241_TS-DIGITALSCANDATA_FNO-38_HDV216EA';


 CONVERT DATAFILE '/mnt/data/database/DIGITALSCANDATA01.DAT' 
 FROM PLATFORM 'Microsoft Windows x86 64-bit' 
 FORMAT '/u01/oradata/orcl/DATA_D-ORCL_I-1276927241_TS-DIGITALSCANDATA_FNO-39_HEV216EA';
...
```
/mnt/data/database目录下为从源库直接拷贝过来待转换的数据文件，转换完成的数据文件存储到/u01/oradata/orcl/目录下。

**3.2 pfile**
生成的INIT文件:
```js
# Please change the values of the following parameters:

 control_files = "D:\\RMAN\\CF_D-ORCL_ID-1276927241_00V216EA"

 db_recovery_file_dest = "D:\\RMAN\\flash_recovery_area"

 db_recovery_file_dest_size= 2147483648

 audit_file_dest = "D:\\RMAN\\ADUMP"
...
```
相应修改为：
```js
# Please change the values of the following parameters:

 control_files = "/u01/oradata/orcl/CF_D-ORCL_ID-1276927241_00V216EA"

 db_recovery_file_dest = "/u01/app/oracle/flash_recovery_area"

 db_recovery_file_dest_size= 2147483648

 audit_file_dest = "/u01/app/oracle/admin/orcl/adump"
...
```
**3.3 transportscript.sql**
生成的建库脚本：
```js
-- The following commands will create a new control file and use it
-- to open the database.
-- Data used by Recovery Manager will be lost.
-- The contents of online logs will be lost and all backups will
-- be invalidated. Use this only if online logs are damaged.

-- After mounting the created controlfile, the following SQL
-- statement will place the database in the appropriate
-- protection mode:
-- ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE

STARTUP NOMOUNT PFILE='D:\\RMAN\\INIT_00V216EA_1_0.ORA'
CREATE CONTROLFILE REUSE SET DATABASE "ORCL" RESETLOGS FORCE LOGGING ARCHIVELOG
 MAXLOGFILES 16
 MAXLOGMEMBERS 3
 MAXDATAFILES 100
 MAXINSTANCES 8
 MAXLOGHISTORY 14616
LOGFILE
 GROUP 1 'D:\\RMAN\\ARCH_D-ORCL_ID-1276927241_S-517_T-1_A-1017328065_00V216EA' SIZE 50M,
 GROUP 2 'D:\\RMAN\\ARCH_D-ORCL_ID-1276927241_S-515_T-1_A-1017328065_00V216EA' SIZE 50M,
 GROUP 3 'D:\\RMAN\\ARCH_D-ORCL_ID-1276927241_S-516_T-1_A-1017328065_00V216EA' SIZE 50M
DATAFILE
 'D:\\RMAN\\DATA_D-ORCL_I-1276927241_TS-SYSTEM_FNO-1_IKV216EF',
...
```
相应修改为:
```js
STARTUP NOMOUNT PFILE='/u01/app/oracle/admin/orcl/pfile/INIT_00V216EA_1_0.ORA'
CREATE CONTROLFILE REUSE SET DATABASE "ORCL" RESETLOGS FORCE LOGGING ARCHIVELOG
 MAXLOGFILES 16
 MAXLOGMEMBERS 3
 MAXDATAFILES 100
 MAXINSTANCES 8
 MAXLOGHISTORY 14616
LOGFILE
 GROUP 1 '/u01/oradata/orcl/ARCH_D-ORCL_ID-1276927241_S-517_T-1_A-1017328065_00V216EA' SIZE 50M,
 GROUP 2 '/u01/oradata/orcl/ARCH_D-ORCL_ID-1276927241_S-515_T-1_A-1017328065_00V216EA' SIZE 50M,
 GROUP 3 '/u01/oradata/orcl/ARCH_D-ORCL_ID-1276927241_S-516_T-1_A-1017328065_00V216EA' SIZE 50M
DATAFILE
 '/u01/oradata/orcl/DATA_D-ORCL_I-1276927241_TS-SYSTEM_FNO-1_IKV216EF',
...
```
**3.4 实施转换**

首先，将源数据库的数据文件全部拷贝到目标数据库（因为只拷贝数据文件，可以从standby备库拷贝），然后根据数据文件所在的路径相应的修改convert脚本，然后使用rman执行转换脚本，转换后的数据文件存储在format指定的位置。

目标平台必须要有一个已经存在的数据库，因为rman需要连接到target数据库才能工作：
```js
$ rman target / nocatalog
RMAN> @CONVERTSCRIPT.RMAN
```

然后，根据目标平台环境修改生成的pfile文件参数
最后，执行transportscript.sql生成目标数据库。使用utlirp.sql和utlrp.sql脚本重新编译目标平台数据的PL/SQL模块。
先关闭已有的数据库，oracle实例每次只能启动一个数据库：
```js
$ sqlplus / as sysdba;
SQL> @TRANSPORTSCRIPT.SQL
```
脚本最后最自动调用utlirp.sql和utlrp.sql编译模块。

其中遇到了错误：
```js
ORA-27102: out of memory
Linux-x86_64 Error: 28: No space left on device
```
是因为内核参数kernel.shmall设置为了2097152，oracle最大只能使用2097152*4096=8GB的系统内存，而INIT文件中设置的SGA大小超过了10GB，重新设置kernel.shmall为4194304可以最大允许16GB，问题解决。

数据库的sys用户是由本地密码文件验证的，数据库转换时并没有涉及到sys用户，因此需要本地重新为sys用户新建一个密码文件：
```js
$ orapwd file=$ORACLE_HOME/dbs/orapw$ORACLE_SID password=passwd_for_sys force=y
```

至此，数据库转换完成，最后以OPEN RESETLOGS方式打开新数据库。

References:
\[1\][15 RMAN Cross-Platform Transportable Databases and Tablespaces](https://docs.oracle.com/cd/B19306_01/backup.102/b14191/dbxptrn.htm#BRADV05432)
\[2\][使用RMAN Convert Database命令实现跨平台的数据库迁移](https://blog.csdn.net/qq_34556414/article/details/80188533)