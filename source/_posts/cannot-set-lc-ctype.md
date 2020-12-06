---
title: locale问题：Cannot set LC_CTYPE to default locale
tags:
  - Debian
id: '662'
categories:
  - - Misc
date: 2009-12-22 11:31:43
---

刚购买的[VPS](http://www.diahosting.com/client/aff.php?aff=190)默认安装的系统是CentOS，没想到CentOS现在这么火，很多VPS默认安装这个。但是我只用Debian或FreeBSD，重新安装了一下Debian lenny AMD64，几分钟就完成了。sudo apt-get upgrade时出现错误提示：

locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_MESSAGES to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory

原来是默认没有设置locale
用这个命令dpkg-reconfigure locales配置一下，选个lcoale就好了，我用en_US.UTF-8。