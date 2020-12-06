---
title: windows x64平台部署32位asp程序及连接oracle 10g数据库
tags:
  - Oracle
id: '1498'
categories:
  - - Misc
date: 2011-05-16 20:10:08
---

32位asp程序在x64平台上的安装以及连接oracle 10g数据库的若干问题记录
<!-- more -->
业务系统应用组件仍然是在32位windows平台上运行的,后端数据库oracle 10g已经在64位平台上运行。新的服务器硬件配置很高,再安装32位的windows实在是太浪费资源了。

windows 2003 x64 r2上的iis6支持在32位模式下运行asp程序,只需执行一下指令打开此模式即可

cmd>cscript.exe %SYSTEMDRIVE%\\inetpub\\adminscripts\\adsutil.vbs SET W3SVC/AppPools/Enable32bitAppOnWin64 1

这样就可以像32位平台一样来部署asp应用了,此时32位asp应用程序运行在WOW64模拟环境下。

但是这种模式下32位应用程序访问oracle 10g数据库就要注意了,经过多次实验,总结如下：
x64平台下的32位应用程序要访问oracle 10g数据库,只能安装32位版本的oracle 10g或其他版本32位客户端，如果在本机安装服务器端也只能安装32位的oracle 10g服务器。

原因有二：其一，32位应用的程序的注册表被重定向到了Wow6432Node节点下,所以32位应用程序无法访问到64位oracle客户端或者服务器的注册表内容。其次，x64平台上，32位进程不能加载64位Dll，64位进程也不可以加载32位Dll。也就是说，就算能从注册表里能找到64位oracle客户端或服务器的信息，但是仍然无法将其加载，也就无法连接访问。

如果在两台机器之间访问oracle服务则几乎没有任何限制,两边的客户端和服务器端可以跨异构异质平台，因为TCP是天然跨平台的。