---
title: oracle 10g 数据文件大小与大文件表空间
tags:
  - Oracle
id: '2511'
categories:
  - - Database
date: 2012-10-15 10:54:17
---

oracle可以使用的数据文件大小受oracle和文件系统的限制。
<!-- more -->
oracle支持2K,4K,8K,16K,32K的块大小block_size,但默认的表空间只使用22 bits来表达块号block#,所以通常的表空间可以使用的数据文件大小从2k*(222\-1)约8G到32K*(222\-1)约128G不等。一般block_size设置为8K的情况下,数据文件最大可以到约32G大小。

oracle 10g引入了大文件表空间big file tablespace特性,扩充到32 bits来表达块号block#。那么当block_size为2K时,数据文件大小可以达到约8T,当block_size为32K时可以达到128T。一般block_size设置为8K的情况下,则最大数据文件可以为32T大小。

当然这只是oracle的限制,还要考虑到OS文件系统的限制,这二者中的最小值才是实际的限制,但是也要有这么大的存储才行。

但是大文件表空间只可用于本地管理表空间LMT(Locally Managed Tablespace),而且只能使用一个数据文件。创建语句如下:

SQL> CREATE BIGFILE TABLESPACE bfsbs
DATAFILE '/path/to/datafile'
SIZE 100M
AUTOEXTEND ON
NEXT 100M
MAXSIZE 2T
EXTENT MANAGEMENT LOCAL;

可以不指定区段管理方式,oracle 10g默认使用自动的本地管理表空间。 

oracle默认创建普通小文件表空间,使用ALTER DATABASE 命令来修改数据库默认的表空间类型:

SQL> ALTER DATABASE SET DEFAULT BIGFILE TABLESPACE;

虽然大文件表空间可以使用很大的数据文件,但是最好别用太大的数据文件,管理起来可不是那么方便。