---
title: debian amd64 安装oracle 10g 即时客户端(instant client)
tags:
  - Debian
  - Oracle
id: '1606'
categories:
  - - GNU/Linux
date: 2011-10-28 15:14:50
---

oracle instant client是oracle提供的最轻量的客户端，支持多平台，除支持oracle原生的数据库存取协议外，还支持ODBC和JDBC,支持对数据库服务器的简单管理，减轻应用程序客户端分发的负担。
<!-- more -->
**下载安装包**

从oracle官方的[instant client](http://www.oracle.com/technetwork/database/features/instant-client/index-097480.html)下载地址下载linux amd64版本对应的基本包basic-10.2.0.5.0-linux-x64.zip和sqlplus支持包sqlplus-10.2.0.5.0-linux-x64.zip，如需要还可下载其他支持包。

**安装**

将install client客户端安装到/opt/oracle目录
```js
#mkdir /opt/oracle
#unzip basic-10.2.0.5.0-linux-x64.zip -d /opt/oracle
#unzip sqlplus-10.2.0.5.0-linux-x64.zip -d /opt/oracle
```

在/opt/oracle目录下生成instantclient_10_2子目录，instant client客户端的文件都在此目录下

**配置**

~/.bashrc文件中添加如下内容：
```js
export ORACLE_HOME=/opt/oracle/instantclient_10_2
export LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
export PATH=$ORACLE_HOME:$PATH
export TNS_ADMIN=$ORACLE_HOME
export SQLPATH=$ORACLE_HOME
```

注意:tnsname.ora最好放置到$ORACLE_HOME/network/admin目录下。

然后
```js
#source .bashrc
```

在$ORACLE_HOME目录下添加并编辑tnsnames.ora文件，增加拟访问的oracle服务器tnsname

**连接**

sqlplus连接到数据库服务器
```js
$ sqlplus username/passwd@tnsname
```

如果有错误提示:

```js
sqlplus: error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
```

那么需要安装libaio1

```js
# apt install libaio1
```

 **===
\[erq\]**