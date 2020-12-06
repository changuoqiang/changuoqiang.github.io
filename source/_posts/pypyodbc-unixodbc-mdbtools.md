---
title: 'pypyodbc,unixODBC和mdbtools'
tags: []
id: '7728'
categories:
  - - Database
date: 2016-11-21 20:29:35
---


<!-- more -->
**pypyodbc**

pypyodbc是一个使用纯python实现的跨平台odbc模块，其利用了ctypes来访问底层的odbc驱动，支持python2和python3。
虽然跨平台，但其对linux/mac平台上的unixODBC支持存在问题，无法正确显示中文字段名和字段值。

**unixODBC**

unixODBC有几个函数的ansi版本和宽字符版本返回信息比较古怪。

首先说SQLDescribeCol，其ansi版本，也就是不带后缀W的版本，无论本地locale为何皆直接返回utf-8编码的字符，但是SQLDescribeColW版本在mac平台上返回utf-16编码的字符，linux平台对于中文字符返回的是用zero填充了每一个utf-8编码字节的神一样的编码

如下面所示：
```js
'\\xe5\\x00\\x9b\\x00\\xbe\\x00\\xe5\\x00\\xb9\\x00\\x85\\x00\\xe5\\x00\\x8f\\x00\\xb7\\x00\\x00\\x00'
```
正确的应该是长这样的：
```js
'\\xe5\\x9b\\xbe\\xe5\\xb9\\x85\\xe5\\x8f\\xb7\\x00
```
以utf-8解码后对应的中文字符是"图幅号"

而英文字符返回的是这样的：
```js
'B\\x00u\\x00i\\x00l\\x00d\\x00G\\x00e\\x00o\\x00C\\x00o\\x00d\\x00e\\x00\\x00'
```
仔细看，这串字符实际上就是"BuildGeoCode",当然也是utf-8编码无疑。返回的编码以'\\x00\\x00'作为结束符，它是utf-16吗？它是utf-8吗？
这都算天坑了吧，没这样玩的。

SqlGetData则只有一个版本，无论locale为何都是返回utf-8编码的字符。

针对这几点问题制作了一个补丁，放在了github上，准备给原作者发一个pull request。修改后的版本，connect函数无论unicode_results为True或False都可以正确的返回中文字符。

还有一个函数SQLGetInfo(W)，当使用SQL_DRIVER_NAME(值为6)调用时，无论调用哪个版本，都返回SQL_ERROR(值为-1)。

**mdbtools**
mdbtools是unixODBC上的mdb driver,当前只支持读操作，查询数据时尙不支持group by字句，select得到结果后自行排序吧。

**UPDATE:**
补丁已经迅速进入[官方主线](https://github.com/jiangwen365/pypyodbc)

**\===
\[erq\]**