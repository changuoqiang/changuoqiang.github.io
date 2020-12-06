---
title: windows 8.1 64位系统python3访问mdb数据库
tags:
  - python3
id: '4072'
categories:
  - - Database
date: 2013-11-12 13:48:24
---

RT
<!-- more -->
有一个小的桌面辅助工具必须要从windows平台运行，因为要转换的数据和使用这个桌面辅助工具的部门使用windows。
打算用python3来做这个转换工具，GUI使用python内建支持的事实标准[TkInter](https://wiki.python.org/moin/TkInter)
so,有了这篇post。

翻出windows本，其上的系统为8.1 64 bits。
首先需要access database engine,从M$官方下载[Microsoft Access 2010 数据库引擎可再发行程序包](http://www.microsoft.com/zh-cn/download/details.aspx?id=13255),选择下载AccessDatabaseEngine_X64.exe

安装不表。

windows 64 bits平台上mdb驱动的准确名字为:
\[html\]
Microsoft Access Driver (*.mdb, *.accdb)
\[/html\]
在python3中使用时必须分毫不差。

可以使用[MDB Viewer Plus](http://www.alexnolan.net/software/mdb_viewer_plus.htm)查看mdb数据库的结构，这软件不开源，但free。没必要为了简单的查看mdb去买套office suite。

仍然使用pypyodbc和pyodbc做了简单测试。

这次pypyodbc表现不错，正确读取数据库中的中文字段，但是pyodbc则崩溃了

>>> import pyodbc
>>> conn=pyodbc.connect('Driver={Microsoft Access Driver (*.mdb, *.accdb)};DBQ=C:\\\\Record.mdb')
>>> s1=conn.cursor().execute("SELECT * FROM Build").fetchone()\[0\]
Traceback (most recent call last):
 File "", line 1, in 
 s1=conn.cursor().execute("SELECT * FROM Build").fetchone()\[0\]
UnicodeDecodeError: 'utf-8' codec can't decode byte 0xb7 in position 2: invalid start byte
还是因为字符编码的问题,windows内码转到到UTF8出现了问题。

pypyodbc则正确的读取转换了中文字段。python3安装到了Program Files目录，安装pypyodbc时需要提供管理员权限。

pypyodbc还为windows平台提供了一些特有的函数，比如连接mdb数据库可以这样写:

>>> import pypyodbc
>>> conn=pypyodbc.win_connect_mdb('C:\\\\Record.mdb')

创建mdb用win_create_mdb函数

注意这些函数是不可移植的。

**\===
\[erq\]**