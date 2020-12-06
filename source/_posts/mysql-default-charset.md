---
title: 轻轻松松修改mysql默认字符集为utf8
tags:
  - Debian
id: '27'
categories:
  - - GNU/Linux
date: 2009-04-20 23:02:35
---

utf8是我很喜欢的的字符集，在我的Debian lenny上安装mysql后，默认的字符集是latin1，现在就让我们把mysql相关的所有默认字符集都更改为utf8。

在/etc/mysql/conf.d目录下面新建一个文件charset.cnf，增加如下内容：
\[client\]
default-character-set = utf8
\[mysql\]
default-character-set = utf8
\[mysqld\]
default-character-set =utf8

然后执行命令sudo /etc/init.d/mysql reload，现在连上你的数据库看看吧，默认的字符集和校对集全部变成了utf8。