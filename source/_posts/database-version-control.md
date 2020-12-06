---
title: 数据库版本控制
tags:
  - PostgresQL
id: '3705'
categories:
  - - Database
date: 2013-10-30 13:36:04
---

代码的版本控制十分常见，数据库版本也有必要纳入版本控制。
<!-- more -->
开发和维护过程中，数据库的schema发生变化是难以避免的，而相关数据库脚本不做版本控制，很容易造成开发，测试，上线时的混乱。
一般来说，数据库版本会有一个baseline,之后所有的变化都通过升级脚本来更新。特别是对于生产库来讲，drop然后重新create是不可能的，必须通过升级脚本来升级数据库。

**版本控制策略**

将数据库脚本与源代码一起纳入repo的管理。应用程序的每一个release版本包含一个重新设立的基线脚本和增量升级脚本。

重新设立的基线baseline脚本用来初始化一个全新的数据库，而增量脚本则是针对上一个release版本发布以来，到当前release版本之间的数据库schema变化。
而且增量脚本绝对不容许跨多个release版本，只能是针对上一个release版本的变化。

对于一个全新的安装，比如测试安装，或者新客户安装，只要从代码库里检出需要的release版本，然后执行基线脚本就可以了，没有任何历史负担。
而对于升级安装来说，则需要执行增量升级脚本。

增量升级脚本必须检查应用程序当前的数据库版本，如果应用程序使用的数据库版本是上个release的数据库版本，则可以升级，否则拒绝升级。
这需要在数据库中设置版本记录表，比如：
记录应用程序版本
\[sql\]
CREATE TABLE appversion (
 id INTEGER PRIMARY KEY,
 name varchar(20),
 version varchar(20),
 applied_time time,
 remarks varchar(255)
)
\[/sql\]

记录数据库版本:
\[sql\]
CREATE TABLE dbversion (
 id INTEGER PRIMARY KEY,
 name varchar(20),
 version varchar(20),
 applied_time time,
 remarks varchar(255)
)
\[/sql\]

数据库版本号采用与应用程序一致的版本号，比如常用的主.次.修订.build。应用程序启动时如果发现数据库版本与其不一致，可以给出提示，拒绝启动。

由于schema变化导致的数据迁移脚本也要与增量脚本一起提供，基线版本则没有这个问题。

对于划分模块，每个模块负责自己的数据库设计和修改的情况，可以提供统一的shell脚本来逐一调用每个模块的基线和增量数据库脚本。
也就是每个模块维护自己的基线和数据库脚本，由调用shell脚本负责统一更新应用程序记载的数据库版本号。

基线脚本或增量脚本可以写在一个文件中，也可以拆分到几个文件中。脚本可以手写，当然也可以采用数据库提供的工具来自动生成。

增量升级时建议将Views, Stored Procedures和funcations等drop掉重新create,这样可以[避免很多问题](http://odetocode.com/blogs/scott/archive/2008/02/02/versioning-databases-views-stored-procedures-and-the-like.aspx)。

采用这种版本策略，如果生产中的应用程序要跨版本升级是不可以的，必须逐个release依次增量升级。当然对于应用程序来讲，这有点儿繁琐，但确实可以保证应用程序和数据库时刻处于一致的状态。

下面是一个可能的版本库中数据库脚本的目录结构：
\[html\]
database/
-- baseline
 -- bootstrap.sql
 \`-- create_schema.sh
-- increment
 \`-- increment.sh
\`-- modules
 -- modules1
 -- baseline.sql
 \`-- increment.sql
 -- modules2
 -- modules3
 -- modules4
 \`-- modules5
\[/html\]

bootstrap.sql用于初始化系统的数据库脚本。

数据库版本纳入版本库统一管理后，更有利于应用程序和数据库的持续集成、测试、部署和升级。

而且可以快速搭建开发环境，开发人员从repo中检出一个release后，通过执行baseline脚本，可以迅速的搭建好开发环境需要的数据库环境，而且应用程序和数据库版本是一致的，没有混乱。

如果客户提交一个bug,可以根据客户的应用和数据库版本，迅速的搭建起与客户一致的环境，从而更容易的定位bug。

参考：
[Three Rules for Database Work](http://odetocode.com/blogs/scott/archive/2008/01/30/three-rules-for-database-work.aspx)
[Versioning Databases – The Baseline](http://odetocode.com/blogs/scott/archive/2008/01/31/versioning-databases-the-baseline.aspx)
[Versioning Databases – Change Scripts](http://odetocode.com/blogs/scott/archive/2008/02/02/versioning-databases-change-scripts.aspx)
[Versioning Databases – Views, Stored Procedures, and the Like](http://odetocode.com/blogs/scott/archive/2008/02/02/versioning-databases-views-stored-procedures-and-the-like.aspx)