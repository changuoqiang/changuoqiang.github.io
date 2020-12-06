---
title: 'tomcat 7,spring 3,mybatis 3 配置log4j日志组件'
tags:
  - Java
id: '3361'
categories:
  - - java
date: 2013-10-16 19:47:03
---

tomcat,spring,mybatis都内置通用的日志输出框架，可以配合各种具体的日志组件实现来输出日志，而log4j是最常用的日志组件。
<!-- more -->
tomcat和spring都使用JCL(Jakarta Commons Logging)日志框架，而mybatis貌似是自己实现的日志框架，三者都可以使用常见的日志组件来输出日志。

**tomcat 7**

tomcat使用JCL日志框架，默认配置使用JDK提供的JUL(java.util.logging)输出tomcat内部日志。也可以[配置使用log4j来输出tomcat内部日志](http://tomcat.apache.org/tomcat-7.0-doc/logging.html)。
注意这里是配置tomcat自身日志的输出，在tomcat上运行的应用程序可以单独配置日志输出组件比如log4j，二者互不影响。

在tomcat上运行的应用程序可以使用以下方式来输出日志：

*   使用JAVA API java.util.logging

*   使用servlet规范提供的API javax.servlet.ServletContext.log(...)

*   使用自己选择的日志组件，比如使用log4j

tomcat控制台输出

当在unix like系统上运行tomcat时，控制台输出被重定向到一个名字可配置的文件中，通常这个文件为catalina.out。因此所有写到System.err/out的输出都被写入这个文件中。包括：

*   使用java.lang.ThreadGroup.uncaughtException(..)输出的未捕获异常

*   线程dump

*   应用程序的System.out/System.err输出，这是不推荐的方式，尽量不要使用，推荐使用日志输出组件

**spring 3**

spring 3 使用JCL日志框架，可以动态发现可以使用的日志组件，只要将日志组件的jar包扔到classpath路径里面就可以了，如果不使用其他日志组件，则spring 3使用java.util.logging来输出日志。

不过[spring工程更倾向于使用SLF4J](http://spring.io/blog/2009/12/04/logging-dependencies-in-spring)，历史原因选择了JCL框架。

spring配置使用log4j也比较简单，只要将log4j-x.x.x.jar包放入classpath，然后提供一个配置文件log4j.properties放置在classpath根路径下，比如WEB-INF/classes目录下即可。

spring提供了一个listener来配置log4j,可以设置配置文件路径等相关设置，在web.xml中配置此listener：
\[xml\]
 <!-- web应用程序根路径映射，如果不设置此参数，默认映射到变量webapp.root，log4j.propertiesw文件中
可以使用${webapp.root}来引用web应用程序根路径 -->
 <context-param> 
 <param-name>webAppRootKey</param-name> 
 <param-value>webapp.root</param-value> 
 </context-param>
 <!-- log4j.properties配置文件路径 -->
 <context-param> 
 <param-name>log4jConfigLocation</param-name> 
 <param-value>WEB-INF/log4j.properties</param-value> 
 </context-param> 
 <context-param> 
 <param-name>log4jRefreshInterval</param-name> 
 <param-value>3000</param-value> 
 </context-param>
 <listener> 
 <listener-class>org.springframework.web.util.Log4jConfigListener</listener-class> 
 </listener> 
\[/xml\]

这里将log4j.properties配置到WEB-INF目录下，方便统一管理应用程序的配置文件

**mybatis 3**

mybatis 3 也支持[使用log4j日志组件](http://mybatis.github.io/mybatis-3/logging.html)，在spring mybatis集成应用程序中，mybatis直接使用spring的log4j设置即可，只要将mybaits相关的日志配置写入共用的配置文件log4j.properties即可。比如对映射器日志设置如下：

log4j.logger.net.openwares.test.mapper = TRACE
甚至可以对映射器里面映射的语句设置日志数据级别
log4j.logger.net.openwares.test.mapper.selectXXX = TRACE

对于独立使用的mybatis,需要在mybatis-config.xml文件中添加：
\[xml\]
<configuration>
 <settings>
 ...
 <setting name="logImpl" value="LOG4J"/>
 ...
 </settings>
</configuration>
\[/xml\]
然后将log4j jar包和log4j.properties文件放入classpath。

**log4j简单配置**

\[xml\]
#Global configuration
log4j.rootLogger = DEBUG, stdout, logfile

log4j.appender.stdout = org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern = %5p \[%t\] - %m%n

log4j.appender.logfile = org.apache.log4j.FileAppender
log4j.appender.logfile.File = ${webapp.root}/WEB-INF/logs/debug.log
log4j.appender.logfile.layout = org.apache.log4j.PatternLayout
log4j.appender.logfile.layout.ConversionPattern = %5p \[%t\] - %m%n

#Spring config
#log4j.logger.org.springframewaork = DEBUG

#Mybatis config
#log4j.logger.org.apache.ibatis = DEBUG
log4j.logger.net.openwares.test.mapper = TRACE

#JDBC config
#log4j.logger.java.sql.Connection = DEBUG 
#log4j.logger.java.sql.Statement = DEBUG 
#log4j.logger.java.sql.PreparedStatement = DEBUG 
#log4j.logger.java.sql.ResultSet = DEBUG

\[/xml\]

log4j的主要概念就是logger,appender,layout还有logging level。
log4j的详细用法参见[官方文档](http://logging.apache.org/log4j/1.2/manual.html)。

**log4j简单使用**
\[java\]
import org.apache.log4j.Logger;

public class helloLog {
 private static Logger logger = Logger.getLogger(helloLog.class.getName());
 public void MethodXXX(){
 logger.debug("xxx");
 logger.info("xxx");
 ...
 }
}
\[/java\]