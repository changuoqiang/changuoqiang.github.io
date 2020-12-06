---
title: Firefox变身其他浏览器
tags:
  - Firefox
id: '1066'
categories:
  - - Firefox
date: 2011-03-10 11:10:56
---

很多移动应用程序官方网站不提供普通桌面下载链接,要求用手机去market、app store或者用手机浏览器去下载,如果想从电脑上下载怎么办呢？
<!-- more -->
Firefox插件User Agent Switcher可以做到。User Agent Switcher的原理就是切换Firefox浏览器向服务器报告的浏览器类型标志(User Agent)，从而使服务器把浏览器当作它自己报告的类型来处理。

　　安装好之后会在tools工具栏下面增加切换User Agent的项,插件默认带的User Agent很少,可以去[这个地方](http://techpatterns.com/forums/about304.html)下载已经整理好的[User Agent xml](http://techpatterns.com/downloads/firefox/useragentswitcher.xml)文件,然后从User Agent Switcher里选择Import导入此文件,这样浏览器类型就很全面了,切换User Agent后再浏览网站就可以了。
[![](/images/2011/03/user_agent_switcher.jpg "user_agent_switcher")](/images/2011/03/user_agent_switcher.jpg)