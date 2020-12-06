---
title: oracle 10g 控制文件冗余
tags:
  - Oracle
id: '1688'
categories:
  - - Database
date: 2011-11-12 21:26:29
---

oracle 10g 默认安装会在oracle/product/10.2.0/oradata/${ORACLE_SID}/下生成3个控制文件
<!-- more -->
分别为CONTROL01.CTL,CONTROL02.CTL和CONTROL03.CTL,由spfile参数CONTROL_FILES指定这三个控制文件的位置。这三个控制文件其实是完全一样的，其中两个为冗余备份。

如果其中任意一个控制文件损坏，则数据库会当机，因为spfile引用了全部三个控制文件，此时可以通过修改CONTROL_FILES参数剔除损坏的控制文件，或者用完整的控制文件来覆盖损坏的控制文件，这样就可以正常启动数据库了，当然前提是至少有一个控制文件是完整无误的。

默认情况下oracle将三个控制文件放到了同一个目录，这样风险相对较高，可以将三个控制文件分散到不同的驱动器上提高安全性，同时可以提高控制文件的写入效率。只要修改CONTROL_FILES参数，并将控制文件拷贝到对应的路径下，关闭并重新打开数据库即可。