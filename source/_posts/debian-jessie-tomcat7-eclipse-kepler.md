---
title: Tomcat 7 on Debian Jessie  for Eclipse Kepler配置
tags:
  - Debian
  - Java
id: '3596'
categories:
  - - java
date: 2013-10-25 09:26:25
---

Debian系统tomcat 7官方安装包配置eclipse调式服务器。
<!-- more -->
Eclipse开发Dynamic Web Project需要添加一个web服务器来调式应用。有很多servlet容器可选，这里使用的是Tomcat 7。

**Tomcat多实例配置**

Eclipse配置tomcat服务器时，默认是创建了一个新的运行实例。也可以使用系统tomcat实例，或者自定义一个新的实例。

详见[tomcat多实例配置](https://openwares.net/linux/tomcat7_multiinstances_setup.html)。

**Eclipse配置tomcat7服务器**

_准备工作_

由于Debian按[FHS文件系统标准](http://www.pathname.com/fhs/)对tomcat包的拆分，虽然默认只有一个实例，$CATALINA_BASE和$CATALINA_HOME指向了不同的路径。为了应对Eclipse，需要做几个符号链接，让$CATALINA_HOME看起来像一个完整的tomcat实例。

```js
$ cd /usr/share/tomcat7
# ln -sf /var/lib/tomcat7/conf conf 
//或 # ln -sf /etc/tomcat7 conf
# ln -s /etc/tomcat7/policy.d/03catalina.policy conf/catalina.policy 
//或 cd conf; ln -sf policy.d/03catalina.policy catalina.policy
# ln -sf /var/log/tomcat7 log 
```

否则配置服务器时Eclipse会提示错误：
Could not load the Tomcat server configuration at /usr/share/tomcat7/conf. The configuration may be corrupt or incomplete.
/usr/share/tomcat7/conf/catalina.policy (No such file or directory)

还要将运行Eclipse的当前用户加入到tomcat7用户组，然后注销重新登录。

# adduser ${your_username} tomcat7
$ logout

因为配置服务器时Eclipse要读取tomcat-users.xml文件，否则会有错误提示：
Could not load the Tomcat server configuration at /usr/share/tomcat7/conf. The configuration may be corrupt or incomplete.
/usr/share/tomcat7/conf/tomcat-users.xml (Permission denied)

_配置调式服务器_

打开eclipse,Window -> Preference -> Server -> Runtime Environments -> Add 选择Apache Tomcat 7.0 Server,
选择下一步，Tomcat installation directory输入/usr/share/tomcat7,JRE选择java-7-openjdk-amd64,最后finish。

如果Add服务器这个环节，Server name字段为空，且无法输入，也无法点击下一步，可以这样解决：

1.  关闭eclipse
2.  {workspace-directory}/.metadata/.plugins/org.eclipse.core.runtime/.settings目录下，删除这个两个文件
    org.eclipse.wst.server.core.prefs
    org.eclipse.jst.server.tomcat.core.prefs
    

关闭Eclipse,进入workspace工作目录下配置好的服务器的配置目录

$ cd ~/workspace/Servers/Tomcat v7.0 Server at localhost-config

修改server.xml,将其控制端口改为8006，只要不与其他运行实例冲突即可。否则会出现错误提示：

Several ports (8005, 80) required by Tomcat v7.0 Server at localhost are already in use. The server may already be running in another process, or a system process may be using the port. To start this server you will need to stop the other process or change the port number(s).

\[xml\]
<Server port="8006" shutdown="SHUTDOWN">
\[/xml\]

将连接端口更改为8080或其他高于1024的端口号：
\[xml\] 
 <Connector URIEncoding="UTF-8" connectionTimeout="20000" port="8080" protocol="HTTP/1.1" redirectPort="8443"/>
\[/xml\]

Eclipse貌似不能使用Authbind，所以即使没有进程占用80端口，也无法启动调试服务器，1024以上的端口则没问题。

这样Eclipse就可以使用tomcat7作为调试服务器正常运行了。

**update(01/15/2016)：服务器配置目录**

服务器的配置文件在~/workspace/.metadata/.plugins/org.eclipse.wst.server.core目录下，删除服务器时，如果没有其他服务器时，可以同时将此目录删除,这样不会有残留。
目录下的server.xml文件中可以修改启动超时时间start-timeout。

而tomcat的配置文件在~/workspace/Servers/Tomcat v8.0 Server at localhost-config目录下，与单独启动的tomcat配置一样。

参考：

[Debian 7 Wheezy 安装 Eclipse](http://www.rockbb.com/blog/?p=349)