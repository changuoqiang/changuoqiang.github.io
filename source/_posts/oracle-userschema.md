---
title: Oracle User和Schema的区别和联系
tags:
  - Oracle
id: '1229'
categories:
  - - Database
date: 2011-03-22 16:00:26
---

一般来讲User和Schema有相同的名字,所以比较容易混淆，而实际上User和Schema是完全不同的东西。
<!-- more -->
**Schema**

先看一下Oracle Database Concepts中对Schema的定义：

> A schema is a collection of logical structures of data, or schema objects. A schema is
> owned by a database user and has the same name as that user. Each user owns a single schema.

一个Schema是数据逻辑结构的集合，或者叫Schema对象的集合。一个Schema被一个数据库User所拥有并且与User有相同的名字。每一个User只能拥有一个Schema。

当然User可以访问其他User拥有的Schema，只要Schema的拥有者或sysdba向该用户授予访问这个Schema的权限即可。

可以用SQL创建和操纵Scheme对象，Schema对象有以下几类：
■ Clusters
■ Database links
■ Database triggers
■ Dimensions
■ External procedure libraries
■ Indexes and index types
■ Java classes, Java resources, and Java sources
■ Materialized views and materialized view logs
■ Object tables, object types, and object views
■ Operators
■ Sequences
■ Stored functions, procedures, and packages
■ Synonyms
■ Tables and index-organized tables
■ Views

存储在数据库中的其他类型的一些对象，也可以用SQL创建和操纵，但是他们并不包含在Schema中：
■ Contexts
■ Directories
■ Profiles
■ Roles
■ Tablespaces
■ Users

Schema对象是逻辑数据存储结构，schema对象没有一对一的磁盘物理文件来存储它们的信息。然而，逻辑上oracle在数据库的表空间上存储schema对象，每一个schema对象物理上存储在表空间的一个或多个数据文件中。一个表空间可以包含多个schema的对象，一个schema的对象也可以存在于多个不同的表空间中。

**User**

User则无其他奇特之处,和其他系统广泛使用的用户概念差不多,User可以通过认证登录入系统，并对某些资源具有特定的权限(select,update,delete,drop,connect等)。User对象被创建之后，如果这个User没有创建任何Schema对象，那么这个对象是没有相关联的、默认的schema的。

**总结**

总的来讲，Schema是一种逻辑容器，可以包含各种schema逻辑对象，而User则是对资源访问权限的一种表达。