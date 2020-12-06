---
title: Oracle exp/imp用户不同导致job停止工作
tags:
  - Oracle
id: '1409'
categories:
  - - Database
date: 2011-05-03 16:28:37
---

因为oracle数据库用户很多,统一用system用户进行导入/导出,导致普通用户的job作业停止工作
<!-- more -->
使用一下语句查看系统里所有的job

1 SQL>**select** * from dba_jobs;  

发现所有普通用户job的LOG_USER和PRIV_USER字段都变成了system,而SCHEMA_USER还是原来的用户的schema名字。这是由于imp导入用户与job的属主用户不同造成的。

解决方法之一用job属主用户进行导入,参考"[Oracle Jobs与Exp/Imp](https://openwares.net/database/oracle_jobs_exp_imp.html)"

重新导入太麻烦了，也可以这样解决：

以sysdba角色登录，执行一下语句修正两个字段LOG_USER和PRIV_USER的值为SCHEMA_USER字段的值

1 \- -login sys as sysdba  
2 **update** dba_jobs **set** log_user='username',priv_user='username' where schema_user='username';  
3 **commit**;  

如果job的broken属性是Y,以job owner用户登录执行以下语句：

1 \- -login as job's owner,   
2 BEGIN  
3   FOR i **IN** (**SELECT** job FROM user_jobs WHERE broken='Y')  
4   LOOP  
5        dbms_job.broken(i.job,false);  
6        dbms_job.run(i.job,true);   
7   END LOOP;  
8 END;  

或者这样执行
SQL>exec dbms_job.broken(job_id,false);
SQL>exec dbms_job.run(job_id);

这样就o了