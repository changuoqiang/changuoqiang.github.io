---
title: jConsole远程监控tomcat8
tags:
  - Debian
id: '6489'
categories:
  - - GNU/Linux
  - - java
date: 2015-06-13 15:44:14
---

jConsole是JDK自带的性能监控工具。
<!-- more -->
使用jConsole监控远程tomcat8时，需要为远程tomcat8打开jmx远程管理功能。
在/etc/default/tomcat8文件中添加如下选项:
```js
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8090 -Dcom.sun.management.jmxremote.ssl=false"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=false"
```

打开jmxremote,设置其访问端口为8090,不使用ssl安全连接，不启用认证。

这样，直接在jConsole的Remote Access中填入：ip:8090,无需输入用户名和密码直接连接即可。

**用户认证**
如需开启用户认证，从jdk目录拷贝两个文件到tomcat8配置目录
```js
$ cd /etc/tomcat8
# cp ${JAVA_HOME}/jre/lib/management/jmxremote.access .
# cp ${JAVA_HOME}/jre/lib/management/jmxremote.password.template jmxremote.password
```
编辑jmxremote.password文件，去掉monitorRole行前的#号, 开启monitorRole用户，并为其设置新的密码，这是个只读的用户。
安全起见不要启用controlRole用户。

设置jmxremote.password的属主和存取权限：
```js
# chown tomcat8:tomcat8 jmxremote.password
# chmod 600 jmxremote.password
```

最后在/etc/default/tomcat8中添加如下选项:
```js
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.authenticate=true"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.access.file=${CATALINA_BASE}/conf/jmxremote.access"
JAVA_OPTS="${JAVA_OPTS} -Dcom.sun.management.jmxremote.password.file=${CATALINA_BASE}/conf/jmxremote.password"
```
* jmxremote.authenticate由false更改为true,或者删除掉此语句，因为默认是要用户认证的。

重新启动tomcat8后，jconsole连接时提供对应的用户名和密码即可。

**\===
\[erq\]**