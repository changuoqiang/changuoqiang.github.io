---
title: 内存溢出导致jenkins自动部署到tomcat失败
tags:
  - Java
id: '6023'
categories:
  - - java
date: 2014-11-05 16:09:40
---


<!-- more -->
jenkins自动部署war到tomcat 7应用服务器时很不稳定,经常出现错误:

```js
ERROR: Publisher hudson.plugins.deploy.DeployPublisher aborted due to exception
org.codehaus.cargo.container.ContainerException: Failed to deploy \[/var/lib/jenkins/jobs/devel_auto_build_deploy/workspace/build/libs/reis.war\]
...
Caused by: org.codehaus.cargo.container.tomcat.internal.TomcatManagerException: FAIL - Encountered exception javax.management.RuntimeErrorException: Error invoking method check
...
org.codehaus.cargo.container.tomcat.internal.TomcatManagerException: FAIL - Encountered exception javax.management.RuntimeErrorException: Error invoking method check
...
```

tomcat日志可以看到如下异常:
堆空间内存不足
```js
java.lang.OutOfMemoryError: Java heap space
```

永久代内存不足
```js
SEVERE: Exception invoking method check
java.lang.OutOfMemoryError: PermGen space
...
Exception in thread "http-bio-8080-exec-38" java.lang.OutOfMemoryError: PermGen space
OpenJDK 64-Bit Server VM warning: Exception java.lang.OutOfMemoryError occurred dispatching signal SIGTERM to handler- the VM may need to be forcibly terminated
```

出现此问题的原因是tomcat默认配置的堆和非堆内存都太小了，需要调整如下JVM内存配置参数:

*   \-Xms
初始堆内存大小
*   \-Xmx
最大堆内存大,一般设置-Xms与-Xmx一样大小,根据应用类型和物理内存大小来决定二者的大小
*   \-Xmn或者-XX:NewSize
堆内存中年轻代的大小
*   \-XX:PermSize
永久代内存的初始大小
*   \-XX:MaxPermSize
永久代内存的最大值

一般设置这几个参数也就够了,debian系统上tomcat 7 设置JVM的内存参数要在配置文件/etc/default/tomcat7中的JAVA_OPTS参数中设置。

一个web app,服务器物理内存16G,其设置如下:
```js
JAVA_OPTS="-Djava.awt.headless=true -Xmx5120m -Xms5120m -Xmn1024m -XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:+UseConcMarkSweepGC"
```

References:
\[1\][JVM系列一：JVM内存组成及分配](http://www.cnblogs.com/redcreen/archive/2011/05/04/2036387.html)
\[2\][JVM系列三:JVM参数设置、分析](http://www.cnblogs.com/redcreen/archive/2011/05/04/2037057.html)
\[3\][java.lang.OutOfMemoryError: Permgen space](https://plumbr.eu/outofmemoryerror/permgen-space)

**\===
\[erq\]**