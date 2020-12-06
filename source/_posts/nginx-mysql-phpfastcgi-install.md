---
title: 'nginx,mysql,php(fastcgi)轻松安装'
tags:
  - Debian
  - Wordpress
id: '1254'
categories:
  - - GNU/Linux
date: 2011-04-04 09:12:42
---

vps资源有限,所以安装lnmp(linux/nginx/mysql/php)是比较适宜的选择。
<!-- more -->
debian源里的nginx版本总是很低,php又没有fpm模块,原来都是下载源代码编译安装,虽然也很简单,但未免太过繁琐、配置文件混乱且安全性更新等很难顾及,还是以debian的方式来管理比较方便,[dotdeb.org](http://www.dotdeb.org/)(The repository for Debian-based LAMP servers)为我们做好了这一切。dotdeb.org现在已经开始维护nginx repository,真的很方便。

/etc/apt/sources.list文件添加
deb http://packages.dotdeb.org stable all

然后获取源的key并刷新源

1 $wget [http://www.dotdeb.org/dotdeb.gpg](http://www.dotdeb.org/dotdeb.gpg)  
2 $cat dotdeb.gpg sudo apt-key add -  
3 $sudo apt-get update  

安装lnmp
1 $sudo apt-get install nginx-light mysql-server php5-cli php5-fpm php5-mysql  

源里nginx版本现在为0.8.54,mysql为5.1.56,php5为5.3.5,还是比较新的,希望稳定性也能经受住考验。

It's ok!