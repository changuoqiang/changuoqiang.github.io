---
title: Jenkins安装配置
tags: []
id: '4891'
categories:
  - - GNU/Linux
date: 2014-01-21 20:27:55
---


<!-- more -->
**安装**

编辑文件 /etc/apt/sources.list.d/jenkins.list,其内容如下:
```js
deb http://pkg.jenkins-ci.org/debian binary/
```
然后执行以下命令:
```js
$ wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install jenkins
```

**配置**

_端口_

Jenkins默认监听8080端口,如果与其他应用程序端口冲突,修改/etc/default/jenkins文件:

HTTP_PORT=8082

然后
```js
# /etc/init.d/jenkins restart
```
就可以了

_访问控制_

Jenkins默认安装是没有启用访问控制的,也就是可以随便匿名访问,要启用安全控制,访问Jenkins web界面,从"系统管理->安全设置"中配置即可。

_邮件通知_

打开Manage Jenkins -> Configure System:

Jenkins Location -> System Admin e-mail address 设置管理员邮箱地址
E-mail Notification -> SMTP server 输入stmp服务器地址
Default user e-mail suffix 用户邮箱后缀,比如@openwares.net
Advanced -> Use SMTP Authentication 输入smtp认证需要的User Name和password
Use SSL 如果服务器使用SSL则勾选,如果使用TLS/STARTTLS则不要勾选
SMTP Port 指定端口,默认25

如果smtp服务器使用TLS,则需要在jenkins配置文件/etc/default/jenkins中添加JAVA选项:
JAVA_ARGS="-Dmail.smtp.starttls.enable=true" # enable STARTTLS
否则测试邮件发送会有异常:
```js
Failed to send out e-mail

javax.mail.MessagingException: Could not connect to SMTP host: mail.openwares.net, port: 25; 
 nested exception is: 
 javax.net.ssl.SSLException: Unrecognized SSL message, plaintext connection?
 at com.sun.mail.smtp.SMTPTransport.openServer(SMTPTransport.java:1934)
 at com.sun.mail.smtp.SMTPTransport.protocolConnect(SMTPTransport.java:638)
 ...
```
然后重新启动jenkins。

但是如果启用STARTSSL时服务器的SSL证书是自签的,又会抛出异常:
```js
Failed to send out e-mail

javax.mail.MessagingException: Could not convert socket to TLS;
 nested exception is:
javax.net.ssl.SSLHandshakeException: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
at com.sun.mail.smtp.SMTPTransport.startTLS(SMTPTransport.java:1880)
 ...
```
因为证书是不受信任的:-(。

那么还需要在jenkins配置文件/etc/default/jenkins中添加一个JAVA选项:
JAVA_ARGS="-Dcom.sun.net.ssl.checkRevocation=false" #disable cert verify

这样就可以正常发送邮件了。

References:
\[1\][Jenkins Debian packages](http://pkg.jenkins-ci.org/debian/)
\[2\][Installing Jenkins on Ubuntu](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Ubuntu)

**\===
\[erq\]**