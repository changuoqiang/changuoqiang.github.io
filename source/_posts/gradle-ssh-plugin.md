---
title: gradle ssh plugin
tags:
  - gradle
id: '6892'
categories:
  - - GNU/Linux
date: 2015-11-07 22:22:17
---


<!-- more -->
提供gradle访问ssh执行命令、传输文件的功能。

**安装**
构建脚本中添加:
```js
plugins {
 id 'org.hidetake.ssh' version '1.1.4'
}
```

**使用**

```js
remotes {
 webServer {
 host = '192.168.1.101'
 port = 2022
 user = 'jenkins'
 identity = file('id_rsa')
 }
}

task deploy << {
 ssh.run {
 session(remotes.webServer) {
 put from: 'example.war', into: '/webapps'
 execute 'sudo service tomcat restart'
 }
 }
}
```

可以使用此插件通过ssh自动部署应用程序。

tomcat热部署会持续的泄露PermGen内存，因此还是常规的部署更靠谱，不过应用程序会暂时中断。

References:
\[1\][gradle-ssh-plugin](https://github.com/int128/gradle-ssh-plugin)
\[2\][Deploy your App from Gradle](https://gradle-ssh-plugin.github.io/)

**\===
\[erq\]**