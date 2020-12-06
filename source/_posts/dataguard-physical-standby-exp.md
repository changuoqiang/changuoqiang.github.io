---
title: dataguard物理备库exp导出数据
tags:
  - Oracle
id: '8717'
categories:
  - - Database
date: 2019-09-01 12:47:02
---


<!-- more -->
物理备库是可以以只读模式打开的，然后就可以exp数据出来了，注意备库readonly模式打开时，是没有在apply日志的，所有exp出来的数据会少了主库在这段时间更新的数据。

**备库端：**

```js
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL> alter database open read only;
```

然后exp数据库:
```js
$ exp ...
```

最后备库重新开始apply日志就好了:
```js
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE USING CURRENT LOGFILE DISCONNECT FROM SESSION; 
```