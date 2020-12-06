---
title: oracle即时客户端安装python3 oracle驱动cx_Oracle
tags:
  - Oracle
id: '7138'
categories:
  - - Database
date: 2015-12-27 23:17:46
---


<!-- more -->
下载安装instantclient-sdk包，这个包里有编译需要的头和库文件
```js
$ sudo unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle
``` 

不然会有错误提示:
```js
oci.h: No such file or directory
```

**安装cx_Oracle**

```js
$ sudo pip3 install cx_oracle
```

会有错误提示:
```js
usr/bin/ld: cannot find -lclntsh

collect2: error: ld returned 1 exit status

error: command 'x86_64-linux-gnu-gcc' failed with exit status 1
```

是因为找不到libclntsh库，创建一个符号连接:
```js
$ cd /opt/oracle/instantclient_12_1
$ sudo ln -sf libclntsh.so.12.1 libclntsh.so
$ sudo ln -sf libclntshcore.so.12.1 libclntshcore.so
$ sudo ln -sf libocci.so.12.1 libocci.so
```

重新安装就可以了。

如果安装过程中提示找不到oracle安装，要注意sudo是在root用户的环境下执行pip3安装,要在root用户下设置相应的oracle环境变量。

**python3连接oracle**
```js
>>> import cx_Oracle
>>> conn = cx_Oracle.connet('user/passwd@db')
>>> print(conn.version)
10.2.0.4.0
>>> conn.close()
```

**\===
\[erq\]**