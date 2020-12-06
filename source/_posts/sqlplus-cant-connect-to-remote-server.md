---
title: 数据库关闭状态下远程sqlplus客户端无法连接到实例
tags:
  - Oracle
id: '1019'
categories:
  - - Database
date: 2011-02-22 14:11:53
---

用sys用户远程管理新安装的oracle 10.2.0.4 64bits服务器,shutdown immediate后,startup时出现错误提示：
<!-- more -->
```js
ORA-12514: TNS:listener does not currently know of service requested in connect descriptor
```
(监听程序当前无法识别连接描述符中请求的服务)

这是因为listener没有对外监听SID,而且PMON进程动态注册时只注册本地地址
解决办法之一是修改%ORACLE_HOME%\\network\\admin\\listener.ora,在SID_LIST段落内增加监听实例名
```js
(SID_DESC =
(GLOBAL_DBNAME = <SID>)
(ORACLE_HOME = E:\\oracle\\product\\10.2.0\\db_1)
(SID_NAME = <SID>)
)
```
执行
```js
$ lsnrctl reload
```
然后执行
```js
$ lsnrctl status
```

查看一下是否在监听新增加的实例名

**\===
\[erq\]**