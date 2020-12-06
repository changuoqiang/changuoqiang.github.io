---
title: debian下python3读取MDB数据库
tags:
  - python3
id: '4061'
categories:
  - - GNU/Linux
date: 2013-11-11 22:28:57
---

linux平台上可以使用unixodbc和libmdbodbc1读取mdb
<!-- more -->
unixODBC是unix like平台上ODBC规范的开源实现,而libmdbodbc1则是mdbtools提供的mdb数据库的odbc驱动。
如果不通过编程方式，只是单纯查看mdb，可以[Debian查看Acess MDB数据库文件](https://openwares.net/linux/access_mdb_viewer.html)

**安装**

unixODBC和libmdbodbc1

#apt-get install unixodbc libmdbodbc1

**配置odbc**

/etc/odbcinst.ini配置odbc驱动
\[html\]
\[MDBTools\]
Description=MDBTools Driver
Driver=libmdbodbc.so.1
Setup=libmdbodbc.so.1
FileUsage=1
UsageCount=1
\[/html\]

/etc/odbc.ini配置数据源
\[html\]
\[test\]
Driver = MDBTools
Database = /path/to/mdb/file/test.mdb
\[/html\]
也可以在在程序中动态设置数据源

**python3访问mdb**

python3使用[pypyodbc](https://code.google.com/p/pypyodbc/)或者[pyodbc](https://code.google.com/p/pyodbc/)可以访问odbc数据库

*   _pypyodbc_

先看pypyodbc,这是个python实现的odbc访问模块

安装pypyodbc
```js
# python3 setup.py
```

使用pypyodbc读取mdb
```js
$ python3
>>> import pypyodbc
>>> conn=pypyodbc.connect('Driver=MDBTools;DBQ=/path/to/Record.mdb')
>>> print(conn.cursor().execute('SELECT * FROM Build').fetchone()\[0\])
Traceback (most recent call last):
 File "<stdin>", line 1, in <module>
 File "/usr/local/lib/python3.3/dist-packages/pypyodbc.py", line 1805, in fetchone
 value_list.append(buf_cvt_func(alloc_buffer.value))
ValueError: invalid literal for int() with base 10: b'\\xe0'
```
mdb文件中中文字符编码为GB码，出现问题,pypyodbc直接崩溃了。

*   _pyodbc_

pyodbc是C实现的odbc访问模块

安装pyodbc
```js
# apt-get install python3-dev mdbtools-dev
# python3 setup.py build install
```
使用pyodbc读取mdb
```js
$ python3
>>> import pyodbc
>>> conn=pyodbc.connect('Driver=MDBTools;DBQ=/path/to/Record.mdb')
>>> s1=conn.cursor().execute('SELECT * FROM Build').fetchone()\[0\]
>>> s1
'냥\\ue59a\\ua7ba鯥\\ue9bd薙'
```

这次pyodbc没有崩溃，但是输出了乱码。不知是libmdbodbc1还是pyodbc的问题，总之是没有正确的识别GB码，有时间再翻源代码看。

**其他方式访问mdb**

*   _isql_

mdbtools自带的isql可以查看mdb,但不能使用动态数据源，只能使用/etc/odbc.ini文件里配置好的数据源，比如这样

$ isql test

*   _mdb-export导出表到csv文件_

$ mdb-export /path/to/foo.mdb table >> table.csv

mdb-export导出的csv编码是正确的，没有出现乱码。然后可以用pyhton3来处理csv文件。

*   _[mdb-sqlie](https://code.google.com/p/mdb-sqlite/)转换mdb到sqlite格式_

还可以使用mdb-sqlite将mdb数据库转换到sqlite数据库，然后再用python3访问sqlite数据库，这个没有测试。

**\===
\[erq\]**