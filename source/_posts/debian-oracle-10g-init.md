---
title: Debian配置Oracle 10g自启动
tags:
  - Debian
id: '1945'
categories:
  - - Database
date: 2012-01-25 10:59:21
---

linux平台下默认安装的oracle 10g数据库是没有启动而且不会随系统自动启动的。
<!-- more -->
配置oracle 10g数据库自启动的步骤如下：

**1、配置/etc/oratab 文件**

oratab文件中项的格式为
$ORACLE_SID:$ORACLE_HOME:NY
每个$ORACLE_SID只能有一个项
默认安装后,入口项的最后是N,将N修改为Y,使其可以通过dbstart工具启动

**2、配置$Oracle_HOME/bin/dbstart文件**

将dbstart文件中大约78行的ORACLE_HOME_LISTNER变量的值修改为$ORACLE_HOME所在的路径,此处为
ORACLE_HOME_LISTNER=/u01/app/oracle/product/10.2.0/db_1

**3、运行dbstart,dbshut测试数据库是否正确启动和关闭**

以oracle用户登陆,执行以下命令进行测试

$ dbstart
$ ps aux grep ora_
$ ps aux grep LISTEN
$ lsnrctl status
$ dbshut

数据库启动的日志文件为$ORACLE_HOME/startup.log,关闭的日志文件为$ORACLE_HOME/shutdown.log,监听器的日志文件$ORACLE_HOME/listener.log

**4、创建启动init脚本**

以root用户在/etc/init.d目录下创建文件oracle,其内容如下

 1 #!/bin/sh
 2 
 3 \### BEGIN INIT INFO
 4 \# Provides: oracle
 5 \# Required-Start: $local_fs
 6 \# Required-Stop: $local_fs
 7 \# Default-Start: 2 3 4 5
 8 \# Default-Stop: 0 1 6
 9 \# Short-Description:oracle database init script
10 \# Description: starts and stops oracle database and listeners
11 \### END INIT INFO
12 
13 set\-e
14 
15 ORACLE_HOME\="/u01/app/oracle/product/10.2.0/db_1"
16 ORACLE_OWNER\="oracle"
17 
18 do_start() {
19     echo"starting oracle databases..."
20     su - $ORACLE_OWNER \-c "$ORACLE_HOME/bin/dbstart $ORACLE_HOME" \>> /var/log/oracle
21     touch /var/lock/oracle
22     echo"ok"
23 }
24 
25 do_stop() {
26     echo"Stopping oracle databases..."
27     su - $ORACLE_OWNER \-c "$ORACLE_HOME/bin/dbshut $ORACLE_HOME" \>> /var/log/oracle
28     rm \-f /var/lock/oracle
29     echo"ok"
30 }
31 
32 status() {
33     if \[ \-f /var/lock/oracle \]; then
34         echo"oracle database is running."
35     else
36         echo"oracle database is not running."
37     fi
38 }
39 
40 case "$1" in
41     start)
42         do_start
43         ;;
44     stop)
45         do_stop
46         ;;
47     restart)
48         do_stop
49         do_start
50         ;;
51     reload)
52         ;;
53     force-reload)
54         ;;
55     status)
56         status
57         ;;
58     *)
59         echo"$0 {startstoprestartreloadforce-reloadstatus}"
60 esac
61 
62 exit 0

然后在各个运行级对应的启动脚本目录下创建符号连接
#update-rc.d oracle defaults

还有一点,因为init脚本是用su切换到oracle用户执行数据库启动和关闭的,所以为了设置用户资源限制,需要为/etc/pam.d/su文件增添下面的行
session required pam_limits.so

配置完毕后,oracle数据库会随系统自动启动和关闭,手工控制以debian常见的方式进行

#/etc/init.d/oracle startstopstatusrestart