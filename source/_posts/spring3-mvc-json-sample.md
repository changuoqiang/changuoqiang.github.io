---
title: Spring 3 MVC JSON Sample
tags:
  - Java
id: '3310'
categories:
  - - java
  - - javascript
date: 2013-10-12 20:27:09
---

Spring Framework 3 对 JSON的支持很不错。
<!-- more -->
这个例子程序和以前一样，前端为html、javascript,这次后端改为使用spring framework 3.2.4,前后端通过ajax交换json数据，这个例子比只使用servlet 3更简洁，当然配置更复杂一些。

完整的代码和配置[下载](/downloads/springjson.war)。

**配置**

要使用spring framework,首先要在WEB-INF/web.xml中配置spring的DispatcherServlet，由其来接管映射的URL请求，之后就进入spring framework的处理流程。
web.xml
\[xml\]
 <servlet>
 <servlet-name>spring</servlet-name>
 <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
 <load-on-startup>1</load-on-startup>
 </servlet>
 <servlet-mapping>
 <servlet-name>spring</servlet-name>
 <url-pattern>/</url-pattern>
 </servlet-mapping>
\[/xml\]

如果不配置的DispatcherServlet的初始化参数contextConfigLocation，则spring framework会读取WEB-INF/<servlet-name>-servlet.xml作为其context参数文件，在这个配置里，这个文件为spring-servlet.xml,其内容如下：

\[xml\]
<?xml version="1.0" encoding="UTF-8"?>
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

 <context:component-scan base-package="net.openwares.test" />
 <mvc:default-servlet-handler />
 <mvc:annotation-driven />
</beans>
\[/xml\]

其中
\[xml\]<context:component-scan base-package="net.openwares.test" />\[/xml\]
表示从包net.openwares.test里面自动扫描使用注解标示的组件，比如@RqeustMapping,@RequestBody等注解的组件。
不过这个地方存在一点问题，spring对jar包的扫描有特殊的要求，用jar -cvf 命令创建的jar包,spring扫描不到其中的组件，而不打包使用层次文件路径则没有问题，这里的路径是WEB-INF/classes/net/openwares/test/。使用[eclipse打包时有个选项add directory entries](http://kyfxbl.iteye.com/blog/1675368)，勾选这个选项打出来的包就可以被spring扫描到。现在还没发现如何用jar命令打包才可以让spring扫描到。

\[xml\]<mvc:default-servlet-handler />\[/xml\]
可以将spring framework不处理的其他资源请求路由到容器的default servlet,这样容器就可以继续处理这些请求，而不是被spring framework拦截掉。

\[xml\]<mvc:annotation-driven />\[/xml\]
支持注解，比如@RequestMapping,@PathVariable等。

对于这个例子，这个配置就够了。现在spring framework朝着零配置方向又进一步，在servlet 3.0+环境下，也可以不用xml而使用java代码来完成如上配置。

**代码**

前端index.html只是改一下请求的url就可以了

var url = "/springjson/ajaxcalc";


后端SpringJson.java代码：
\[java\]
package net.openwares.test;

import java.io.Writer;
import java.io.IOException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;

@Component
class Attender {
 private int augend, addend;
 
 public Attender(){}

 public int getAugend(){
 return augend;
 }
 public void setAugend(int augend){
 this.augend = augend;
 }

 public int getAddend(){
 return addend;
 }
 public void setAddend(int addend){
 this.addend = addend;
 }
}

@Component
class Outcome {
 private int result;

 public Outcome(){}

 public int getResult(){
 return result;
 }
 public void setResult(int result){
 this.result = result;
 }
}

@Controller
public class SpringJson {

 @Autowired
 private Outcome outcome;

 @RequestMapping("/ajaxcalc")
 public @ResponseBody Outcome getResult(@RequestBody Attender attender){

 outcome.setResult(attender.getAugend() + attender.getAddend());
 return outcome;
 }
}
\[/java\]

**说明**

只要前端ajax请求将Content-Type设置为application/json,则spring会自动的将请求内容映射到@RequestBody修饰的VO对象，
将@ResponseBody修饰的VO对象转换为返回的json数据。spring使用HttpMessageConverters来转换数据，
支持json,xml等多种数据类型，还以自定义转换接口。中间如有数据类型转换可能会出现转换问题。

打包为spingjson.war,部署后访问URL
http://127.0.0.1/springjson/ajaxcalc

**依赖**

spring使用jackson来操作json数据，因此需要下载jackson jar包，spring 3.2.4支持jackson 2,直接下载[最新的jackson包](http://wiki.fasterxml.com/JacksonDownload)丢到lib目录即可，当前为这个三个文件：
jackson-core-2.2.3.jar
jackson-annotations-2.2.3
jackson-databind-2.2.3.jar

spring使用[apache commons logging](http://commons.apache.org/proper/commons-logging/)组件来输出日志，因此需要依赖包
commons-logging-1.1.3.jar

spring framework现在拆分了jar,不再提供单一的一个大jar包。此样例程序需要依赖以下spring包：
spring-core-3.2.4.RELEASE.jar //核心包，所有的spring程序都需要
spring-beans-3.2.4.RELEASE.jar //bean管理，依赖注入等核心功能
spring-context-3.2.4.RELEASE.jar //基础支持包
spring-expression-3.2.4.RELEASE.jar //此包必须，否则spring无法加载context配置文件，从而无法完成初始化
spring-web-3.2.4.RELEASE.jar //servlet支持
spring-webmvc-3.2.4.RELEASE.jar //MVC支持

**后记**
这个例子和以前的几个例子都是完全用vim编辑，用javac编译，用jar打包的。虽然只是极其简单的小例子，仍然感觉十分繁琐，看来研究下eclipse还是有必要的。

参考：[Spring 3.2.4 MVC文档](http://docs.spring.io/spring/docs/3.2.4.RELEASE/spring-framework-reference/html/mvc.html)
 **===
\[erq\]**