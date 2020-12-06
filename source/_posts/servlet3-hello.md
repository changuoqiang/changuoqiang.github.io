---
title: java servlet 3 入门
tags:
  - Java
id: '3217'
categories:
  - - java
date: 2013-09-30 10:48:41
---

web开发没怎么搞过，还是看好java ee在web开发领域的实力。servlet 3 来了，写个简单的hello world程序，熟悉熟悉。
<!-- more -->
**开发环境：**
linux debian jessie + openjdk 7 + tomcat 7,具体安装配置不详述，安装debian官方源里的包即可，简单快捷。

**目录结构**
web程序的根目录为hello,其目录结构如下：
\[java\]
hello
-- common
-- css
-- html
-- images
-- js
-- src
 \`-- HelloServlet3.java
\`-- WEB-INF
 -- classes
 \`-- HelloServlet3.class
 -- lib
 \`-- web.xml
\[/java\]

**源代码**
HelloServlet3.java
\[java\]
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name="helloServlet3",urlPatterns={"/"},loadOnStartup=1)
public class HelloServlet3 extends HttpServlet{
 @Override
 protected void doGet(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{

 response.setContentType("text/plain");
 response.getWriter().write("hello servlet 3!");
 }

 @Override
 protected void doPost(HttpServletRequest request,HttpServletResponse response)
 throws ServletException,IOException{

 doGet(request,response);
 }
}

\[/java\]

**部署描述符**
servlet 3支持使用注解来部署servlet，因此无需再用web.xml来部署servlet。此web应用的web.xml部署描述符只是一个空的骨架，内容如下：
\[xml\]
<?xml version="1.0" encoding="UTF-8" ?>

<web-app 
 xmlns="http://java.sun.com/xml/ns/javaee"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
 version="3.0">

</web-app>
\[/xml\]

此例程使用@WebServlet注解来部署HelloServlet,与在web.xml中使用如下配置部署是一样的。
\[java\]
 <servlet>
 <servlet-name>helloServlet3</servlet-name>
 <servlet-class>HelloServlet3</servlet-class>
 <load-on-startup>1</load-on-startup> 
</servlet>
<servlet-mapping>
 <servlet-name>helloServlet3</servlet-name>
 <url-pattern>/</url-pattern>
</servlet-mapping>
\[/java\]

**编译打包**

编译
$ javac -classpath /usr/share/java/servlet-api-3.0.jar HelloServlet3.java

编译完成后生成class文件HelloServlet3.class,将其拷贝到WEB-INF/classes/目录下

打包
切换到web应用程序根目录hello，然后执行
$ jar cvf hello.war *

added manifest
adding: common/(in = 0) (out= 0)(stored 0%)
adding: css/(in = 0) (out= 0)(stored 0%)
adding: html/(in = 0) (out= 0)(stored 0%)
adding: images/(in = 0) (out= 0)(stored 0%)
adding: js/(in = 0) (out= 0)(stored 0%)
adding: src/(in = 0) (out= 0)(stored 0%)
adding: src/HelloServlet3.class(in = 923) (out= 532)(deflated 42%)
adding: src/HelloServlet3.java(in = 796) (out= 292)(deflated 63%)
adding: WEB-INF/(in = 0) (out= 0)(stored 0%)
adding: WEB-INF/lib/(in = 0) (out= 0)(stored 0%)
adding: WEB-INF/web.xml(in = 295) (out= 168)(deflated 43%)
adding: WEB-INF/classes/(in = 0) (out= 0)(stored 0%)
adding: WEB-INF/classes/HelloServlet3.class(in = 923) (out= 532)(deflated 42%)

**部署访问**
将hello.war拷贝到tomcat7默认的虚拟主机目录下

#cp hello.war /var/lib/tomcat7/webapps/

默认配置下hello.war会被展开到一个文件夹hello，这是因为/etc/tomcat7/server.xml里面默认配置的host的unpackWARs属性为true。

用浏览器打开地址http://127.0.0.1/hello,浏览器会输出：

hello servlet 3!