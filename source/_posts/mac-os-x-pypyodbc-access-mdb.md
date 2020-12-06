---
title: Mac OS X使用pypyodbc访问mdb数据库
tags:
  - mac
id: '5805'
categories:
  - - Database
date: 2014-08-15 10:41:41
---


<!-- more -->
首先使用brew安装unixodbc和mdbtools,unixodbc是odbc驱动管理器,mdbtools提供了一组mdb操作工具,更重要的是mdbtools提供了mdb驱动程序。

```js
$ brew install unixodbc
$ brew install mdbtools
```

但是安装完成后发现/usr/local/lib目录中没有mdbtools驱动动态链接库libmdbodbc.dylib
查看mdbtools选项可以发现:
```js
$ brew options mdbtools
--with-man-pages
 Build manual pages
```
mdbtools formula并没有提供`--with-unixodbc`选项,默认也没有build mdb驱动,因此需要手动来编译安装mdbtools提供的mdb driver

**编译安装libmdbodbc**
brew安装mdbtools时已经将mdbtools的源码包下载到了目录/Library/Caches/Homebrew/,所以直接使用这个源码包编译安装就可以了。

```js
$ tar zxvf mdbtools-0.7.1
$ cd mdbtools-0.7.1
$ autoreconf -i -f
$ ./configure --with-unixodbc=/usr/local --disable-man
$ make
$ cd src/odbc
$ sudo make install
```

这样libmdbodbc驱动程序就安装到了/usr/local/lib目录下。libmdbodbc的源代码就在src/odbc目录下。

**配置unixodbc**

因为brew的所有包都安装在/usr/local下面,因此这里配置unixodbc应该使用/usr/local/etc/目录下的odbcinst.ini和odbc.ini文件。
odbcinst.ini配置如下：
```js
\[MDBTools\]
Description=MDBTools Driver
Driver=libmdbodbc.dylib
Setup=libmdbodbc.dylib
FileUsage=1
UsageCount=1
```

然后就可以像linux平台上一样来访问mdb文件了。
```js
$ python3
>>> import pypyodbc
>>> conn=pypyodbc.connect('Driver=MDBTools;DBQ=/path/to/record.mdb')
```
因为这里也是使用mdbtools提供的odbc驱动,所以和pypyodbc配合使用时仍然存在[中文字符编码转换的问题](https://openwares.net/linux/pypyodbc_gb_mdb_mess.html),和linux平台上一样[处理](https://openwares.net/linux/pypyodbc_gb_mdb_mess.html)即可。

**\===
\[erq\]**