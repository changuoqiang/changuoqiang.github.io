---
title: Oracle 10g DataGuard手记之角色转换
tags:
  - Oracle
id: '1831'
categories:
  - - Database
date: 2012-01-01 16:41:12
---

一个DataGuard配置通常有一个primary库和几个standby库组成,通常它们的角色不会变化。
<!-- more -->
我们希望primary一直不停地提供服务直到forever,如果真的如此其实根本就不要DataGuard了。当primary库崩溃或者primary库需要维护时就需要在primary和其中一个standby库之间进行角色转换。

DataGuard支持两种角色转换switchover和failover

switchover

switchover通常由用户主动进行,角色转换不会丢失数据。switchover允许primary和其standby库中的一个进行角色转换,转换完毕后各数据库按照其新的角色继续服务于DataGuard配置。

failover

当因为各种可能的原因导致primary崩溃而且短时间内无法恢复时,就需要dataguard配置中的一个stangdby数据库转换到primary角色来顶包。如果崩溃的primary并未运行于高大保护模式时,可能会有些微的数据丢失。

**角色转换前的准备工作**

1、校验各数据库的初始化参数设置是否正确
2、确保将要成为primary的standby库处于archivelog模式
3、确保standby库的临时文件存在,并与primary库的临时文件匹配。当failover时,primary已经崩溃了,谁知道这鸟临时文件还一致不一致呢，以下语句可以查询临时文件
SQL>select name from v$tempfile;
4、解决将要转换为primary的standby库任何可能尚未应用的redo logs,当然有时候数据丢失也是无法避免的
5、确保将要转换为primary的RAC standby只有一个instance是打开的,也就是在一个RAC standby向primary转换过程中,只有RAC的一个instance可以打开，角色转换完成后再启动RAC的其他instance

**物理standby的switchover**

确保primary处于open状态,物理standby处于mount状态,如果standby处于read-only模式,switchover仍然可以进行,但会花费更多的时间。一个switchover必须从当前primary库发起从目标物理standby库结束

switchover步骤如下：

1、检查当前primary是否可以执行switchover
\[sql\]
SQL> select switchover_status from v$database;
SWITCHOVER_STATUS
--------------------
TO STANDBY
\[/sql\]
switchover_status的值为TO STANDBY说明primary可以转换为standby。switchover_status的值为SESSIONS ACTIVE,那是因为有活动的SQL会话会阻止switchover,当前sqlplus会话不包括在内,最好断掉这些会话后再执行swichover,当然也可以在执行switchover的SQL语句后附加语句WITH SESSION SHUTDOWN,但这样时间会比较长。switchover_status的值为空或其他值,请检查dataguard配置。

如果switchover_status的值为SESSIONS ACTIVE,可以如下解决：
1)查看有没有用户进程连接到oracle
\[sql\]
SQL> SELECT SID, PROCESS, PROGRAM FROM V$SESSION;
\[/sql\]
如果有除当前sqlplus连接之外的连接,请将这些连接从oracle断开,比如应用程序连接或其他sqlplus连接或plsqldev连接等。
2)查看有没有用户级别的oracle会话
\[sql\]
SQL>select sid,process,program from v$session where type='USER' and sid <> (select distinct sid from v$mystat);

 SID PROCESS PROGRAM
---------- ------------ -------------------------------------
 4 3156 ORACLE.EXE (J000)
\[/sql\]
这里的这个J000是作业队列首进程,查看作业队列进程数量
\[sql\]
SQL> SHOW PARAMETER JOB_QUEUE_PROCESSES;
\[/sql\]
通过将JOB_QUEUE_PROCESSES参数设置为0来将此进程取消掉,不要修改初始化参数文件,如下操作即可：
\[sql\]
SQL>alter system set job_queue_processes=0;
\[/sql\]
稍过一会儿再查询就会发现J000进程已经消失了。
最后重新查询switchover_status应该为TO STANDBY了。

2、当前primary库执行switchover
SQL>alter database commit to switchover to physical standby;
或者
SQL>alter database commit to switchover to physical standby with session shutdown;
此后原primary转换为物理standby数据库,并将转换前的控制文件备份到trace文件。

3、关闭并重启原primary(新standby库)到mount
SQL>shutdown immediate
SQL>startup mount
在此时点上所有的数据库都被配置为standby

4、检查原standby库是否支持switchover
当原primary转换为standby后,原standby库会接收到switchover通知并做相应处理,检查其switchover_status的值来确认其是否处理该通知并准备妥当进行角色转换
SQL>selct switchover_status from v$database;
SWITCHOVER_STATUS
--------------------
TO PRIMARY

switchover_status的值为TO PRIMARY说明原standby可以转换为primary。如果switchover_status的值为SESSIONS ACTIVE,那是因为有活动的SQL会话会阻止switchover,sqlplus会话也算,此时可在执行switchover的SQL语句后附加语句WITH SESSION SHUTDOWN。switchover_status的值为空或其他值,请检查dataguard配置。

5、切换原standby库为新的primary库
SQL>alter database commit to switchover to primary;
或者
SQL>alter database commit to switchover to primary with session shutdown;

6、打开新的primary数据库
如果原standby数据库没有以read-only模式打开,执行
SQL>alter database open;
如果原standby以read-only模式打开,则执行
SQL>shutdown immediate
SQL>startup

7、如果有必要,在standby数据库上重新启动日志应用服务(log apply service)
对于新的standby数据库或者dataguard配置中的其他standby数据库,如果先前并没有配置log apply service在switchover后继续执行,那么应该执行以下语句重新启动日志应用服务

SQL>alter database recover managed standby database disconnect from session;
或者
SQL>ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;

8、校验switchover是否成功
在新主库执行
SQL>alter system switch logfile;
然后查看primary和所有stangby库上的归档日志的最大sequence#是否一致,如一致说明switchover成功。

**物理standby的failover**

failover之后,原primary不再是dataguard配置的一部分。大多数情况下，dataguard配置中的其他的standby数据库并不直接参与failover,不需要做任何更改就可以继续接收并应用新primary发送来的归档日志，当然新的primary必须定义了针对其他原有standby数据库的归档目标(LOG_ARCHIVE_DEST_*),原有standby可能需要简单的调整fal_server参数为新的primary即可。但在某些极端情况下,配置好新的primary数据库后需要重建其他所有的standby数据库

failover完成后,数据库会进行一次resetlogs,产生一个新的incarnation，归档日志编号会从1开始重新编号。10g版本中引入了跨RESETLOGS恢复的特性，原理是将RESETLOGS的操作也记录到REDOLOG中，这样日志恢复会前后衔接起来。这是一个很好的特性。

如果待转换为primary的standby数据库运行于最大保护模式(最大可用模式不知道有没有影响？),那么首先需要在standby上用一下语句将其置于最大性能模式

SQL>ALTER DATABASE SET STANDBY DATABASE TO MAXIMIZE PERFORMANCE;
等standby切换为新的primary后,可以再更改成任何想要的其他保护模式。

oracle不允许failover到一个运行于最大保护模式的standby。此外如果一个运行于最大保护模式的primary仍然与standby保持通讯,那么将standby从最大保护模式切换到最大性能模式的alter database语句会失败。因为failover会将primary从dataguard配置中移除,这一特性可以保护运行于最大保护模式的primary免受无意的failover影响。

如果待转换角色的standby数据库运行于最高保护或最高可用模式并使用LGWR归档进程的话,其归档日志应该是连续的,不存在任何间隙,因此可以从以下的第三步直接执行,否则请从以下的第一步开始执行

1、解决任何的归档日志间隙(gap)

如果有缺失的归档日志会造成日志间隙,所有的日志间隙记录在v$archive_gap视图中

查询日志间隙
SQL>SELECT THREAD#, LOW_SEQUENCE#, HIGH_SEQUENCE# FROM V$ARCHIVE_GAP;

如果有记录返回,将日志号从LOW_SEQUENCE#到HIGH_SEQUENCE#的所有归档日志拷贝到standby并将它们注册到standby数据库

SQL>ALTER DATABASE REGISTER PHYSICAL LOGFILE '\\path\\to\\gap_logs';

因为每次查询v$archive_gap视图时只返回顺序号最高的日志间隙,因此必须重复查询日志间隙、拷贝缺失的归档日志文件、注册缺失的日志文件直到查询日志间隙时没有任何记录返回。

2、拷贝任何缺失的归档日志文件到standby数据库

首先查询standby数据库上每个线程的最大归档日志号
SQL>SELECT UNIQUE THREAD# AS THREAD, MAX(SEQUENCE#) OVER (PARTITION BY thread#) AS LAST from V$ARCHIVED_LOG;

然后确定primary数据库每个线程的最大归档日志号，如果primary已经不能查询,可以查看备份的primary归档日志文件来确定最大归档日志号。如果primary的最大归档日志号大于standby库的,那么将所有多出的归档日志从primary拷贝到standby数据库并将它们注册到standby数据库

SQL>ALTER DATABASE REGISTER PHYSICAL LOGFILE '\\path\\to\\miss_logs';

3、在standby数据库上执行failover

SQL>ALTER DATABASE RECOVER MANAGED STANDBY DATABASE FINISH FORCE;

FORCE关键字终止standby数据库上的活动的RFS进程,因此failover可以立即得到处理而不必等待网络连接超时

4、将standby数据库切换为primary数据库

SQL>ALTER DATABASE COMMIT TO SWITCHOVER TO PRIMARY;

5、启动新的primary数据库

如果原standby数据库没有以read-only模式打开,执行
SQL>alter database open;
如果原standby以read-only模式打开,则执行
SQL>shutdown immediate
SQL>startup

6、备份新的primary数据库

failover之后,原primary不再是dataguard配置的一部分,而dataguard配置中的其他的stangby数据库从现在开始从新的primary数据库接收并应用redo logs。
因此在执行startup语句之前最好完整备份一下新的primary数据库

7、恢复或重建失败的原primary数据库

failover之后,失败的primary不再是dataguard配置的一部分,修复之后可以将其作为物理standby加入到dataguard配置中。

从原理上讲,standby数据库必须沿着primary的方向前进,而且在时点上必须要小于或者说晚于primary库,也就是说通过应用primary传送过来的redo数据,standby完全可以变的和primary一模一样,standby必须紧跟primary的脚步而不能分道扬镖。所以当failover后,失败的primary如何修复、重建成为物理standby要依据情况而定。

第一种情况,failover过程中没有任何的数据丢失,新primary完全恢复了失败的primary的数据,而且失败的primary库在failoiver后没有进行任何的写操作,这种情况下,修复的primary可以直接作为standby加入到dataguard配置。

第二种情况,failover过程中丢失了部分数据,也就是新primary恢复到原primary失败之前的某个时点上,如果修复好的原primary可以flashback到前面提到的那个时点或者更早,那么修复好的原primary可以转化为standby库加入到dataguard配置。详见dataguard文档"Flashing Back a Failed Primary Database into a Physical Standby Database"。

其他情况下,原primary与新的primary已经分道扬镖,无法破镜重圆,修复好的priamry要依据当前primary重新建库,从头来过配置为standby加入到dataguard配置。

**\===
\[erq\]**