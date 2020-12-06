---
title: acpi_pad导致高cpu占用
tags: []
id: '8271'
categories:
  - - GNU/Linux
date: 2019-04-06 22:24:23
---


<!-- more -->
服务器上突然出现很多acpi_pad/*进程,*为0,1,2,3,...，每个进程都占用100%CPU，导致系统极度缓慢

解决办法就是移除acpi_pad模块
```js
# rmmod acpi_pad
```
并将其加入模块blacklist，/etc/modprobe.d/blacklist.conf文件中添加
```js
blacklist acpi_pad
```

或者
在 grub 的 kernel 配置后面，添加 acpi_pad.disable=1 重启机器之后，开机就不会自动加载 acpi_pad 模块

注：早上跑到机房一看，空调自己关闭了，环境温度40几度，服务器、机柜一片报警，赶快打开两个空调降温，acpi_pad的问题是不是与环境温度过高有关呢？