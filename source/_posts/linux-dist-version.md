---
title: 查看linux版本信息相关命令
tags:
  - Debian
id: '1201'
categories:
  - - GNU/Linux
date: 2011-03-16 20:52:02
---

查看linux distribution版本信息的命令有以下几个
<!-- more -->
系统信息
1 $uname \-a  
2 Linux debian 2.6.32-5-686 #1 SMP Wed Jan 12 04:01:41 UTC 2011 i686 GNU/Linux  

详细版本
1 $cat /proc/version  
2 Linux version 2.6.32-5-686 (Debian 2.6.32-30) (ben@decadent.org.uk) (gcc version 4.3.5 (Debian 4.3.5-4) ) #1 SMP Wed Jan 12 04:01:41 UTC 2011  

发行版版本信息
1 $lsb_release \-a  
2 No LSB modules are available.  
3 Distributor ID: Debian  
4 Description:    Debian GNU/Linux 6.0 (squeeze)  
5 Release:        6.0  
6 Codename:       squeeze  

**UPDATE(09/19/2013):**
还有一个配置文件有发行版本信息
$ cat /etc/issue
Debian GNU/Linux jessie/sid \\n \\l