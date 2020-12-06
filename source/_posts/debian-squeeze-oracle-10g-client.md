---
title: debian 6.0 squeeze 安装oracle 10g 客户端
tags:
  - Debian
  - Oracle
id: '978'
categories:
  - - Database
  - - GNU/Linux
date: 2011-02-15 19:36:16
---

oracle为debian/ubuntu用户提供了一个apt源，来提供oracle 10g express edition版本的安装
<!-- more -->
/etc/apt/source.list增加一行
deb http://oss.oracle.com/debian unstable main non-free

然后sudo apt-get update,sudo apt-get install oracle-xe-client
安装成功后，在用户主目录下的.bashrc文件里面增加以设置相关的环境变量

export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/client
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH;
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin

TNS_ADMIN变量用来指定tnsnames.ora文件所在的位置,在tnsnames.ora里面设定好服务器的相关信息就可以连接oracle服务器进行相关操作了。