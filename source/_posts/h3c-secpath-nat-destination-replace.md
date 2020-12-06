---
title: H3C SecPath防火墙内部服务器NAT访问所有源地址被替换问题
tags: []
id: '7306'
categories:
  - - GNU/Linux
date: 2016-05-26 22:26:49
---


<!-- more -->
设置NAT内部服务器，并且设置了[端口回流](https://openwares.net/2014/03/25/h3c_backward/)，内网可以正常通过公网ip访问内部服务。

但是当通过外网访问该服务时，从服务器上观察，TCP连接的源地址也被替换成了防火墙的内网接口地址，不过访问一切正常。

经排查，是因为设置端口回流时，在内网接口的ACL条目中未指定source,类似如下：
```js
rule 216 permit ip destination 10.100.0.31 0
```

导致防火墙将所有访问NAT服务的源地址全部替换成了防火墙的内网接口地址(内网接口优先级高，且不区分内外网网络地址???)。

通过指定哪些内网段访问NAT服务器时可以通过内网接口，可以只替换这些网段的源地址。
```js
rule 226 permit ip source 192.168.1.0 0.0.0.255 destination 10.100.0.31 0 
rule 227 permit ip source 192.168.2.0 0.0.0.255 destination 10.100.0.31 0 
```
这样以来，外网访问时，源地址没有被替换，但acl rule未指定的其他内网地址段将不能通过公网ip访问NAT服务。

**\===
\[erq\]**