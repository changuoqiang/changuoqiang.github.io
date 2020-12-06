---
title: H3C防火墙端口回流设置
tags: []
id: '5316'
categories:
  - - Internet
date: 2014-03-25 15:30:02
---


<!-- more -->
内网使用域名或公网IP访问同一个子网对外提供服务的服务器时,如不做特殊设置将无法访问,通过在内网接口上配置与公网接口相同的NAT设置可以解决此问题,实际上是对内网的源IP进行了NAT替换,替换成了防火墙内网接口的地址,从而使返回的数据包可以回流到防火墙再替换成正确的源IP,否则因为访问者和服务器在相同的内部网络中,数据包会走内部路由规则直接返回给访问者,由于数据包来源于内网ip而不是公网ip,会被访问者拒绝。但是ICMP不受此影响，如果用ping程序测试，网络看起来是通畅的。

也就是说，**端口回流时，对数据包的源ip和目标ip都做了替换，源ip替换成了防火墙内网接口的ip,而目标ip替换成了内网真正提供服务机器的ip,相应包返回到防火墙内网接口时，根据此前的替换记录，将ip地址再对调回来**就ok了。

```js
$ telnet x.x.x.x
<fw> system-view
\[fw\] interface xxx
\[fw\] nat server ... 
```

**注意：**还要在**内网接口**上做相应的[acl规则](https://openwares.net/misc/h3c_firewall_acl.html)以允许相应的内网流量从防火墙的内网接口通过。
比如内网接口的acl添加如下规则:
```js
rule 211 permit ip source 192.168.2.0 0.0.0.255 destination 192.168.0.3 0 
```
以允许192.168.2.0/24网段的机器可以通过内网接口访问192.168.0.3这台机器。

或者
```js
rule 216 permit ip destination 192.168.0.3 0
```

允许所有的机器可以通过内网接口访问192.168.0.3这台机器。

UPDATE(05/26/2016):
但这样设置会造成一个问题，所有的访问流量无论内外网都会被替换源地址，这可能不是你想要的。
参见[H3C SecPath防火墙内部服务器NAT访问所有源地址被替换问题](https://openwares.net/2016/05/26/h3c-secpath-nat-destination-replace/)

对端口回流问题的详述见Reference\[1\]

H3C还有一种技术叫dns-map,其实这玩意儿的思路和Great Fucking Wall的DNS污染如出一辙,都是将DNS服务器返回的IP地址替换掉,不过一个是替换成错误的,而另一个是替换成更准确的(可以通过内网直接访问的)。

References:
\[1\][端口回流与dns-map与域内NAT](http://melodyyayun.blog.51cto.com/2111476/956326)
\[2\][华为防火墙域之间inbound和outbound之间的区别！](http://blog.chinaunix.net/uid-27575921-id-3462739.html) 
\[3\][用传统的NAT方式替代H3C的DNS-MAP功能](http://virtualadc.blog.51cto.com/3027116/723231)
\[4\][outbound与inbound的区别——华为](http://blog.163.com/iloveyou10000years@126/blog/static/16332221820137150811151)
\[5\][linux 做防火墙端口回流问题](http://bluefox.blog.51cto.com/380387/166208)

**\===
\[erq\]**