---
title: linux基于cron的rman自动增量备份脚本及设置
tags:
  - Debian
  - Oracle
id: '1997'
categories:
  - - Database
date: 2012-03-22 10:15:51
---

rman及catalog运行于linux,target数据库运行于windows,oracle版本一致,而且都是64位平台。
<!-- more -->
历史原因数据库运行于windows,但显然linux更适合于系统管理,因此此处rman暂时运行于混合环境。

**备份策略**

数据库用于OLTP系统,容量中等,全库接近400G,但有大约200G的数据是不变化只用于查询的,将其表空间置于read only模式,备份时可以忽略这些数据。其他200G左右的数据每天都在发生变化,如果系统需要回复,要尽可能的恢复到最新的数据。已经做了[dataguard灾备](https://openwares.net/database/oracle_10g_windows_x64_dataguard.html)。

基于以上情况制定备份策略，每周日凌晨做0级备份，周一到周六做1级备份。

target数据库要打开[块变化追踪机制](https://openwares.net/database/oracle_10g_incremental_backup.html),然后[建立恢复目录](https://openwares.net/database/rman_catalog_database.html)。

**备份脚本**

 1 #!/bin/bash  
 2   
 3 **set** \-e  
 4   
 5 #############################################################  
 6 \# sunday incremental level 0  
 7 \# other day incremental level 1  
 8 #  
 9 \# rman and catalog on oracle 10.2.0.4 64bits for debian amd64  
10 \# target on oracle 10.2.0.4 64bits for windows 2003 r2 sp2 x64   
11 #############################################################  
12   
13 **export** ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1  
14 rman_bin\=$ORACLE_HOME/bin/rman  
15   
16 weekday\=\`date +%a\`  
17 **case** **"**${weekday}**"** **in**  
18   
19     **"**Sun**"****)**  
20         inc_level\=0  
21         **;;**  
22     ***)**  
23         inc_level\=1  
24         **;;**  
25 **esac**  
26   
27 rman_user\=rman_usr  
28 rman_passwd\=rman_usr  
29 catalog_inst_name\=catalogd  
30   
31 target_sys_passwd\=oracle  
32 target_inst_name\=db_test  
33   
34 log_file\=/var/log/rman/\`date +%F\`_${inc_level}.log  
35 bak_file\=**'**d:\\rman_bak\\bak_%U**'**  
36 arc_file\=**'**d:\\rman_bak\\arc_%U**'**  
37 ctl_file\=**'**d:\\rman_bak\\ctl_%F**'**  
38   
39 $rman_bin log ${log_file} **\>>** /dev/null 2**\>&1** **<<EOF**  
40   
41 connect catalog ${rman_user}/${rman_passwd}@${catalog_inst_name};  
42 connect target sys/${target_sys_passwd}@${target_inst_name};  
43   
44 run {  
45  configure backup optimization on;  
46  configure archivelog deletion policy to applied on standby;  
47  configure retention policy to redundancy 3;  
48  configure controlfile autobackup on;  
49  configure controlfile autobackup format for device type disk to '${ctl_file}';  
50   
51  allocate channel ch1 device type disk;  
52  backup incremental level ${inc_level} cumulative database format '${bak_file}' skip readonly plus archivelog format '${arc_file}';  
53   
54  release channel ch1;  
55 }  
56   
57 crosscheck backup;  
58 delete noprompt obsolete;  
59   
60 delete noprompt archivelog all completed before 'sysdate - 14';  
61   
62 exit;  
63 **EOF**  
64   
65 **exit** 0 

rman操作日志记录于/var/log/rman目录下,需要在/var/log目录先新建rman子目录,不然rman会报错无法打开log文件。脚本很简单,就不解释了。

**自动运行**

打开/etc/crontab,编辑cron.daily所在的那行，将其第一个字段m(minute)改为0或其他小于60的数值,第二个字段h(hour)改为0,这样以来cron守护程序每天的0点稍后自动运行/etc/cron.daily目录下的脚本。然后将备份脚本拷贝到/etc/cron.daily目录下,注意为备份脚本添加可执行权限。

**特别注意：crond或者直接说run-parts不会执行带有.sh扩展名的脚本,也就说/etc/cron.*/目录下的脚本不要带任何扩展名。**