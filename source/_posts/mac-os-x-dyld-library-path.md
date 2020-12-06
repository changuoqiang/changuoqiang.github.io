---
title: Mac OS X 库路径环境变量DYLD_LIBRARY_PATH
tags:
  - mac
id: '7143'
categories:
  - - FreeBSD
date: 2015-12-30 14:54:11
---


<!-- more -->
安装了oracle instant client,执行sqlplus时,找不到库文件:
```js
dyld: Library not loaded: /ade/dosulliv_sqlplus_mac/oracle/sqlplus/lib/libsqlplus.dylib
 Referenced from: /opt/oracle/instantclient_11_2/sqlplus
 Reason: image not found
```

Mac的库路径环境变量与linux不同，其名字为DYLD_LIBRARY_PATH
bashrc中设置此变量：
```js
export DYLD_LIBRARY_PATH=$ORACLE_HOME:$DYLD_LIBRARY_PATH
```
问题解决。

References:
\[1\] [环境变量LIBRARY_PATH的设置](http://blog.chinaunix.net/uid-14504139-id-3867128.html)

 **===
\[erq\]**