---
title: 'nginx,tomcat,memcached会话共享集群配置'
tags:
  - Debian
id: '7315'
categories:
  - - GNU/Linux
date: 2016-05-31 20:40:19
---


<!-- more -->
tomcat自身支持会话复制的集群。

此post主要讲使用memcached存储会话，使用msm(memcached-session-manager)来管理会话复制。

通过配置共享会话的tomcat集群，可以提高服务的高可用性，并可以做到不停机连续更新应用程序。

示例配置采用两台机器，ip分别为10.100.0.20和10.100.0.21。每台机器分别部署nginx,tomcat和memcached。两个tomcat实例和两个memcached实例通过msm组成一个会话共享集群，前端由nginx做负载均衡。

还可以在nginx之前做DNS负载均衡。

**nginx配置**

```js

upstream servers {
 server 10.100.0.20:8080;
 server 10.100.0.21:8080;
}

location / {
 proxy_pass http://servers;
 proxy_set_header Accept-Encoding "gzip";

 # proxy websocket reverse
 proxy_http_version 1.1;
 proxy_set_header Upgrade $http_upgrade;
 proxy_set_header Connection "upgrade";
 }
```

nginx会将客户请求分发到后端服务器组

**memcached配置**
安装

```js
# apt install memcached
```

memcached默认安装只监听本地回环地址，更改/etc/memcached.conf，注释掉下面的行:

```js
#-l 127.0.0.1
```

重启memcached服务会监听所有本地接口。

**msm和tomcat配置**

kiro序列化性能较高，因此这里使用kiro序列化器。

将msm基础包memcached-session-manager-${version}.jar，memcached-session-manager-tc8-${version}.jar和spymemcached-2.11.1.jar，以及kryo序列化支持jar包拷贝到$CATALINA_HOME/lib/目录。

debian系统中tomcat8的lib目录位于/usr/share/tomcat8/lib/

还有一个包[Objenesis](http://objenesis.org/download.html)也需要下载安装到此目录中。

**sticky sessions + kryo配置**

/etc/tomcat8/context.xml文件中context一节最后添加：
```js
<Manager className="de.javakaffee.web.msm.MemcachedBackupSessionManager"
 memcachedNodes="n1:10.100.0.20:11211,n2:10.100.0.21:11211"
 failoverNodes="n1"
 requestUriIgnorePattern=".*\\.(icopnggifjpgcssjs)$"
 transcoderFactoryClass="de.javakaffee.web.msm.serializer.kryo.KryoTranscoderFactory"
 />
```

msm默认处于sticky模式，因此不用显式指定sticky参数。failoverNodes参数指定本机memcached节点名称,这样正常情况下msm会存储会话到其他memcached节点，当没有其他节点可用时才会使用failoverNodes。

**non-sticky sessions + kryo配置**

/etc/tomcat8/context.xml文件中context一节最后添加：
```js
 <Manager className="de.javakaffee.web.msm.MemcachedBackupSessionManager"
 memcachedNodes="n1:10.100.0.20:11211,n2:10.100.0.21:11211"
 sticky="false"
 sessionBackupAsync="false"
 lockingMode="auto"
 transcoderFactoryClass="de.javakaffee.web.msm.serializer.kryo.KryoTranscoderFactory"
 />
```

这里明确指定sticky参数为false，注意不要设置requestUriIgnorePattern参数，否则当前配置下会出现问题，无法完成session共享。

sticky会话模式就是将用户“粘”在某一个服务器节点上，即同一个会话中的请求必须被转发到同一个节点上，除非该节点宕机才转发到故障转移节点。

non-sticky会话模式则是每一次请求都可能转发到不同节点。

sticky会话模式性能更好。

References:
\[1\][SetupAndConfiguration](https://github.com/magro/memcached-session-manager/wiki/SetupAndConfiguration)
\[2\][分布式session](http://www.cnblogs.com/zhengyun_ustc/archive/2012/11/17/topic4.html)

**\===
\[erq\]**