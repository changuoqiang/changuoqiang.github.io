---
title: Oracle 10g重新配置Enterprise Manager
tags:
  - Oracle
id: '1383'
categories:
  - - Database
date: 2011-04-25 12:13:20
---

在一台新服务器上安装oracle 10g 10.2.0.4,操作系统平台为windows 2003 R2 x64,
<!-- more -->
安装进度到85%时出现错误提示

"由于以下错误,Enterprise Manager配置失败 - 用户名/口令无效。\[ORA-01012: not logged on\] 有关详细资料，请参阅E:\\oracle\\product\\10.2.0\\db_1\\cfgtoollogs\\dbca\\orcl\\emConfig.log中的日志文件。您可以以后通过手动运行E:\\oracle\\product\\10.2.0\\db_1\\bin\\dmca脚本，重新使用Enterprise Manager配置此数据库。"

这应该也是因为CA证书过期的问题导致em无法配置,但与以前出现的错误却不同。先参考[x64安装oracle 10.2.0.4无法启动em dbconsole问题解决](https://openwares.net/database/x64_oracle_10g_emdbconsole_error.html)打上Patch 8350262

**重新配置em**

设置好环境变量ORACLE_HOME和ORACLE_SID,然后cmd命令行执行以下命令删除掉原来的Database Control repository

>emca -deconfig dbcontrol db -repos drop

根据提示输入sid,端口号1521,口令,最后输入Y确认
然后输入以下命令重新建立Database Control repository

>emca -config dbcontrol db -repos create

重建完成后重新启动一下服务ORacleDBConsole或重新启动机器
浏览器输入https://localhost:1158/em访问Enterprise Manager即可