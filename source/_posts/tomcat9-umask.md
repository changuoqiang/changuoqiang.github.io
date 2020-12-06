---
title: tomcat9 默认文件/目录创建权限
tags:
  - Debian
id: '9062'
categories:
  - - GNU/Linux
  - - java
date: 2019-11-14 10:31:12
---


<!-- more -->
tomcat9默认的文件创建权限UMASK更改为0027,创建的文件/目录其他用户是没有权限访问的,而nginx worker process默认使用nobody用户来运行,因此也无法访问tomcat9创建的文件

**更改tomcat9的UMASK**

/usr/share/tomcat9/bin目录下如果没有setenv.sh,添加此文件,内容如下:
```js
UMASK=0022
```

使此文件可执行:
```js
$ sudo chmod +x setenv.sh
```

重新启动tomcat9
```js
$ sudo systemctl restart tomcat9
```