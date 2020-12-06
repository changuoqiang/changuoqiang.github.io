---
title: datagurad环境下修改sys用户密码
tags:
  - Oracle
id: '6087'
categories:
  - - Database
date: 2014-12-22 09:35:11
---


<!-- more -->
dataguard环境下使用alter user sys identified by 语句修改主库的sys用户密码时,不会自动更新备库的密码文件。而Oracle Dataguard环境的日志传输安全机制依赖于密码文件，因为备库也需要做相应的修改才可以正常的进行日志恢复。而备库随时有可能成为主库，因此修改密码后应该将主库的密码文件同步到备库。

首先，停止备库
```js
SQL> shutdown immediate
```

然后，将主库密码文件覆盖备库的密码文件
最后，启动备库，打开日志实时恢复
```js
SQL> startup mount
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION;
```

**\===
\[erq\]**