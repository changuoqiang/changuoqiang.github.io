---
title: 关于XSD文件
tags:
  - Java
id: '3332'
categories:
  - - java
date: 2013-10-12 21:56:25
---

XSD(XML Schema Definiton)文件是用来校验XML文件的，使其符合XSD制定的规范。XSD是DTD(Document Type Definition)的继任者。
<!-- more -->
比如spring-servlet.xml中的这段
\[xml\]
<beans xmlns="http://www.springframework.org/schema/beans"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:p="http://www.springframework.org/schema/p"
 xmlns:context="http://www.springframework.org/schema/context"
 xmlns:mvc="http://www.springframework.org/schema/mvc"
 xsi:schemaLocation="
 http://www.springframework.org/schema/beans
 http://www.springframework.org/schema/beans/spring-beans.xsd
 http://www.springframework.org/schema/context
 http://www.springframework.org/schema/context/spring-context.xsd
 http://www.springframework.org/schema/mvc
 http://www.springframework.org/schema/mvc/spring-mvc.xsd">
</beans>
\[/xml\]

虽然XSD在文件中都是以HTTP URL的方式出现的，但实际上并不会真正直接去互联网上获取这些文档，除非本地找不到这些文件。
比如
```js
http://www.springframework.org/schema/mvc/spring-mvc.xsd
```
在包spring-webmvc-3.2.4.RELEASE.jar里有个文件/META-INF/spring.schemas,其内容如下：
\[xml\]
http\\://www.springframework.org/schema/mvc/spring-mvc-3.0.xsd=org/springframework/web/servlet/config/spring-mvc-3.0.xsd
http\\://www.springframework.org/schema/mvc/spring-mvc-3.1.xsd=org/springframework/web/servlet/config/spring-mvc-3.1.xsd
http\\://www.springframework.org/schema/mvc/spring-mvc-3.2.xsd=org/springframework/web/servlet/config/spring-mvc-3.2.xsd
http\\://www.springframework.org/schema/mvc/spring-mvc.xsd=org/springframework/web/servlet/config/spring-mvc-3.2.xsd
\[/xml\]

可以看到其实际上被重定向到spring-webmvc-3.2.4.RELEASE.jar包里面的/org/springframework/web/servlet/config/spring-mvc-3.2.xsd文件上。因此直接从这个jar包读取就可以。

如果本地无法找到XSD文件，则会联网获取该XSD文件。

**\===
\[erq\]**