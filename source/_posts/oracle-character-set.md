---
title: oracle字符集
tags:
  - Oracle
id: '2575'
categories:
  - - Database
date: 2012-10-16 21:17:04
---

oracle的字符集牵扯到数据库字符集,国家字符集,客户端字符集这几个概念。
<!-- more -->
**oracle支持的字符集**

oracle支持单字节字符集如ASCII字符集,传统的多字节字符集如GBK字符集,当然更优先支持UNICODE字符集。

oracle支持GBK的兼容字符集叫做ZHS16GBK,但即使是用于中文系统也建议优先使用UNICODE字符集。UNICODE字符集涵盖更多的字符,而且标准兼容性更好。

ORACLE支持UNICODE的字符集主要有UFT8,AL32UTF8和AL16UTF16。UTF8从8i开始出现,最高支持到Unicode 3.0标准,而且此字符集不再升级。AL32UTF8和AL16UTF16从9i开始出现,在10g r2中支持Unicode 4.0标准,此二者的区别在于一个是UTF-8编码转换格式,另一个为UTF-16编码转换格式。

oracle推荐新建的数据库都采用AL32UTF8作为数据库字符集。AL32UTF8涵盖了ZHS16GBK支持的所有字符,但并不是其超集,因为二者的编码格式是不兼容的。

**数据库字符集(Database Character Set)**

Oracle数据库使用数据库字符集来:
1)存储SQL CHAR datatypes (CHAR, VARCHAR2, CLOB, and LONG)
2)用作表名,列名,PL/SQl变量名等标识符
3)输入和存储SQL和PL/SQL源代码

查询数据库字符集

第一种方法:
\[sql\]
SQL> SELECT userenv('language') FROM dual;
USERENV('LANGUAGE')
----------------------
AMERICAN_AMERICA.AL32UTF8
\[/sql\]
字符集为AL32UTF8

第二种方法：
\[sql\]
SQL> SELECT value FROM v$nls_parameters WHERE parameter='NLS_CHARACTERSET';
VALUE
--------
AL32UTF8
\[/sql\]
**国家字符集(National Character Set)**

国家字符集可以使数据库在没有指定UNICODE数据库字符集时来存储UNICODE字符数据,国家字符集只用于NCHAR, NVARCHAR2和NCLOB类型字段的数据存储。NCHAR, NVARCHAR2和NCLOB只支持UNICODE字符而不支持其他的单字节和多字节字符集。CHAR, VARCHAR2, CLOB和LONG则可以支持所有的字符编码类型。如果数据库字符集为UNICODE字符集,则没什么必要使用NCHAR, NVARCHAR2和NCLOB等数据类型。
oracle 10g只支持两种国家字符集UTF8和AL16UTF16,UTF8为变长编码,AL16UTF16为双字节编码,优先使用UTF8。

查询国家字符集
\[sql\]
SQL> SELECT value FROM v$nls_parameters WHERE parameter='NLS_NCHAR_CHARACTERSET';
VALUE
---------
UTF8
\[/sql\]
**客户端字符集**

客户端字符集通过NLS_LANG环境变量或注册表orale home下的键NLS_LANG来设置。

NLS_LANG参数由以下部分组成:
NLS_LANG=<Language>_<Territory>.<Clients Characterset>

linux平台:
```js
$ export NLS_LANG=AMERICAN_AMERICA.AL32UTF8
```
在这里,AMERICAN是语言,AMERICA是区域,AL32UTF8则为客户端字符集。

oracle数据库根据数据库字符集和客户端字符集来决定是否进行字符集转换。如果客户端字符集与数据库字符集完全一致,则无需进行字符编码转换。如果客户端字符集是数据库字符集的子集,也无需进行字符编码转换,其他情形下则需要在客户端字符集和数据库字符集之间进行转换。这个规则对于写入和查询都是一样的。

客户端字符集不是由数据库字符集决定的,而是由客户端系统环境所决定的。oracle无从知晓客户端的系统环境,只能依靠客户端设置的NLS_LANG参数来决定客户端使用的字符集。客户端的NLS_LANG参数应该设置成与客户端操作系统一致的字符集,因为客户端依赖操作系统的字符集来进行输入和输出。所以如果操作系统使用utf-8字符集,则客户端字符集设置为AL32UTF8即可。如果操作系统使用GKB字符集,则客户端字符集需要设置为ZHS16GBK。当然,如果oracle客户端自身支持字符集的转换,也可以按客户端自身设置的字符集来设定NLS_LANG变量。

还有一种情形,如果使用sql文件作为客户端的输入,则应视sql文件使用的字符集而设定客户端的字符集,因为文件使用的字符集可以和操作系统使用的字符集不一致。理论上是这样的,但如果某些oracle客户端将sql输入文件转换成与系统一致的字符编码格式再传送到服务器端执行则另当别论。

一句话,NLS_LANG设置的原则为:**客户端送给数据库何种字符集编码的字符流,将NLS_LANG设置成这种字符集即可**,这样数据库就会知道如何正确的去解读接受的字符流。

**exp/imp与客户端字符集**

expdp/impdp都是在服务器端执行的,所以不会牵扯到客户端字符集。
exp/imp时设置的客户端字符集如果与数据库字符集不同,则数据库在导出到数据文件或从数据文件导入时发生字符集转换。

很显然,从数据库exp导出到数据文件时,设置客户端字符集与数据库字符集一致是最佳的,因为这样不会发生字符集转换,导出文件是二进制格式的,无论以何种字符集导出都是可以在OS中正常存储和拷贝的。

当从数据文件导入到数据库时,客户端字符集要设置成导出数据文件使用的字符集,这样数据库才能正确理解客户端发送的数据流。此时数据库字符集可能与客户端字符相同,也可能不同。如果相同则无需在导出数据文件和数据库之间转换字符集,如果不同则需要在导出数据文件和字符集之间转换字符集,甚至如果字符集不兼容,则会丢失数据。

**\===
\[erq\]**