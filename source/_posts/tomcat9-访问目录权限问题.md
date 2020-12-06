---
title: tomcat9 访问目录权限问题
tags:
  - Debian
id: '9060'
categories:
  - - GNU/Linux
  - - java
date: 2019-11-13 21:57:27
---


<!-- more -->
tomcat9在systemd的沙箱中运行，默认只能访问一下路径：
```js
- /var/lib/tomcat9/conf/Catalina (actually /etc/tomcat9/Catalina)
- /var/lib/tomcat9/logs (actually /var/log/tomcat9)
- /var/lib/tomcat9/webapps
- /var/lib/tomcat9/work (actually /var/cache/tomcat9)
```
如果需要访问其他路径，需要覆盖默认的service设置，添加文件/etc/systemd/system/tomcat9.service.d/override.conf，其内容如下:
```js
\[Service\]
 ReadWritePaths=/path/to/the/directory/
```
然后
```js
$ sudo systemctl daemon-reload
$ sudo systemctl restart tomcat9
```

References:
\[1\][README.Debian](https://salsa.debian.org/java-team/tomcat9/blob/master/debian/README.Debian)