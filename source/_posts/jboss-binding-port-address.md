---
title: jboss as 7配置绑定端口和地址
tags:
  - Debian
  - Java
id: '2947'
categories:
  - - GNU/Linux
date: 2013-05-12 15:13:42
---

jboss的http访问默认绑定到本地loopback接口的8080端口
<!-- more -->
jboss standalone配置文件为${JBOSS_HOME}/standalone/configuration/standalone.xml

**接口配置**

接口绑定语句
\[xml highlight="5,6"\] 
 <interfaces>
 <interface name="management">
 <inet-address value="${jboss.bind.address.management:127.0.0.1}"/>
 </interface>
 <interface name="public">
 <inet-address value="${jboss.bind.address:127.0.0.1}"/>
 </interface>
 <interface name="unsecure">
 <inet-address value="${jboss.bind.address.unsecure:127.0.0.1}"/>
 </interface>
 </interfaces> 
\[/xml\]

public访问接口绑定到了127.0.0.1，也就是localhost,从外部是无法访问到的。要从外部访问，必须绑定到其他非本地回环接口，或者直接绑定到本地所有接口，如
\[xml\]
<interface name="public">
 <any-address/>
</interface>
\[/xml\]

**端口配置**

\[xml highlight="6"\]
 <socket-binding-group name="standard-sockets" default-interface="public" port-offset="${jboss.socket.binding.port-offset:0}">
 <socket-binding name="management-native" interface="management" port="${jboss.management.native.port:9999}"/>
 <socket-binding name="management-http" interface="management" port="${jboss.management.http.port:9990}"/>
 <socket-binding name="management-https" interface="management" port="${jboss.management.https.port:9443}"/>
 <socket-binding name="ajp" port="8009"/>
 <socket-binding name="http" port="8080"/>
 <socket-binding name="https" port="8443"/>
 <socket-binding name="osgi-http" interface="management" port="8090"/>
 <socket-binding name="remoting" port="4447"/>
 <socket-binding name="txn-recovery-environment" port="4712"/>
 <socket-binding name="txn-status-manager" port="4713"/>
 <outbound-socket-binding name="mail-smtp">
 <remote-destination host="localhost" port="25"/>
 </outbound-socket-binding>
 </socket-binding-group>
\[/xml\]

可见默认访问端口为8080,访问应用时必须添加端口号。因为传统的web服务器比如apache,nginx,iis都默认绑定到80端口，一般联合使用来提供服务，apache等提供静态资源访问，而jboss等提供动态内容。如果只使用jboss,那么可以将默认绑定端口更改为80，有两种方式。

1、直接更改端口为80

linux系统下，只有特权用户root才能绑定1024以下的端口，所以如果更改为80端口，则必须以root用户来启动jboss,存在安全隐患，不推荐。apache是先通过特权用户绑定80端口，然后降低到普通用户的权限来提供服务。

2、端口重定向

创建iptables规则，将对端口80的访问重定向到8080端口

```js# iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080```

针对本地loopback接口的规则
```js# iptables -t nat -A OUTPUT -d localhost -p tcp --dport 80 -j REDIRECT --to-ports 8080```

然后就可以通过80端口来访问jboss应用了