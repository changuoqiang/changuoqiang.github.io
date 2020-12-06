---
title: oracle 自定义数据类型对象
tags:
  - Oracle
id: '5030'
categories:
  - - Database
date: 2014-02-13 21:12:27
---

除了标准的基本数据类型以外,用户还可以自定义数据类型对象,而且自定义类型对象还可以有方法,构造函数,这实质上就是OOP思想在DBMS里的投射。
<!-- more -->
oracle支持的自定义类型有object, SQLJ object,可变数组(varying array,varray), 嵌套表(nested table type), 或不完全对象类型( incomplete object type). 

**创建类型(CREATE TYPE)**

比较常用的是object类型,可以使用基本数据类型或其他自定义数据类型来定义object类型,而且支持继承。

简单的语法,更详细的语法见oracle文档\[1\]
\[sql\]
CREATE OR REPLACE TYPE type_name AS OBJECT(
 foo VARCHAR(10),
 bar VARCHAR(100,
 ...
) NOT FINAL FINAL;
\[/sql\]

NOT FINAL 指明类型可以被其他类型继承,继承时使用UNDER关键字指明父类型。
FINAL 指明类型不可以被其他类型继承。

类型中的字段又称为类型的属性(Attribute)

类型创建以后可以像基本数据类型一样用于创建表字段。
\[sql\]
CREATE TABLE table_name (
 foo bar_type,
);
\[/sql\]

也可以创建只有自定义数据类型的对象表:

\[sql\]
CREATE TABLE table_name OF object_type;
\[/sql\]
可以使用VALUE函数来获取对象表的值。

**更改类型(ALTER TYPE)**

ALTER TYPE详细用法见oracle文档\[2\]
为类型添加新的属性(字段)的语法如下:
\[sql\]ALTER TYPE type_name ADD ATTRIBUTE column data_type \[CASCADE\];\[/sql\]

CASCADE为可选属性,指明是否一并更改当前类型的子类型。

**对象实例条件测试(IS OF)**

使用IS OF来测试对象是否是指定类型的实例，详细语法参见oracle文档\[3\]
\[sql\]... expr IS \[NOT\] OF \[TYPE\] (\[ONLY\] \[SCHEMA.\]type_name)\[/sql\];

ONLY 指明确匹配指定的类型,不匹配子类型。当expr的结果是type_name的类型或子类型(不指定ONLY)时条件测试为真,否则为假。

**改变类型(TREAT函数)**

使用TREAT函数来改变表达式的类型为指定的类型,类似于编程语言中常见的强制类型转换,详细的语法见oracle文档\[4\]

\[sql\]TREAT(expr AS \[REF\] \[schema.\]type_name)\[/sql\]

REF 指明表达式为引用类型,还真全活,连引用都有-_-#

**更新类型对象属性值**

可以像编程语言中访问对象的属性一样来访问类型的属性,使用"."操作符
\[sql\]
SQL>UPDATE table_name t set t.foo.bar=foobar where t.xxx=yyy;
\[/sql\]

但如果需要使用TREAT函数进行类型转换,则UPDATE时比较麻烦,目前使用的方法如下,不知道有没有更好的方法:
\[sql\]
SQL> UPDATE (SELECT TREAT(t.foo as bar).foobar f,t.column c from table_name t) SET f=xxx WHERE c=yyy;
\[/sql\]

**标准兼容性**

SQL标准中没有自定义数据类型,因为这个特性是不可移植的,应该谨慎使用。
PostgreSQL也支持自定义数据类型,语法与oracle大同小异。

references:
\[1\][CREATE TYPE](http://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_8001.htm)
\[2\][ALTER TYPE](http://docs.oracle.com/cd/B19306_01/server.102/b14200/statements_4002.htm)
\[3\][IS OF type Condition](http://docs.oracle.com/cd/B28359_01/server.111/b28286/conditions014.htm#SQLRF52157)
\[4\][TREAT](http://docs.oracle.com/cd/B19306_01/server.102/b14200/functions198.htm)

**\===
\[erq\]**