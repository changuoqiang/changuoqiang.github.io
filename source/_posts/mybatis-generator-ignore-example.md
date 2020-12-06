---
title: 配置Mybatis Generator不要生成Example类
tags:
  - Java
id: '4511'
categories:
  - - Database
date: 2013-12-19 16:01:16
---


<!-- more -->
Mybatis Generator默认设置会生成一大堆罗哩罗嗦的Example类,主要是用各种不同的条件来操作数据库,大部分是用不到的,用到的时候手工修改mapper和接口文件就行了。

\[sql\]
<table schema="general" tableName="tb_table_name" domainObjectName="EntityName"
 enableCountByExample="false" enableUpdateByExample="false" enableDeleteByExample="false"
 enableSelectByExample="false" selectByExampleQueryId="false" >
 <property name="useActualColumnNames" value="true"/>
</table>
\[/sql\]

这样生成的mapper和dao接口就清爽多了。