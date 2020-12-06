---
title: 'traceroute: 使用纯真IP数据库显示中间路由器以及主机的地理位置'
tags:
  - Perl
id: '200'
categories:
  - - GNU/Linux
date: 2009-06-15 11:42:18
---

traceroute是常用的网络诊断和查询工具，但是通常traceroute只能显示中间路由器和主机的ip地址和主机名，如果能输出机器的地理位置是最好不过了。怎么办？重新写一个traceroute？这是windows的思路。traceroute已经足够好了，为什么要重写呢，我们只要把结果加工一下就可以了。不得不佩服UNIX的设计哲学，无疑这种正交的功能，如果硬要搀和在一起，实在是没什么必要和额外的好处。
<!-- more -->
有了[查询纯真IP数据库的Perl程序](https://openwares.net/linux/awstats_ip_geo_qqwrypl.html)[ip_geo_qqwry.pl](/downloads/ip_geo_qqwry.zip)，让traceroute显示机器的地理位置是十分简单的事情。把traceroute的输出重定向到一个脚本，脚本中将ip替换成对应的地理位置就可以了。下面是这个perl脚本ip2geo.pl的代码：

 1 #!/usr/bin/perl  
 2  
 3 **binmode**(STDOUT, ':encoding(utf8)');  
 4 **require** "ip_geo/ip_geo_qqwry.pl";  
 5  
 6 **my** $pattern_ip = '\\(((?:(?:1?\[0-9\]?\[0-9\]2(?:\[0-4\]\[0-9\]5\[0-5\]))\\.){3}(?:1?\[0-9\]?\[0-9\]2(?:\[0-4\]\[0-9\]5\[0-5\])))\\)';  
 7 **my** $line,$matches, $match, $ip_geo_addr;  
 8 **while**($line = <STDIN>){  
 9     @matches = $line =~ **/**$pattern_ip**/g**;  
10     **foreach** $match (@matches){  
11         $ip_geo_addr = &ipwhere($match);  
12         $line =~ **s/**\\($match\\)**/**\[$ip_geo_addr\]**/**;  
13     }  
14     **print** $line;  
15 }  
16  
17 1;  

然后这样traceroute www.google.cn ip2geo.pl就可以看到中间路由器和主机的地理位置了。
下面是我用PuTTY从远程主机执行该命令行的截图：[![traceroute](/images/2009/06/traceroute-300x141.jpg "traceroute")](/images/2009/06/traceroute.jpg)

**\===
\[erq\]**