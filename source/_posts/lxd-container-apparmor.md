---
title: lxd容器与apparmor
tags:
  - Debian
id: '8368'
categories:
  - - GNU/Linux
date: 2019-06-06 22:23:31
---


<!-- more -->
安全很重要，但也很烦人。

lxd容器test8内无法启动tomcat9,查看服务状态如下：
```js
# systemctl status tomcat9
● tomcat9.service - Apache Tomcat 9 Web Application Server
 Loaded: loaded (/lib/systemd/system/tomcat9.service; enabled; vendor preset: enabled)
 Active: failed (Result: exit-code) since Thu 2019-06-06 20:52:24 CST; 10min ago
 Docs: https://tomcat.apache.org/tomcat-9.0-doc/index.html
 Process: 187 ExecStartPre=/usr/libexec/tomcat9/tomcat-update-policy.sh (code=exited, status=0/SUCCESS)
 Process: 191 ExecStart=/bin/sh /usr/libexec/tomcat9/tomcat-start.sh (code=exited, status=226/NAMESPACE)
 Main PID: 191 (code=exited, status=226/NAMESPACE)

Jun 06 20:52:24 test8 systemd\[1\]: Starting Apache Tomcat 9 Web Application Server...
Jun 06 20:52:24 test8 systemd\[1\]: Started Apache Tomcat 9 Web Application Server.
Jun 06 20:52:24 test8 systemd\[191\]: tomcat9.service: Failed to set up mount namespacing: Permission den
ied
Jun 06 20:52:24 test8 systemd\[191\]: tomcat9.service: Failed at step NAMESPACE spawning /bin/sh: Permiss
ion denied
Jun 06 20:52:24 test8 systemd\[1\]: tomcat9.service: Main process exited, code=exited, status=226/NAMESPA
CE
Jun 06 20:52:24 test8 systemd\[1\]: tomcat9.service: Failed with result 'exit-code'.
```

这里就是因为apparmor阻止了一些资源的访问，细粒度的配置还需要仔细阅读文档，当前可以暂时关闭apparmor对容器的所有限制

```js
$ lxc config set test8 raw.lxc "lxc.apparmor.profile=unconfined"
$ lxc restart test8
```

然后就可以正常启动tomcat9服务了。