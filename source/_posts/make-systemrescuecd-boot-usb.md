---
title: 制作SystemRescueCd启动U盘
tags:
  - Debian
id: '7810'
categories:
  - - GNU/Linux
date: 2016-12-12 11:16:32
---


<!-- more -->
官方下载的SystemRescueCd ISO并不支持制作启动u盘，所以需要先将iso转换成可硬盘/u盘启动的iso
使用isohybrid命令来转换，需要先安装syslinux-utils包
```js
# apt install syslinux-utils 
```
然后执行转换
```js
$ isohybrid systemrescuecd-x86-x.x.x.iso
```
此命令会进行就地转换，因为如需保留原iso的话请先备份。

然后写入u盘就可以了：
\[bash 1="dd" if="systemrescuecd.iso" of="/dev/sdc" 2="\[/bash" language="#"\]```

**\===
\[erq\]**