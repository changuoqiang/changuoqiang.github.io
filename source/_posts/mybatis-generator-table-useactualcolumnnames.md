---
title: MyBatis Generator配置文件table元素的属性useActualColumnNames
tags:
  - Java
id: '4599'
categories:
  - - Database
date: 2013-12-30 16:57:15
---


<!-- more -->
useActualColumnNames用于指定生成实体类时是否使用实际的列名作为实体类的属性名。取值true或false:

*   true
MyBatis Generator会使用数据库中实际的字段名字作为生成的实体类的属性名。
*   false
这是默认值。如果设置为false,则MyBatis Generator会将数据库中实际的字段名字转换为Camel Case风格作为生成的实体类的属性名。

如果明确的使用columnOverride元素指定了字段对应的实体的属性名,那么useActualColumnNames会被忽略。

假设表有一个字段名为start_date,如果这个属性设置为true,则生成的实体类的属性名为start_date,生成的setter/getter为setStart_date/getStart_date。如果useActualColumnNames设置为false,则生成的实体类的属性名为startDate,生成的setter/getter为setStartDate/getStartDate。

那为什么要在数据库表字段中使用Snake Case下划线风格呢?因为大部分数据库服务器对象的命名是不分大小写的,因此使用Snake Case命名风格还是十分有必要的。MyBatis Generator考虑的还真是仔细,将Snake Case转换为Camel Case以与Java风格保持一致。

参考:
[table element](http://mybatis.org/generator/configreference/table.html)

**\===
\[erq\]**