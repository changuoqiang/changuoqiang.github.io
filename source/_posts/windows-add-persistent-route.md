---
title: windows添加永久静态路由
tags: []
id: '2781'
categories:
  - - Misc
date: 2013-01-21 14:48:56
---

windows添加永久静态路由
<!-- more -->
route命令有一个 -p 参数,将路由表项永久加入系统注册表,p即persistent

cmd命令行下:

cmd> route -p add 10.100.0.0 mask 255.255.255.0 192.168.5.1 if 3
为网络10.100.0.0/24添加路由表项,网关为192.168.5.1,网络设备接口为3,可以从route print输出看到网络设备接口号,还可以指定跃点数metric

cmd> route print
Persistent Routes就会显示该条路由表项,重新启动机器亦不受影响。