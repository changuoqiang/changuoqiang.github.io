---
title: DCube3.ocx控件注册失败的解决办法
tags: []
id: '854'
categories:
  - - Misc
date: 2010-07-12 19:45:37
---

单位的某一个业务系统用到了DynamiCube组件，很多客户端的IE浏览器都无法正常下载并注册DynamiCube组件，导致页面无法正常显示。手工拷贝DCube3.cab到客户端并解出Dcube3.ocx，然后regsvr32 Dcube3.ocx会有错误提示“LoadLibrary("DCube3.ocx") 失败 - 内存分配访问无效”，英文的错误提示是“LoadLibrary(dcube3.ocx") failed - Invalid Access to Memory Location”。其实这是因为Dcube3.ocx受到DEP(Data Eexcute Protection)阻止造成的。解决办法也很简单，先禁止DEP，然后注册Dcube3.ocx，然后再打开DEP即可。

XP SP3可以这样关闭DEP,打开boot.ini文件，将/noexecute的值改为AlwaysOff或者将/noexecute及等号后的值一起改为/execute,保存重启系统即可。