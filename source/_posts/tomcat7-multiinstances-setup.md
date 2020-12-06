---
title: Debian系统Tomcat 7多实例配置
tags:
  - Debian
id: '3602'
categories:
  - - GNU/Linux
date: 2013-10-25 14:42:05
---

一个服务器上一个tomcat安装，可以运行多个实例，多个实例有自己单独的配置。
<!-- more -->
tomcat支持一个安装运行多个实例。$CATALINA_HOME表示tomcat安装目录，$CATALINA_BASE表示实例所在的目录。
debian遵循[FHS](http://www.pathname.com/fhs/)标准，所以将tomcat拆分安装到符合FHS标准的目录。debian官方包tomcat7的$CATALINA_HOME指向/usr/share/tomcat7，默认安装实例的$CATALINA_BASE指向/var/lib/tomcat7。配置文件理所当然的在/etc/tomcat7，配置默认值在/etc/default/tomcat7。

默认情况下，如果没有配置多实例，$CATALINA_BASE和$CATALINA_HOME指向同一个路径，当然Debian做了拆分，就算单实例，二者也指向不同的路径。

当运行单独的多个实例时，tomcat文件应做如下拆分：

每个单独实例$CATALINA_BASE中包含以下目录和文件：

*   bin目录: setenv.sh (*nix) 或者 setenv.bat (Windows),tomcat-juli.jar
*   conf目录：服务器配置文件包括server.xml等
*   lib目录：实例共享的库和类文件
*   logs目录：日志和输出文件
*   webapps目录：放置自动加载的应用程序
*   temp目录：临时文件目录

唯一的Tomcat安装$CATALINA_HOME包含以下目录和文件：

*   bin目录：启动和关闭脚本。如果单独实例的bin没有包含setenv.sh (*nix)或setenv.bat (Windows)、tomcat-juli.jar，这些文件也可以放在此处。
*   lib目录：所有实例共享的库和类文件
*   endorsed目录：用于覆盖JRE标准库的库文件。默认这个目录是空的。

因为debian使用init启动脚本来管理tomcat7，所以并没有使用setenv.sh这个文件。所以一个最小的单独运行实例只要有一个conf目录和完整的配置文件即可,
将tomcat-juli.jar放到$CATALINA_HOME/bin目录下。可以拷贝$CATALINA_HOME/conf目录，然后做相应修改即可。

每一个实例必须使用单独的控制端口和连接端口，各个实例不能冲突。
在由tomcat处理的XML配置文件中，可以用${catalina.home}引用$CATALINA_HOME，用${catalina.base}引用$CATALINA_BASE。

比如，tomcat标准的web管理应用可以安装在$CATALINA_HOME/webapps/manager,然后在实例中按如下方式加载：

1.  $ cp ${CATALINA_HOME}/webapps/manager/META-INF/context.xml ${CATALINA_BASE}/conf/Catalina/localhost/manager.xml
2.  在配置文件中添加:
    \[xml\]
    <Context docBase="${catalina.home}/webapps/manager"
     antiResourceLocking="false" privileged="true" >
     <Valve className="org.apache.catalina.valves.RemoteAddrValve"
     allow="127\\.0\\.0\\.1" />
     </Context>
    \[/xml\]
    

参考：
[Advanced Configuration - Multiple Tomcat Instances](http://tomcat.apache.org/tomcat-7.0-doc/RUNNING.txt)