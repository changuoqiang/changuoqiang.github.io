---
title: oracle文件hc_SID.dat与oradba.exe
tags:
  - Oracle
id: '1795'
categories:
  - - Database
date: 2011-12-31 09:59:20
---

hc_<ORACLE_SID>.dat文件用于实例的健康检查,oradba.exe用于windows平台创建ORA_DBA用户组
<!-- more -->
UNIX/LINUX平台上两文件所在路径为$ORACLE_HOME/dbs/,windows平台两文件所在路径为$ORACLE_HOME/database/

hc_<ORACLE_SID>.dat为实例的健康检查监视而创建,它包含了用于监视实例健康状态的信息,当实例关闭时可以用该文件确定实例因为什么原因而关闭。每次实例启动时重建该文件。如果用一个空白文件替换该文件,会得到ORA-7445错误。

oradba.exe用于windows平台创建ORA_DBA用户组,并将DBA用户加入ORA_DBA用户组。