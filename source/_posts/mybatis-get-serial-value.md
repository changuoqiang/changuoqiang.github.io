---
title: Mybatis获取PostgreSQL数据库插入记录的自增序列值
tags:
  - Java
id: '4274'
categories:
  - - java
date: 2013-11-23 16:33:54
---


<!-- more -->
有这么几种方法：

*   useGeneratedKeys

这是insert独有的属性，告诉Mybatis使用JDBC的getGeneratedKeys 方法去获取数据库内部产生的key。
如果自增键的名字不叫id,还需要设置一个属性keyProperty来告诉Mybaits获取回来的结果设置到那个字段上。
**最好明确设置keyProperty属性**。
\[xml\]
<insert id="insert" parameterType="org.xxx.xxx.entity.Building"
 useGeneratedKeys="true" keyProperty="myid">

INSERT INTO ... 

</insert>
\[/xml\]

使用Mybatis Generator生成mapper文件时,只要在table元素下添加子元素generatedKey即可,如下:
\[xml\]
<generatedKey column="id" sqlStatement="JDBC"/>
\[/xml\]

column是自动生成的键,使用JDBC标准生成键方式。
最好将generatedKey子元素放到table元素的最后,否则可能会有错误提示。

*   selectKey

selectKey定义一个子查询，将查询的自增键的结果赋予insert参数的相应字段。selectKey有以下几个属性：

keyProperty - selectKey子查询的结果应该设置到传入参数的哪个字段上
resultType - 查询的结果类型。Mybaits其实可以自己查询出结果类型。
order - 插入语句执行之前还是之后执行selectKey子查询，只能取值BEFORE或AFTER
statementType - 语句类型。STATEMENT，PREPARED或CALLABLE

插入语句之后执行selectKey子查询
\[xml\]
<selectKey order="AFTER" keyProperty="id" resultType="java.lang.Integer">
 SELECT currval('mytable_id_seq')
</selectKey>
\[/xml\]

插入语句之前执行selectKey子查询
\[xml\]
<selectKey order="BEFORE" keyProperty="id" resultType="java.lang.Integer">
 SELECT nextval('mytable_id_seq')
</selectKey>
\[/xml\]

PostgreSQL为serial字段生成的sequence名字为: 表名_列名_seq,但是这个序列并不能单独访问，否则会有提示：
ERROR: currval of sequence "mytable_id_seq" is not yet defined in this session

*   RETURNING子句

PostgreSQL的INSERT语句可以有一个RETURNING字句，返回刚插入记录的字段值。而且RETURNING的语法与SELECT是一样的，这个功能还是十分强大的，不过这是PostgreSQL独有的SQL标准之外的扩展特性。

\[xml\]
<insert id="insert" parameterType="org.xxx.xxx.entity.Building" resultType="int">
INSERT INTO ... VALUES (...) RETURNING id
</insert>
\[/xml\]

useGeneratedKeys是最简单的，只要数据库支持就应该使用这个方法。

无论使用哪个方法，返回的自增键的值都应该从insert方法的参数对应的字段去取，而不是获取insert方法的返回值，insert方法总是返回INSERT INTO语句影响的行数，如果插入成功其值为1，如果插入失败其值为0