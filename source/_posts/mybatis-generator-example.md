---
title: MyBatis Generator产生的Example类
tags:
  - Java
id: '4563'
categories:
  - - Database
date: 2013-12-26 10:01:35
---

Example类用于构造复杂的筛选条件。
<!-- more -->
**基本概念**

*   **Criterion**

Criterion是最基本,最底层的Where条件，用于字段级的筛选，feild用于指代字段名字,列举如下:

只有一个条件,不需要其他参考值
feild IS NOLL 
feild IS NOT NULL

与一个参考值进行算数运算
feild > value
feild >= value
feild = value
feild value
feild <= value
feild < value

与一个参考值进行模糊查询,参值中的%,?只能在构造查询条件时手动指定。

feild LIKE value
feild NOT LIKE value

介于两个参考值之间

feild BETWEEN value AND secondValue

在或不在一个参考值集合中,item来自于value集合

feild IN (item,item,item,...)
feild NOT IN (item,item,item,...)

MyBatis Generator会为每个字段产生如上的Criterion，如果表的字段比较多,产生的Example类会十分庞大。理论上通过Example类可以构造你想到的任何筛选条件。

*   **Criteria**
Criteria包含一个Cretiron的集合,每一个Criteria对象内包含的Cretiron之间是由AND连接的,是逻辑与的关系。

*   **oredCriteria**
Example内有一个成员叫oredCriteria,是Criteria的集合,就想其名字所预示的一样，这个集合中的Criteria是由OR连接的，是逻辑或关系。oredCriteria就是ORed Criteria。

**用法**

示例来自[官方文档](http://mybatis.org/generator/generatedobjects/exampleClassUsage.html)。

\[java\]
TestTableExample example = new TestTableExample();

 example.or()
 .andField1EqualTo(5)
 .andField2IsNull();

 example.or()
 .andField3NotEqualTo(9)
 .andField4IsNotNull();

 List<Integer> field5Values = new ArrayList<Integer>();
 field5Values.add(8);
 field5Values.add(11);
 field5Values.add(14);
 field5Values.add(22);

 example.or()
 .andField5In(field5Values);

 example.or()
 .andField6Between(3, 7);
\[/java\]
or()方法会产生一个新的Criteria对象,添加到oredCriteria中,并返回这个Criteria对象，从而可以链式表达，为其添加Criterion。
产生的动态SQL是这样的：
\[sql\]
where (field1 = 5 and field2 is null)
 or (field3 <> 9 and field4 is not null)
 or (field5 in (8, 11, 14, 22))
 or (field6 between 3 and 7)
\[/sql\]

**其他**

Example类的distinct字段用于指定DISTINCT查询。

orderByClause字段用于指定ORDER BY条件,这个条件没有构造方法,直接通过传递字符串值指定。