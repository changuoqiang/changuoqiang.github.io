---
title: Gradle SSH Plugin reject HostKey问题
tags:
  - Debian
id: '6852'
categories:
  - - GNU/Linux
date: 2015-11-04 16:31:47
---


<!-- more -->
gradle ssh plugin使用的jsch library并不能识别debian系统~/.ssh/known_hosts里面的hostkey格式，从而报reject hostkey错误。

使用如下命令获取主机的hostkey
```js
$ ssh-keyscan -t rsa -p port host_ip_or_name
```
将输出的主机key指纹添加到~/.ssh/known_hosts即可。

References:
\[1\][Remote tomcat deployment with Gradle](http://sbzhouhao.net/2015/01/21/Remote-tomcat-deployment-with-Gradle/)
\[2\][Solution for com.jcraft.jsch.JSchException: reject HostKey problem on Ubuntu](http://anahorny.blogspot.com/2013/05/solution-for-comjcraftjschjschexception.html)

**\===
\[erq\]**