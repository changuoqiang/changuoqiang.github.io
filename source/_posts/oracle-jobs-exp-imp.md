---
title: Oracle Jobs与Exp/Imp
tags:
  - Oracle
id: '485'
categories:
  - - Database
date: 2009-09-21 09:38:59
---

最近因为一点儿小问题，用Exp/Imp做了一次数据恢复。恢复以后本来正常的snapshot刷新出了问题，job不工作了，本来一天要更新两次数据，现在数据停止更新了。
 用system登录oracle，然后select * from dba_jobs;发现所有的jobs的LOG_USER和PRIV_USER变成了system用户，而SCHEMA_USER还是原来的用户，而且NEXT_DATE也变的面目全非。原来是Imp时jobs全部corrupt掉了。

出现这个情况的原因是Exp和Imp的时候都是使用的system用户，所以为带有jobs的用户做Exp/Imp时，一定要用这个用户自身来导入、导出。
<!-- more -->
因为用户已经删除没有机会再重新Exp，只好重新用拥有jobs的用户来进行Imp，一定要为该用户授予DBA角色，不然无法进行导入，会有错误提示：

 "IMP-00013: 只有 DBA 才能导入由其它 DBA 导出的文件
 IMP-00000: 未成功终止导入"

即使授予了DBA角色，仍然会有警告：

 "警告: 此对象由 SYSTEM 导出, 而不是当前用户"

但并不影响正确的导入。

导入完成后，重新查看jobs发现已经都正常了。
手工刷新一次，仍然提示错误：

 "已连接。
 BEGIN proc_refreshsnapshot; END;
 
 *
 ERROR 位于第 1 行:
 ORA-12034: "xxx"."xxx" 上的实体化视图日志比上次刷新后的内容新
 ORA-06512: 在"SYS.DBMS_SNAPSHOT", line 803
 ORA-06512: 在"SYS.DBMS_SNAPSHOT", line 860
 ORA-06512: 在"SYS.DBMS_SNAPSHOT", line 841
 ORA-06512: 在"xxx.PROC_REFRESHSNAPSHOT", line 3
 ORA-06512: 在line 1"

把所有snapshot table做一次完全刷新，exec dbms_snapshot.refresh('xxx','C');,
问题解决，现在一切正常。