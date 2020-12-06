---
title: 普通用户的crontab
tags:
  - Debian
id: '6428'
categories:
  - - GNU/Linux
date: 2015-05-16 14:10:38
---


<!-- more -->
除了root用户外,普通用户可以添加自己的定时服务。/usr/bin/crontab程序设置了组ID,因此普通用户运行crontab时是以crontab组权限运行的。

**编辑用户cron配置**
```js
$ crontab -e 
```
**列出用户cron配置**
```js
$ crontab -l
```
更详细的用法见man crontab。

**用户crontab文件位置**

不同的操作系统，用户的crontab文件位置可能会不同:
```js
Debian / Ubuntu Linux - /var/spool/cron/crontabs/
Mac OS X - /usr/lib/cron/tabs/ 
FreeBSD/OpenBSD/NetBSD - /var/cron/tabs/ 
CentOS/Red Hat/RHEL/Fedora/Scientific Linux - /var/spool/cron/ 
HP-UX Unix - /var/spool/cron/crontabs/
IBM AIX Unix - /var/spool/cron/
```

**\===
\[erq\]**