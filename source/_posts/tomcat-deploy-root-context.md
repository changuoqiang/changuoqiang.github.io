---
title: Tomcat将应用程序部署到主机根目录
tags:
  - Debian
id: '4211'
categories:
  - - GNU/Linux
date: 2013-11-19 10:00:41
---


<!-- more -->
Tomcat支持多虚拟主机，每个虚拟主机又可以有多个虚拟目录,应用程序可以部署到虚拟目录，也可以直接部署到虚拟主机的根目录

**添加虚拟主机**

\[xml\]
<Engine name="Catalina" defaultHost="localhost">
 <Host name="openwares.net" appBase="/path/to/webapps"
 unpackWARs="true" autoDeploy="true">

 <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
 prefix="openwares_access_log." suffix=".txt"
 pattern="%h %l %u %t &quot;%r&quot; %s %b" />

 </Host>
</Engine>
\[/xml\]

主机的基本目录为/path/to/webapps，默认情况下,该目录下的ROOT目录为主机根虚拟目录，其他命名目录为相应名字的虚拟目录。
也就是说，访问http://openwares.net/会访问到/path/to/webapps/ROOT目录，而访问http://openwares.net/foo
则会访问到/path/to/webapps/foo目录。

如果是部署war文件，则ROOT.war对应根虚拟目录/，而foo.war则对应/foo虚拟目录

**部署应用程序到根虚拟目录**

最简单的办法就是，直接将应用程序部署到虚拟主机appBase目录下的ROOT目录，如果是部署war包则将其命名为ROOT.war放到appBase目录下

还有一个方法是为应用程序在虚拟主机内添加一个Context,有两个选择：

*   直接修改server.xml配置文件
在虚拟主机配置下面添加Context
\[xml\]
<Host name="openwares.net" appBase="/path/to/webapps"
 unpackWARs="true" autoDeploy="true">
 <Context path="" docBase="/path/to/webapps"></Context>
</Host>
\[/xml\]
path留空，则表示根虚拟路径/映射到/path/to/webapps目录。如果path="/foo",则/foo虚拟路径映射到/path/to/webapps
*   在Catalina/主机名/目录下添加Context配置文件
Catalina/openwares.net/ROOT.xml
\[xml\]
<?xml version="1.0" encoding="utf-8"?>
<Context path="" docBase="/path/to/webapps"></Context>
\[/xml\]

注意xml配置文件的命名，ROOT.xml表示配置的虚拟路径为根虚拟路径，配置文件里面的path和上面一样要置空。
如果配置访问应用程序的虚拟路径为/foo,则配置文件名为foo.xml
Catalina/openwares.net/foo.xml
\[xml\]
<?xml version="1.0" encoding="utf-8"?>
<Context path="/foo" docBase="/path/to/webapps"></Context>
\[/xml\]

第二种方法更好一些

**注意**：使用context配置根虚拟路径时，host的docBase一定不要与Context的docBase指向同一个目录，host默认的ROOT Context优先级比较高，会使用户设置的ROOT Context失效。