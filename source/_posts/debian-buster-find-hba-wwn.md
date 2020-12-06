---
title: debian buster查看hba卡wwn序号
tags:
  - Debian
id: '8557'
categories:
  - - GNU/Linux
date: 2019-07-16 15:14:44
---


<!-- more -->
存储配置主机映射时，需要指定主机HBA(Host Bus Adapter)卡端口的WWN(World Wide Name)
因此需要从主机端查看这些WWN,Debian buster系统中这样查看
```js
$ cat /sys/class/fc_host/host*/port_name
0x10000090fa181673
0x10000090fa181ad6
```
表明有两个HBA端口，其WWN分别为0x10000090fa181673和0x10000090fa181ad6
存储中配置完成后，分别是这个样的10:00:00:90:fa:18:16:73和10:00:00:90:fa:18:1a:d6