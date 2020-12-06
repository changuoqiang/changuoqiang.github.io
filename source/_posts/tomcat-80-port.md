---
title: 配置tomcat7使用http端口80
tags:
  - Debian
id: '3206'
categories:
  - - GNU/Linux
date: 2013-09-27 22:02:24
---

tomcat默认配置使用8080端口提供服务。tomcat主要是作为一个java容器或者说servlet容器存在，而apache,nginx,iis此类的web服务器通常占用http默认端口80。tomcat也可以作为web服务器使用，只是其性能和灵活性比apache,nginx等略差。若配置tomcat使用APR(Apache Portable Runtime)能极大的提升其web服务性能。
<!-- more -->
如果只使用tomcat,没有其他web服务器占用80端口，则可以更改配置使其使用80端口对外提供服务。因为非特权用户无法绑定1024以下的端口，因此还需要借助于authbind。

此处配置针对的是debian jessie上tomcat7而言。

首先，修改/etc/tomcat7/server.xml
\[xml\]
<Connector port="8080" protocol="HTTP/1.1"
\[/xml\]
更改为
\[xml\]
<Connector port="80" protocol="HTTP/1.1"
\[/xml\]

如果此时重新启动tomcat7,则/var/log/tomcat7/catalina.out会有如下输出：

SEVERE: Failed to initialize end point associated with ProtocolHandler \["http-bio-80"\]
java.net.BindException: Permission denied :80
...

这就是权限问题导致的。

其次，修改/etc/default/tomcat7,在文件最后添加
AUTHBIND=yes

然后
# /etc/init.d/tomcat7 restart

就可以用80端口访问tomcat了。