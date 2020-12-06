---
title: x64安装oracle 10.2.0.4无法启动em dbconsole问题解决
tags:
  - Oracle
id: '987'
categories:
  - - Database
date: 2011-02-22 11:09:01
---

在一台windows 2003 r2 x64上安装oracle 10g 10.2.0.4，采用默认安装方式，安装进度到85%时出现错误提示窗口
<!-- more -->
[![](/images/2011/02/emdc_error.jpg "emdc_error")](/images/2011/02/emdc_error.jpg)

"由于以下错误，Enterprise Manager配置失败 - 启动Database Control时出错 有关详细资料，请参阅E:\\oracle\\product\\10.2.0\\db_1\\cfgtoollogs\\dbca\\orcl\\emConfig.log中的日志文件。您可以以后通过手动运行E:\\oracle\\product\\10.2.0\\db_1\\bin\\dmca脚本，重新使用Enterprise Manager配置此数据库。"

**日志%ORACLE_HOME%\\cfgtoollogs\\dbca\\orcl\\emConfig.log输出：**

配置: Waiting for service 'OracleDBConsoleorcl' to fully start
2011-2-22 10:37:15 oracle.sysman.emcp.util.PlatformInterface serviceCommand
配置: Initialization failure for service during start
2011-2-22 10:37:15 oracle.sysman.emcp.EMConfig perform
严重: 启动 Database Control 时出错
有关详细资料, 请参阅 E:\\oracle\\product\\10.2.0\\db_1\\cfgtoollogs\\dbca\\orcl\\emConfig.log 中的日志文件。
2011-2-22 10:37:15 oracle.sysman.emcp.EMConfig perform
配置: Stack Trace: 
oracle.sysman.emcp.exception.EMConfigException: 启动 Database Control 时出错
at oracle.sysman.emcp.EMDBPostConfig.performConfiguration(EMDBPostConfig.java:646)
at oracle.sysman.emcp.EMDBPostConfig.invoke(EMDBPostConfig.java:224)
at oracle.sysman.emcp.EMDBPostConfig.invoke(EMDBPostConfig.java:193)
at oracle.sysman.emcp.EMConfig.perform(EMConfig.java:184)
at oracle.sysman.assistants.util.em.EMConfiguration.run(EMConfiguration.java:436)
at java.lang.Thread.run(Thread.java:595)

**trace文件%ORACLE_HOME%\\<HOSTNAME>_<SID>\\sysman\\log\\emagent.trc输出：**

2011-02-22 10:29:51 Thread-3068 ERROR util.files: ERROR: nmeufis_new: failed in lfiopn on file: E:\\oracle\\product\\10.2.0\\db_1\\dbserver1_orcl\\sysman\\emd\\agntstmp.txt. error = 0 (No error)
2011-02-22 10:29:51 Thread-3068 ERROR ssl: Open wallet failed, ret = 28750
2011-02-22 10:29:51 Thread-3068 ERROR ssl: nmehlenv_openWallet failed
2011-02-22 10:29:51 Thread-3068 ERROR http: 660: Unable to initialize ssl connection with server, aborting connection attempt
2011-02-22 10:29:51 Thread-3068 ERROR pingManager: nmepm_pingReposURL: Cannot connect to https://dbserver1:1158/em/upload/: retStatus=-1

经查询，此问题是由于enterprise manager database control组件的跟CA证书授权过期造成的，其证书到期日为2010年12月31日,2011年安装此版本数据库都会出现这个问题，官方的解决方案是打Patch 8350262

**单实例数据库应用此patch的方法如下：**

1、安装或者升级数据库到10.2.0.4过程中忽略此错误继续安装，数据库的创建不受影响。
2、使用opatch把此补丁应用到oracle安装
设置ORACLE_HOME和ORACLE_SID系统环境变量，将%ORACLE_HOME%\\opatch加入PATH环境变量,将patch 8350262解压缩，打开cmd窗口，进入解压缩后目录，执行
cmd>opatch apply
完成后检查%ORACLE_HOME%\\cfgtoollogs\\opatch\\目录下生成的日志文件确认安装patch是否成功。
3、应用patch成功后，重新配置em dbconsole
cmd>emctl secure dbconsole -reset
根据提示输入管理员密码，然后会有两次确认请求，两次都是输入大写的Y
4、重新启动dbconsole
cmd>emctl start dbconsole

当然，如果不使用enterprise manager database control这个组件的话，那么可以不用理会这个错误，不打这个patch。