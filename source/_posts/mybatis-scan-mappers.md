---
title: Mybatis自动扫描包设置注意事项
tags:
  - Java
id: '4255'
categories:
  - - java
date: 2013-11-22 20:30:25
---


<!-- more -->
使用mybatis:scan扫描mapper接口很方便
\[xml\]
<mybatis:scan base-package="net.openwares.test.mapper" />
\[/xml\]

但要注意一点：
不要将非mapper接口放入指定的基本包中，因为默认情况下mybatis:scan会将包里的所有接口当作mapper来扫描，所以如果是其他接口就会出现错误。

可以在mybatis:scan元素的基本包里添加多个包，使用逗号或分号分割即可。

下面摘录自Mybatis文档

> <mybatis:scan/> supports filtering the mappers created by either specifying a marker interface or an annotation. The annotation property specifies an annotation to search for. The marker-interface attribute specifies a parent interface to search for. If both properties are specified, mappers are added for interfaces that match either criteria. By default, these two properties are null, so all interfaces in the given base package(s) will be loaded as mappers.