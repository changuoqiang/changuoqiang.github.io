---
title: ubuntu系统为ppp接口配置IPv6隧道(IPv6-in-IPv4 tunnel)
tags:
  - Ubuntu
id: '693'
categories:
  - - GNU/Linux
date: 2010-01-03 21:57:35
---

linux最早的IPv6/IPng支持代码始于kernel 2.1.8，November 1996，也算是历史悠久了，而IPv6在1998年8月10日成为IETF的草案标准。
　　Ubuntu 9.10默认是开启IPv6协议的，也就是说我们的主机是IPv4/IPv6双栈主机。可以通过检查/proc/net/if_inet6这个文件是否存在来确定内核是否支持IPv6，如果这个文件不存在，那么你的系统极有可能是通过可加载模块来支持IPv6的。虽然kernel是支持IPv6了，但现在的网络条件下，除了教育网直接支持IPv6外，其他网络用户还是无法直接访问IPv6网站的，也就是说我们的主机成了IPv6孤岛，只能通过IPv6-in-IPv4隧道协议来访问IPv6资源。
<!-- more -->
有多种多样的方式来实现这种隧道，这里只介绍其中的一种站内自动隧道寻址协议ISATAP(Intra-Site Automatic Tunnel Addressing Protocol)，这是一种点对点隧道协议(point-to-point tunneling)。
　　使用ISATAP需要知道ISATAP隧道路由器的IPv4地址，IPv6地址及其网络前缀和本地的IPv4地址。可以使用教育网提供的隧道路由器，比如[上海交大](http://ipv6.sjtu.edu.cn/news/041231.php)，下面就以这个隧道路由器为例来设置本地ppp接口。
　　IPv6提供了2001:和2002:开头的地址用于IPv6-in-IPv4隧道，ISATAP一般使用2001:开头的IPv6地址.
建立隧道的脚本build_ipv6_tunnel如下：
1 #!/bin/bash  
2  
3 ipv4_addr\=\`ifconfig ppp0  **grep** **'**inet addr**'**  cut -d**'**:**'** -f 2cut -d**'** **'** -f 1\`  
4 ip tunnel add sit1 mode sit remote 202.120.58.150 **local** ${ipv4_addr}  
5 ifconfig sit1 up  
6 ifconfig sit1 add 2001:da8:8000:d010:0:5efe:${ipv4_addr}/64  
7 ip \-6 route add ::/0 via 2001:da8:8000:d010::1 metric 1 dev sit1  
　　ipv4_addr就是本地ppp接口获取的IPv4地址，隧道路由器的IPv4地址为202.120.58.150，IPv6地址为2001:da8:8000:d010::1,其IPv6地址网络前缀为2001:da8:8000:d010::/64,而本地IPv6地址的host部分为0:5efe:${ipv4_addr},这样两部分(64位网络部分和64位主机部分)合并在一起就构成了本地IPv6地址2001:da8:8000:d010:0:5efe:${ipv4_addr}/64。这里是静态设置的本地IPv6地址，ISATAP也支持动态配置客户端IPv6地址。
　　mode sit处的sit是简单互联网转换Simple Internet Transition的缩写，当然接口名字可以随意取，不一定非要叫做sit1，但据说不能用sit0,我没测试。
　　拆除隧道的脚本delete_ipv6_tunnel如下：
1 #!/bin/bash  
2  
3 ip \-6 route del ::/0 via 2001:da8:8000:d010::1 dev sit1  
4 ip link **set** sit1 down  
5 ip tunnel del sit1  
　　将build_ipv6_tunnel置于目录/etc/ppp/ip-up.d/下，delete_ipv6_tunnel置于目录/etc/ppp/ip-down.d/下，就可以随ppp0接口的建立和拆除而自动的建立和拆除隧道了。
　　现在访问http://www.ipv6.org,如果看到类似“You are using IPv6 from 2001:da8:8000:d010:0:5efe:xxxx:xxxx“的信息，说明IPv6已经正常工作了。
　　如果能找到Ipv6反向代理，那就可以用IPv6来访问一些平常不能访问的站点了，比如twitter，详见"[用IPv6反向代理访问Twitter](http://internet.solidot.org/article.pl?sid=09/12/09/0347210&tid=48)"