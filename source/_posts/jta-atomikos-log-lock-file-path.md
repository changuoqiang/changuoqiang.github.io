---
title: JTA开源实现atomikos日志和锁文件路径权限问题
tags:
  - Java
id: '6589'
categories:
  - - java
date: 2015-08-21 17:07:23
---


<!-- more -->
应用程序启动时有如下错误提示：
```js
ERROR \[localhost-startStop-1\] - Context initialization failed
org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'atomikosUserTransaction' defined in ServletContext resource \[/WEB-INF/conf/spring-servlet.xml.bak\]: Error setting property values; nested exception is org.springframework.beans.PropertyBatchUpdateException; nested PropertyAccessExceptions (1) are:
PropertyAccessException 1: org.springframework.beans.MethodInvocationException: Property 'transactionTimeout' threw exception; nested exception is com.atomikos.icatch.SysException: Error in init(): /var/lib/tomcat8/./tm.out.lck
 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.applyPropertyValues(AbstractAutowireCapableBeanFactory.java: 1506)
 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1214)
 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:537)
 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:476)
 at org.springframework.beans.factory.support.AbstractBeanFactory$1.getObject(AbstractBeanFactory.java:303)
 at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:230)
 at org.springframework.beans.factory.support.AbstractBeanFactory.doGetBean(AbstractBeanFactory.java:299)
 at org.springframework.beans.factory.support.AbstractBeanFactory.getBean(AbstractBeanFactory.java:194)
 at org.springframework.beans.factory.support.DefaultListableBeanFactory.preInstantiateSingletons(DefaultListableBeanFactory.java:762)
 at org.springframework.context.support.AbstractApplicationContext.finishBeanFactoryInitialization(AbstractApplicationContext.java:757)
 at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:480)
 at org.springframework.web.servlet.FrameworkServlet.configureAndRefreshWebApplicationContext(FrameworkServlet.java:663)
 at org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:629)
 at org.springframework.web.servlet.FrameworkServlet.createWebApplicationContext(FrameworkServlet.java:677)
 at org.springframework.web.servlet.FrameworkServlet.initWebApplicationContext(FrameworkServlet.java:548)
 at org.springframework.web.servlet.FrameworkServlet.initServletBean(FrameworkServlet.java:489)
 at org.springframework.web.servlet.HttpServletBean.init(HttpServletBean.java:136)
 at javax.servlet.GenericServlet.init(GenericServlet.java:158)
 at org.apache.catalina.core.StandardWrapper.initServlet(StandardWrapper.java:1241)
 at org.apache.catalina.core.StandardWrapper.loadServlet(StandardWrapper.java:1154)
 at org.apache.catalina.core.StandardWrapper.load(StandardWrapper.java:1041)
 at org.apache.catalina.core.StandardContext.loadOnStartup(StandardContext.java:4969)
 at org.apache.catalina.core.StandardContext.startInternal(StandardContext.java:5255)
 at org.apache.catalina.util.LifecycleBase.start(LifecycleBase.java:150)
 at org.apache.catalina.core.ContainerBase.addChildInternal(ContainerBase.java:724)
 at org.apache.catalina.core.ContainerBase.addChild(ContainerBase.java:700)
 at org.apache.catalina.core.StandardHost.addChild(StandardHost.java:714)
 at org.apache.catalina.startup.HostConfig.deployWAR(HostConfig.java:919)
 at org.apache.catalina.startup.HostConfig$DeployWar.run(HostConfig.java:1703)
 at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
 at java.util.concurrent.FutureTask.run(FutureTask.java:266)
 at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)
 at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)
 at java.lang.Thread.run(Thread.java:745)
Caused by: org.springframework.beans.PropertyBatchUpdateException; nested PropertyAccessExceptions (1) are:
PropertyAccessException 1: org.springframework.beans.MethodInvocationException: Property 'transactionTimeout' threw exception; nested exception is com.atomikos.icatch.SysException: Error in init(): /var/lib/tomcat8/./tm.out.lck
 at org.springframework.beans.AbstractPropertyAccessor.setPropertyValues(AbstractPropertyAccessor.java:121)
 at org.springframework.beans.AbstractPropertyAccessor.setPropertyValues(AbstractPropertyAccessor.java:75)
 at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.applyPropertyValues(AbstractAutowireCapableBeanFactory.java: 1502)
 ... 33 more
```

这是因为默认情况下,atomikos要在/var/lib/tomcat8目录下生成其日志和锁文件，而/var/lib/tomcat8文件夹的所有者和组都是root,无法写入，所以初始化失败。

解决方法有二，最简单粗暴的就是将/var/lib/tomcat8目录的所有者和组都更改为tomcat8.

另一个方法是classpath中添加atomikos配置文件，将其输出文件目录配置到tomcat8有权限写入的目录中，比如/var/log/tomcat8
```js
com.atomikos.icatch.service=com.atomikos.icatch.standalone.UserTransactionServiceFactory
com.atomikos.icatch.log_base_name = jdbc
com.atomikos.icatch.log_base_dir = /var/log/tomcat8 # 日志文件输出目录
com.atomikos.icatch.output_dir = /var/log/tomcat8 # 文件输出目录
com.atomikos.icatch.tm_unique_name = com.atomikos.spring.jdbc.tm
com.atomikos.icatch.serializable_logging=false
com.atomikos.icatch.max_timeout=2000000
```

**\===
\[erq\]**