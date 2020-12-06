---
title: Debian查看Acess MDB数据库文件
tags:
  - Debian
id: '3733'
categories:
  - - GNU/Linux
date: 2013-10-31 10:47:27
---

虽然ACESS MDB数据库是M$专有格式，有时候还是需要查看。
<!-- more -->
\# apt-get install mdbtools mdbtools-gmdb

mdbtools-gmdb是mdbtools的图形前端。安装完毕后运行MDB Viewer即可。

[MDB Tools](http://mdbtools.sourceforge.net/) 当前只能读取 Access 97 (Jet 3) 和 Access 2000/2002 (Jet 4) 格式，写支持还在开发中。
其实只要读功能就好了。

**拒绝使用专有格式，读取也是不得以而为之。**

**\===
\[erq\]**