---
title: 'awstats:utf8编码页面使用纯真IP数据库显示地理位置问题的解决办法'
tags:
  - Debian
id: '182'
categories:
  - - GNU/Linux
date: 2009-06-14 18:38:55
---

utf8是目前最好的多字节编码方案，支持世界上的绝多大多数语言，也是我最喜欢的字符集。debian lenny 上的awstats安装完毕后，默认输出iso-8859-1字符集，对中文支持不友好。打开/usr/lib/cgi-bin/awstats.pl
，定位到大约第80、81行将$PageCode变量的内容更改为'UTF-8',这样awstats就可以吐出utf8编码格式的页面了。修改成utf8字符集还有一个好处，不用加载decodeutfkeys插件就可以正确的显示来自google的中文搜索关键字了。至于百度让它自生自灭去吧！

awstats通过插件qqhostinfo插件和qqwry.pl库使用纯真IP数据库可以显示来访者的地理位置，是一个不错的解决方案。具体的使用方法网上转载很多，可以google之。纯真IP数据库使用的是gbk/gb2312/gb18030系列编码，而我的awstats使用utf8编码，所以显示出来的物理地址全部是乱码。解决方法也很简单，打开qqwry.pl，在文件前面加上一句"use Encode;",然后找到"return $ipaddr;"这一行，在其前面加上一句"$ipaddr=decode("gbk",$ipaddr);” 就ok了，因为perl 5内部使用的就是utf8编码，所以就不用再encode成utf8了。