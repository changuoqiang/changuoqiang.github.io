---
title: authbind设置
tags:
  - Debian
id: '4794'
categories:
  - - GNU/Linux
date: 2014-01-13 20:46:46
---

tomcat 7突然无法启动了
<!-- more -->
**问题及解决**

catalina.out中有如下异常:
```js
...
SEVERE: Failed to initialize end point associated with ProtocolHandler \["http-bio-80"\]
java.net.SocketException: No such file or directory
at java.net.PlainSocketImpl.socketBind(Native Method)
 ...
SEVERE: Failed to initialize connector \[Connector\[HTTP/1.1-80\]\]
org.apache.catalina.LifecycleException: Failed to initialize component \[Connector\[HTTP/1.1-80\]\]
at org.apache.catalina.util.LifecycleBase.init(LifecycleBase.java:106)
 ...
```

百思不得其解,将tomcat默认端口改回8080,启动成功。看来是绑定到80端口出了问题,但这提示也实在是太模糊了。

查看/etc/authbind/byuid/110文件,110为tomcat7用户的uid:
```js
0.0.0.0/0:1,1023
```
这里的设置是允许绑定到ipv4地址的端口1-1023
文件的所有者和组都是tomcat7,权限设置也没有问题,不知道为啥就无法绑定80端口了。

/etc/authbind/byuid/110的内容更改为绑定ipv6地址和80端口:
```js
::/0,80
```
或者允许绑定到一个端口范围,端口1-1023:
```js
::/0,1-1023
```

重新启动tomcat7,绑定到80端口成功。虽然绑定是ipv6通配地址,但在双协议栈主机上,是可以接受ipv4连接请求的。ipv4地址有对应的ipv6地址映射。
有一个系统参数/proc/sys/net/ipv6/bindv6only控制是否只绑定到ipv6地址,如果此值为非0(true),则只绑定到ipv6地址,此参数值默认为0(false),所以可以同时绑定到ipv4和ipv6。

ipv6和ipv4共享相同的端口空间。

**authbind的三种配置方式**

authbind会依次测试byport,byaddr,byuid直到查找到一个允许的配置才停止查找,否则会失败,无法绑定到请求的端口。

_byuid_

刚才使用的是authbind的byuid配置方式,在/etc/authbind/byuid目录下新建文件,以tomcat7的uid为文件名,文件内容为如下格式之一的一行内容,每行格式的具体含义参见man authbind
```js
addrmin\[-addrmax\],portmin\[-portmax\]
addr\[/length\],portmin\[-portmax\]
addr4/length:portmin,portmax
```

_byport_

在/etc/authbind/byport目录下新建80文件,使其可以被tomcat7用户读取,则表示可以允许tomcat绑定到80端口
```js
# touch 80
# chown tomcat7:tomcat7 80
# chmod 0700 80
```

_byaddr_

byaddr有两种形式

/etc/authbind/byaddr/addr,port 或者 /etc/authbind/byaddr/addr:port,前者适用于ipv6和ipv4,后者只适用于ipv4

参考:
man authbind

**\===
\[erq\]**