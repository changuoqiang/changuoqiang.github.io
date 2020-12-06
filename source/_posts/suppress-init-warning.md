---
title: '禁止INIT:Id "co" respawning too fast提示'
tags:
  - Debian
id: '1576'
categories:
  - - GNU/Linux
date: 2011-07-02 14:07:52
---

debian testing控制台出现提示"INIT: Id "co" respawning too fast: disabled for 5 minutes."
<!-- more -->
这应该是内核的一个bug,有很多人提出来了,这个提示是由/etc/inittab中的这行

co:2345:respawn:/sbin/getty hvc0 9600 linux

引起的。这行的意思是在运行级2345上运行一个终端类型为linux,波特率baud rate为9600的虚拟控制台hvc0

hvc0是一个hvc控制台实例,hvc是Hypeyvisor Virtual Console的缩写,其实际就是一个虚拟机监视虚拟控制台,因为现在linux内核集成了KVM，所以才有这么个控制台,一般我们都不会用到，所以将其关闭是安全的。

而XVC则指Xen Virtual Console,是Xen的管理虚拟控制台。