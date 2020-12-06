---
title: kpartx为多路径块设备分区增加设备映射
tags:
  - Debian
id: '3190'
categories:
  - - GNU/Linux
date: 2013-09-08 22:07:34
---

kpartx命令用来为块设备上的分区增加设备映射
<!-- more -->
一直以来，multipath-tools会自动的为多路径设备自动映射分区设备文件，但最近升级到wheezy最新版本后，/dev/mapper/目录下只有整个块设备data(dm-0)，而没有为分区准备的映射文件
```js
# ls -l /dev/mapper
total 0
crw------T 1 root root 10, 236 Sep 8 19:52 control
lrwxrwxrwx 1 root root 7 Sep 8 19:53 data -> ../dm-0


# fdisk /dev/mapper/data
```js
是可以看到多路径设备data下的分区data1的
```js
Device Boot Start End Blocks Id System
/dev/mapper/data1 2048 2924441599 1462219776 83 Linux
```
看来需要手动映射一下
```js
# kpartx -a /dev/mapper/data
```
再看设备文件
```js
# ls -l /dev/mapper
total 0
crw------T 1 root root 10, 236 Sep 8 19:52 control
lrwxrwxrwx 1 root root 7 Sep 8 19:53 data -> ../dm-0
lrwxrwxrwx 1 root root 7 Sep 8 20:21 data1 -> ../dm-1
```
这样就可以看到分区data1(dm-1),并且可以正常的挂装。

kaprtx的完整选项：

-a 增加分区映射 add
-r 分区映射为只读状态 readonly
-d 删除分区映射 delete
-u 更新分区映射 update 
-l 列出用选项-a会映射的分区 list
-p 设置设备名-分区号之间的分隔符号，默认为空 
-f 强制创建分区映射，忽略'no_partitions'特性，force
-g 强制GUID分区表,GUID
-v 冗余输出，verbose
-s 同步模式，知道分区表建立才返回,sync

kpartx可以挂载含有分区的映像文件，比如
```js
# kpartx -av disk.img
```