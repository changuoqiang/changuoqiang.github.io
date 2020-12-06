---
title: PostgreSQL约束
tags:
  - PostgresQL
id: '3683'
categories:
  - - Database
date: 2013-10-29 23:09:31
---

约束用于保证数据的完整性和正确性。
<!-- more -->
**检查约束Check Constraints**

检查约束允许指定特定列的值必须满足一个布尔表达式。比如：
\[sql\]
CREATE TABLE products (
 product_no integer,
 name text,
 price numeric CHECK (price > 0)
);
\[/sql\]
也可以为检查约束指定名字，这样错误信息会看起来更清楚，也方便修改约束。
\[sql\]
CREATE TABLE products (
 product_no integer,
 name text,
 price numeric CONSTRAINT positive_price CHECK (price > 0)
);
\[/sql\]

检查约束也可以引用多个列，如：
\[sql\]
CREATE TABLE products (
 product_no integer,
 name text,
 price numeric CHECK (price > 0),
 discounted_price numeric CHECK (discounted_price > 0),
 CHECK (price > discounted_price)
);
\[/sql\]
在上面这里例子中，前两个是列约束写法，最后一个是表约束写法。一个列约束总是可以用表约束来表达，但反过来却不一定，因为列约束只能引用一个字段而且要附加在引用的字段后面，而表约束则可以引用多个字段。列约束只能引用列约束所在的字段。表约束的顺序没有要求，但最好位于所有引用列的后面，这样看起来更清晰。

PostgeSQL对写法没有太多的要求，最好以与其他数据库兼容的方式来写。甚至可以这样写：
\[sql\]
CREATE TABLE products (
 product_no integer,
 name text,
 price numeric CHECK (price > 0),
 discounted_price numeric,
 CHECK (discounted_price > 0 AND price > discounted_price)
);
\[/sql\]
应该注意，无论检查表达式返回true还是null,检查约束都是满足的。如果需要列非空，还需要附加非空约束。

**非空约束Not-Null Constraints**

非空约束指示一个列不能为null,如：
\[sql\]
CREATE TABLE products (
 product_no integer NOT NULL,
 name text NOT NULL,
 price numeric
);
\[/sql\]

非空约束只能使用列约束语法，非空约束与如下的检查约束功能是一样的：
CHECK (column_name IS NOT NULL)
但是使用非空约束更有效率，非空约束的缺点是不能指定约束的名字。

一个列可以有多个约束，顺着往下写就是了，顺序无关。
\[sql\]
CREATE TABLE products (
 product_no integer NOT NULL,
 name text NOT NULL,
 price numeric NOT NULL CHECK (price > 0)
);
\[/sql\]

**唯一约束Unique Constraints**

唯一约束用于保证一个字段或一组字段的组合值在一个表中是唯一的。

列约束语法示例：
\[sql\]
CREATE TABLE products (
 product_no integer UNIQUE,
 name text,
 price numeric
);
\[/sql\]
表约束语法示例：
\[sql\]
CREATE TABLE products (
 product_no integer,
 name text,
 price numeric,
 UNIQUE (product_no)
);
\[/sql\]

也可以约束多个字段
\[sql\]
CREATE TABLE example (
 a integer,
 b integer,
 c integer,
 CONSTRAINT must_be_different UNIQUE (a, c)
);
\[/sql\]

null值有些不同，因为null是未知的，所以两个null不被认为是相等的。所以唯一约束作用于组合字段时，可以有重复的组合字段记录，只要有一个字段的值是null就可以，这符合SQL标准。然后有些数据库却不这样处理，比如oracle，只要组合字段中非空的字段重复就认为违反了唯一约束。

单一字段约束可以插入多个值为null的重复记录，组合字段如果所有的字段都为null,也可以插入多个重复的记录。

**主键约束Primary Keys**

主键约束就是唯一约束和非空约束的组合。
\[sql\]
CREATE TABLE products (
 product_no integer UNIQUE NOT NULL,
 name text,
 price numeric
);
\[/sql\]
\[sql\]
CREATE TABLE products (
 product_no integer PRIMARY KEY,
 name text,
 price numeric
);
\[/sql\]
两种写法接受的数据是一样的，但还是有区别的。一个表只能有一个主键约束，但可以有多个非空约束和唯一约束，或者二者的组合。
每一个表最好有一个主键。

主键约束也适用于多个字段，如：
\[sql\]
CREATE TABLE example (
 a integer,
 b integer,
 c integer,
 PRIMARY KEY (a, c)
);
\[/sql\]

还要注意，虽然主键约束可以保证唯一和非空，但主键的取值是不受限制的，比如用integer做主键，那么所有的整数都是可以做主键的，0和负数也可以，所以有时候还要根据需要，在主键上添加检查约束，比如主键只能是大于0的整数。

**外键约束Foreign Keys**
见[PostgreSQL外键约束](https://openwares.net/database/postgresql_foreinkey_constraint.html)

**排斥约束Exclusion Constraints**
这是PostgreSQL独有的约束，是不可移植的。

参考：
[Data Definition](http://www.postgresql.org/docs/9.3/static/ddl-constraints.html)