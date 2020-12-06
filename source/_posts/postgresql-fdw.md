---
title: postgresql的FDW
tags:
  - PostgresQL
id: '7689'
categories:
  - - Database
date: 2016-11-10 21:25:38
---


<!-- more -->
SQL/MED(SQL Management of External Data)是SQL与外部数据交互的标准，postgresql对此的支持就是FDW(Foreign Data Wrapper)，可以支持各种各样的外部数据，从关系数据库、NoSQL数据库到文件，几乎涵盖了常见的各种数据源。有通用的支持关系数据库的FDW,比如JDBC_FDW,ODBC_FDW,也有针对特定数据库的FDW,比如postgres_fdw,oracle_fdw,mysql_fdw，也有对csv,json文件等的支持,file_fdw,josn_fdw。

postgresql的FDW不但支持查询，现在还可以支持insert,update,delete等操作，还可以下推(pushdown)where,group by,sort,join等。

References:
\[1\][Foreign data wrappers](https://wiki.postgresql.org/wiki/Fdw)

**\===
\[erq\]**