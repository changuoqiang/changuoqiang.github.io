---
title: DataGuard相关的初始化参数
tags: []
id: '1653'
categories:
  - - Database
date: 2011-11-06 10:56:27
---

dataguard环境下适用于primary和/或standby的初始化参数介绍
<!-- more -->
**ARCHIVE_LAG_TARGET**

适用: primary
格式: ARCHIVE_LAG_TARGET = _seconds_
描述: 可选。按设定时间间隔seconds强制日志切换,单位秒。可减少日志丢失。
样例: ARCHIVE_LAG_TARGET = 1800

**COMPATIBLE**

适用: primary,physical standby,logical standby
格式: COMPATIBLE = _release_number_
描述: 控制数据库兼容性。DataGuard需要的最小值为9.2.0.1,将此参数设置为10.2.0.0以上可以利用10g 新特性。primary和standby需要设置同样的参数。
样例： COMPATIBLE = '10.2.0.0'

**CONTROL_FILE_RECORD_KEEP_TIME**

适用： primary,physical standby,logical standby
格式： CONTROL_FILE_RECORD_KEEP_TIME = _number_of_days_
描述： 可选。在指定的天数内不可以覆盖控制文件中的可重用记录。这个参数的范围为0-365天,如果这个参数设置为0,系统会在需要的时候覆盖可重用的记录。
样例： CONTROL_FILE_RECORD_KEEP_TIME = 20

**CONTROL_FILES**

适用： primary,physical standby,logical standby
格式： CONTROL_FILES = _('control_file_name','control_file_name2',...)_
描述： 指定控制文件的名字,包括完整的路径。
样例： CONTROL_FILES = ('/u01/oracle/oradata/control01.ctl', 
'/u01/oracle/oradata/control02.ctl")

**DB_FILE_NAME_CONVERT**

适用： physical standby
格式： DB_FILE_NAME_CONVERT = _('location_of_primary_database_datafile','location_of_standby_database_datafile',...)_
描述： 如果standby与primary在同一个系统上,或者standby的数据文件位置与primary的数据文件位置不同,必须设置此参数。这个参数必须指定成对的字符串,第一个字符串指定primary的数据文件位置,第二个字符串指定standby对应的数据文件位置,可以设置多对参数。
样例： 从primary的/dbs/t1/,转换到standby的/dbs/t1/standby
DB_FILE_NAME_CONVERT = ('/dbs/t1/','/dbs/t1/standby')

**DB_NAME**

适用： primary,physical standby,logical standby
格式： DB_NAME = _database_name_
描述： 指定最多8个字符的数据库名。对于physical standby,把DB_NAME设置成与primary数据库初始化参数文件中相同的名字,也就是此参数physical standby与primary保持一致。但是对于logical standby,此参数不能与primary设置相同,可用DBNEWID(nid)为logical standby设置DB_NAME。
样例： DB_NAME = orcl

**DB_UNIQUE_NAME**

适用： primary,physical standby,logical standby
格式： DB_UNIQUE_NAME = _unique_service_provider_name_for_this_database_
描述： 为本数据库指定一个独一无二的名字,primary和standby中此参数不能相同,此参数一般设置为oracle service name。
样例： DB_UNIQUE_NAME = primaryDB

**FAL_CLIENT与FAL_SERVER**参数详见"[FAL_CLIENT和FAL_SERVER参数详解](https://openwares.net/database/fal_client_fal_server.html)"

**LOG_ARCHIVE_CONFIG**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_CONFIG = _'DG_CONFIG(db_unique_name,db_unique_name,...)'_
描述： 使用DG_CONFIG属性标识出Data Guard配置中的primary数据库和各个standby数据库的DB_UNIQUE_NAME。此参数使primary发送redo日志到standby数据库,使standby数据库接收primary发送来的redo日志。
样例： LOG_ARCHIVE_CONFIG ='DG_CONFIG(PrimaryDB,StandbyDB1,StandbyDB2,...)'

**LOG_ARCHIVE_DEST_n**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_DEST_n = 'LOCATION=path_name SERVICE=service_name, attribute,attribute'
描述： 必需。定义最多10个归档日志目的地。LOCATION用来指定本地归档日志路径,SERVICE用来指定远程归档目的地。
样例： LOG_ARCHIVE_DEST_1 = 'SERVICE=StandbyDB OPTIONAL REOPEN=180'

**LOG_ARCHIVE_DEST_STATE_n**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_DEST_STATE_n = ENABLE DEFER ALTERNATE
描述： 用来指定由参数LOG_ARCHIVE_DEST_n定义的目的地的状态,每一个LOG_ARCHIVE_DEST_n参数都必须顶一个对应的LOG_ARCHIVE_DEST_STATE_n参数。
ENABLE - 指定该归档目的地可用
DEFER - 归档目的地不可用
ALTERNATE - 指定目的地不可用，但当其他目的地都失败时，这个目的地变为可用。
样例： LOG_ARCHIVE_DEST_STATE_1 = ENABLE

**LOG_ARCHIVE_FORMAT**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_FORMAT = log%d_%t_%s_%r.arc
描述： 如果指定了STANDBY_ARCHIVE_DEST参数,则需要指定此参数,此参数指定了归档redo日志文件名的格式。这个参数与STANDBY_ARCHIVE_DEST组合在一起形成standby数据库端完整的归档日志文件名。%d为database ID，%t为归档线程的thread id,%s为归档序列号。
样例： LOG_ARCHIVE_FORMAT = 'log%d_%t_%s.arc'

**LOG_ARCHIVE_MAX_PROCESSES**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_MAX_PROCESSES = integer
描述： 指定数据库服务器调用的背景归档日志进程的数目，可设置值为1-30,缺省值是4。
样例： LOG_ARCHIVE_MAX_PROCESSES = 2

**LOG_ARCHIVE_MIN_SUCCEED_DEST**

适用： primary
格式： LOG_ARCHIVE_MIN_SUCCEED_DEST = integer
描述： 指定primary日志写进程在重新利用在线redo log文件之前必须成功接收redo log文件的目的地(LOG_ARCHIVE_DEST_n)的最小数目
样例： LOG_ARCHIVE_MIN_SUCCEED_DEST = 2

**LOG_ARCHIVE_TRACE**

适用： primary,physical standby,logical standby
格式： LOG_ARCHIVE_TRACE = integer
描述： 设置该参数来追踪redo log向standby数据库的传送,有效的参数值为0,1,2,4,8,16,32,64,128,256,512,1024,2048
样例： LOG_ARCHIVE_TRACE = 1

**LOG_FILE_NAME_CONVERT**

适用： physical standby
格式： LOG_FILE_NAME_CONVERT = ('location_of_primary_redo_logs','location_of_standby_redo_logs',...)
描述： 当standby与primary在同一个系统中,或者standby与primary的redo logs位置不同，这个参数用于在primary和standby之间转换red logs文件的路径。
样例： LOG_FILE_NAME_CONVERT = ('/dbs/t1/','/dbs/t1/stdby','dbs/t2/ ','dbs/t2/stdby')

**STANDBY_ARCHIVE_DEST**

适用： physical standby,logical standby
格式： STANDBY_ARCHIVE_DEST = path_to_received_redo_logs_of_standby
描述： 指定standby从primary接收的归档日志存放路径。此参数覆盖LOG_ARCHIVE_DEST_n参数设置的目录位置，STANDBY_ARCHIVE_DEST与LOG_ARCHIVE_FORMAT组合在一起形成standby端redo logs的文件名。
样例： STANDBY_ARCHIVE_DEST = '/u01/oracle/oradata/archive'

**STANDBY_FILE_MANAGEMENT**

适用： primary,physical standby
格式： STANDBY_FILE_MANAGEMENT = AUTO MANUAL
描述： 当此参数设置为AUTO，当primary增加或删除数据文件时，standby自动执行与primary相同的动作，如果设置为MANUAL则需要DBA在standby手动处理数据文件的变动。推荐设置为AUTO。
样例： STANDBY_FILE_MANAGEMENT = AUTO

**USER_DUMP_DEST**

适用： primary,physical standby,logical standby
格式： USER_DUMP_DEST = path_name_of_trace_files
描述： 指定服务器写debug trace文件的路径名
样例： USER_DUMP_DEST = '/u01/oracle/oradata/utrc'

**\===
\[erq\]**