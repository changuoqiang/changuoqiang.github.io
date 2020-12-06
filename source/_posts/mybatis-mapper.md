---
title: 'MyBatis mapper文件中的变量引用方式#{var}与${var}'
tags:
  - Java
id: '4576'
categories:
  - - Database
date: 2013-12-26 23:15:00
---


<!-- more -->
By default, using the #{} syntax will cause MyBatis to generate PreparedStatement properties and set the values safely against the PreparedStatement parameters (e.g. ?). While this is safer, faster and almost always preferred, sometimes you just want to directly inject a string unmodified into the SQL Statement. For example, for ORDER BY, you might use something like this:

ORDER BY ${columnName}
Here MyBatis won't modify or escape the string.

NOTE It's not safe to accept input from a user and supply it to a statement unmodified in this way. This leads to potential SQL Injection attacks and therefore you should either disallow user input in these fields, or always perform your own escapes and checks.

默认情况下,使用#{}语法,MyBatis会产生PreparedStatement语句中，并且安全的设置PreparedStatement参数，这个过程中MyBatis会进行必要的安全检查和转义。

有时候可能需要直接插入一个不做任何修改的字符串到SQL语句中。这时候应该使用${}语法。比如，ORDER BY字句

ORDER BY ${columnName}

MyBatis会原原本本的将columnName变量的值插入到SQL语句中,不做任何检查和转换。以这种方式将用户的输入直接插入到SQL语句中是不安全的，可能会导致潜在的SQL注入攻击，因此应该禁止直接将用户数据插入这些字段，或者执行必要的转义和检查。