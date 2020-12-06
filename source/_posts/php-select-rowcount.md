---
title: PHP PDO select语句结果行数计算
tags:
  - PHP
id: '2726'
categories:
  - - lang
    - PHP
date: 2012-11-12 10:43:12
---

PDO有一个函数PDOStatement::rowCount返回上一个SQL语句影响的行数。
<!-- more -->
rowCount函数对于DELETE, INSERT, 或者UPDATE语句的结果是正确的,但对于select语句则与数据库的实现相关。有些数据库在执行select语句时会将结果集全部读入内存,但对于数量巨大的结果集,这样显然是低效的。大部分的数据库则只会返回结果集的一部分,当需要时再返回其余的结果集,这样无论是内存占用和执行效率都是优化的。对于后一种情况,则rowCount无法返回正确的SELECT语句结果集的行数。

获取正确的SELECT结果的行数有几种方法

1、**使用fetchAll函数**

$q = $db->query("SELECT ...");
$rows = $q->fetchAll();
$rowCount = count($rows);

2、**使用sql count函数**

$q = $db->query("SELECT count(*) from db;");
$rows = $q->fetch();
$rowCount = $rows\[0\];

显然第二种方法更有效率