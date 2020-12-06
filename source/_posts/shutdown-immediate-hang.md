---
title: shutdown immediate 无响应
tags:
  - Oracle
id: '6524'
categories:
  - - Database
date: 2015-07-17 15:03:52
---


<!-- more -->
shutdown immediate有时候会长时间挂起(hang),一般是因为在等待某些进程关闭。
不要轻易尝试shutdown abort,shutdown abort之后启动时，需要进行实例恢复，容易出现问题。

据说startup force会中止当前数据库的运行，并开始重新正常的启动数据库，没试过，最好也不好尝试。

最佳的办法还是找到等待的进程，将其kill之后，再行shutdown immediate。 

References:
\[1\][oracle shutdown 没有反应](http://blog.chinaunix.net/uid-15866552-id-3419874.html) 
\[2\][Oracle shutdown immediate无法关闭数据库解决方法](http://www.cnblogs.com/kerrycode/p/3435581.html)
\[3\][oracle shutdown immediate 一直没反应解决方案](http://www.cnblogs.com/dba_xiaoqi/archive/2010/11/02/1867059.html)

===
**\[erq\]**