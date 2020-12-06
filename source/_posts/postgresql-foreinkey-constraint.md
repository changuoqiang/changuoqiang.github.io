---
title: PostgreSQL外键约束
tags:
  - PostgresQL
id: '3656'
categories:
  - - Database
date: 2013-10-29 20:48:56
---

外键约束用来实现表与表之间的参照完整性(referential integrity)。
<!-- more -->
外键约束是指一个引用表(referencing table)中的一个或多个引用字段(referencing column)必须与另一个被引用表(referenced table)中相应的被引用字段(referenced column)匹配，而且类型和值都必须匹配。

被引用表(referenced table)中的被引用列(referenced column)必须是一个非延迟的唯一约(unique key)束或者主键约束(primary key)。

比如我们有一个产品表
\[sql\]
CREATE TABLE products (
 product_no integer PRIMARY KEY,
 name text,
 price numeric
);
\[/sql\]

另外还有一个订单表，我们需要保证订单表中只能包含实际存在产品的订单，否则是没意义的垃圾数据。因此我们可以定义一个订单表到产品表的外键约束。
列约束写法：
\[sql\]
CREATE TABLE orders (
 order_id integer PRIMARY KEY,
 product_no integer REFERENCES products (product_no),
 quantity integer
);
\[/sql\]

也可以用表约束的方式这样写：
\[sql\]
CREATE TABLE orders (
 order_id integer PRIMARY KEY,
 product_no integer, 
 CONSTRAINT order_product_fk FOREIGN KEY (product_no) REFERENCES products (product_no),
 quantity integer
);
\[/sql\]

列约束与表约束的主要区别是列约束只能定义单一字段，而表约束则可以组合多个列。
列约束和表约束都可以用CONSTRAINT _constraint_name_为约束命名。

这样以来，就不可能在orders表中创建一条订单记录，记录的product_no非空但其值没有出现在products的product_no字段的值中。

在这里orders叫引用表(referencing table),而products表叫被引用表(referenced table),orders表的字段product_no叫引用列(referencing column)，而products表的product_no叫被引用列(referenced column)。

orders表还可以这样写：
\[sql\]
CREATE TABLE orders (
 order_id integer PRIMARY KEY,
 product_no integer REFERENCES products,
 quantity integer
);
\[/sql\]
这样默认引用products表的主键字段，但最好不要这样用。

外键约束也可以引用多个字段，这时就只能使用表约束的写法了，比如：
\[sql\]
CREATE TABLE t1 (
 a integer PRIMARY KEY,
 b integer,
 c integer,
 FOREIGN KEY (b, c) REFERENCES other_table (c1, c2)
);
\[/sql\]

一个表可以有多个外键约束。上面的例子可能还会需要一个订单包含多个产品，可以这样：
\[sql\]
CREATE TABLE products (
 product_no integer PRIMARY KEY,
 name text,
 price numeric
);

CREATE TABLE orders (
 order_id integer PRIMARY KEY,
 shipping_address text,
 ...
);

CREATE TABLE order_items (
 product_no integer REFERENCES products,
 order_id integer REFERENCES orders,
 quantity integer,
 PRIMARY KEY (product_no, order_id)
);
\[/sql\]

注意最后一张表中，主键和外键重叠了，这是允许的。

如果一个产品被引用后我们想删除这条产品记录，会怎样呢？阻止删除？关联的订单一起删除?还是其他？

下面的例子，我们阻止删除已经被订单(最终是通过订单项order_items)引用的产品记录，然而如果删除一个订单，其所有的订单项全部会被级联删除。

\[sql\]
CREATE TABLE products (
 product_no integer PRIMARY KEY,
 name text,
 price numeric
);

CREATE TABLE orders (
 order_id integer PRIMARY KEY,
 shipping_address text,
 ...
);

CREATE TABLE order_items (
 product_no integer REFERENCES products ON DELETE RESTRICT,
 order_id integer REFERENCES orders ON DELETE CASCADE,
 quantity integer,
 PRIMARY KEY (product_no, order_id)
);
\[/sql\]

外键约束之表约束写法完整语法：
\[ CONSTRAINT _constraint_name_ \] FOREIGN KEY ( _column_name_ \[, ... \] ) REFERENCES _reftable_ \[ ( _refcolumn_ \[, ... \] ) \] \[ MATCH _matchtype_ \] \[ ON DELETE _action_ \] \[ ON UPDATE _action_ \]

**\[ ON DELETE _action_ \] \[ ON UPDATE _action_ \]**

当删除被引用行或者更新被引用列时，对于引用表或引用列,不同的action有不同的行为。可用的action如下：

*   NO ACTION
如果违反外键约束会产生一个错误。如果约束被延迟，那么到事务结束检查约束时如果仍然因为存在一个引用行而违反外键约束，则仍会产生错误。这是默认值。其他的动作action都不能被延迟。
*   RESTRICT
违反外键约束会产生一个错误。
*   CASCADE
级联删除或更新。分别删除一个引用行或者更新一个引用列的值。
*   SET NULL
设置引用列(referencing column(s))的值为null
*   SET DEFAULT
设置引用列为其缺省值。如果缺省值不是null,那么仍然需要被引用表中有一条记录的被引用字段的值与之匹配，否则操作会失败。

**\[ MATCH _matchtype_ \]**

当向引用表的引用列(referencing column(s))插入数据时，根据给定的匹配规则matchtype匹配被引用表的被引用列的值。匹配规则如下：

*   MATCH FULL
不允许多列外键约束中的任何一个为null,除非他们全部为null，这样不要求被引用表中有与其匹配的数据。
*   MATCH PARTIAL
此特性尚未实现
*   MATCH SIMPLE
这是默认值。允许外键约束中的任何一列为null,只要外键约束中的一列为null,则不要求与被引用表相匹配。

**外键约束也可以引用自身表中的字段。**

参考：
[Constraints](http://www.postgresql.org/docs/9.3/static/ddl-constraints.html)