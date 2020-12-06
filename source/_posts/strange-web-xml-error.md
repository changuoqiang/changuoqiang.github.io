---
title: 奇怪的web.xml配置错误
tags:
  - Java
id: '3648'
categories:
  - - java
date: 2013-10-29 14:49:00
---

奇怪的web.xml配置错误
<!-- more -->
为org.springframework.web.servlet.DispatcherServlet设置参数contextConfigLocation自定义spring配置文件的位置，设置完后如下：
\[xml\]
<servlet>
 <servlet-name>spring</servlet-name>
 <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
 <load-on-startup>1</load-on-startup>
 <init-param>
 <param-name>contextConfigLocation</param-name>
 <param-value>/WEB-INF/spring-servlet.xml</param-value>
 </init-param>
</servlet>
\[/xml\]

直接部署运行没有问题，但是用eclipse打开就在第5行处报错：
```js
Description Resource Path Location Type
cvc-complex-type.2.4.a: Invalid content was found starting with element 'init-param'. 
One of '{"http://java.sun.com/xml/ns/javaee":enabled, "http://java.sun.com/xml/ns/javaee":async-supported, 
"http://java.sun.com/xml/ns/javaee":run-as, "http://java.sun.com/xml/ns/javaee":security-role-ref, 
"http://java.sun.com/xml/ns/javaee":multipart-config}' is expected.
```
将配置文件改为：
\[xml\]
<servlet>
 <servlet-name>spring</servlet-name>
 <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class> 
 <init-param>
 <param-name>contextConfigLocation</param-name>
 <param-value>/WEB-INF/spring-servlet.xml</param-value>
 </init-param>
 <load-on-startup>1</load-on-startup>
</servlet>
\[/xml\]
eclipse就不报怨了，init-param要紧跟servlet-class元素吗？没这规定吧！
是tomcat太宽松了还是eclipse太严格了呢？！

**\===
\[erq\]**