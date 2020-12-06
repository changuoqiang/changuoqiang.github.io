---
title: linux系统pypyodbc 1.3.3读取GB编码mdb文件中文字符乱码问题
tags:
  - Debian
  - python3
id: '5797'
categories:
  - - GNU/Linux
date: 2014-08-14 22:25:18
---


<!-- more -->
当前1.3.3版本的pypyodbc在linux系统上面已经可以读取有中文字符的mdb文件,不再出现异常,但是读取的中文字符却全是乱码。

下面是根据一些现象的合理推论:
**mdb文件来自于windows系统,其中的中文字符使用GB编码无疑,但linux系统上mdbtools提供的odbc驱动底层已经执行了编码转换,将GB码转换为unicode码，pypyodbc再一次进行转换所以出现了问题。**

pypyodbc.connect函数有一个参数unicode_results,在python3版本上默认为True,也就是返回unicode编码的结果集。
odbc底层驱动转换一次编码,pypyodbc再转换一次，悲剧不可避免的出现了。

因此设定connect函数的unicode_results为False,也就是原样返回结果集,然后结果集中的字段名和字段值都需要解码为unicode字符串：
```js
$ python3
>>> conn=pypyodbc.connect('Driver=MDBTools;DBQ=/path/to/Record.mdb', unicode_results=False)
>>> conn.cursor().execute('SELECT * FROM Build').fetchone()\[0\].decode('UTF-8')
```

decode('UTF-8')解码成功,说明mdbtools的odbc驱动返回的结果集已经是unicode编码格式。

**\===
\[erq\]**