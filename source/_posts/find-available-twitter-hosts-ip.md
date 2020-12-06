---
title: 查找可用的twitter hosts ip
tags:
  - Twitter
id: '964'
categories:
  - - Social
date: 2010-10-20 23:38:53
---

修改hosts ip来登录twitter是简单易行的方法之一,在linux平台上修改/etc/hosts文件,增加下面两行即可
<!-- more -->
xxx.xxx.xxx.xxx twitter.com
xxx.xxx.xxx.xxx api.twitter.com

当然一定要用https来访问,包括从浏览器和从客户端访问.但可用的ip经常被墙掉,下面就说一个查找可用IP的方法.

登录http://just-ping.com/或者此类提供在线ping网址的网站,在线ping一下api.twitter.com,然后根据ping解析出来的ip地址从本机ping过去,只要能本机能ping通的ip即可填入hosts文件使用.

经过我的测试发现,使用gprs连接时所有的ip都ping不同,我还没遇到过通的,说明移动公司可能封了整个网段,太狠了.而通过联通的网络却可以ping通大部分ip,其他运营商尚未测试.

另: 如果网站上提到twitter这个敏感词太多会不会网站被墙掉啊? #FuckGFW

更新:果然“[GFW对api.twitter.com的整个网段下手](http://lordong.net/tools/getip.php)”了