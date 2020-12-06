---
title: oracle 10g 查看表空间使用情况
tags:
  - Oracle
id: '2487'
categories:
  - - Database
date: 2012-09-18 18:11:53
---

表空间的空间利用情况信息主要来自表dba_data_files和dba_free_space
<!-- more -->
temp表空间的使用情况信息则来自于dba_temp_files和v$temp_space_header

SQL语句:
\[sql\]
SELECT df.tablespace_name "tablespace name",df.total_space "total space(M)",fs.free_space "free space(M)",
 ROUND((1-fs.free_space/df.total_space)*100,2) "usage(%)"
FROM
(SELECT tablespace_name,ROUND(SUM(bytes)/(1024*1024),2) total_space FROM dba_data_files GROUP BY tablespace_name) df,
(SELECT tablespace_name,ROUND(SUM(bytes)/(1024*1024),2) free_space FROM dba_free_space GROUP BY tablespace_name) fs
WHERE df.tablespace_name=fs.tablespace_name
UNION ALL
SELECT tf.tablespace_name "tablespace name",tf.total_space "total space(M)",tsh.free_space "free space(M)",
 ROUND((1-tsh.free_space/tf.total_space)*100,2) "usage(%)"
FROM
(SELECT tablespace_name,ROUND(SUM(bytes)/(1024*1024),2) total_space FROM dba_temp_files GROUP BY tablespace_name) tf,
(SELECT tablespace_name,ROUND(SUM(bytes_free)/(1024*1024),2) free_space FROM v$temp_space_header 
 GROUP BY tablespace_name) tsh
WHERE tf.tablespace_name=tsh.tablespace_name ORDER BY 4 DESC;
\[/sql\]
10g有个未公开的视图dba_tablespace_usage_metrics可以便捷的查询表空间使用情况
AQL>SELECT * FROM dba_tablespace_usage_metrics ORDER BY used_percent DESC;
但是这个视图查询的结果与上面脚本查询的结果并不一致,据说dba_tablespace_usage_metrics视图计算利用率时包含了已经drop但是还没有purge的表所使用的空间.