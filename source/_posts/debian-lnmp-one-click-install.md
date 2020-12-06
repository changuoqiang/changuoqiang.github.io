---
title: Debian Squeeze lnmp一键安装脚本
tags:
  - Debian
  - Nginx
id: '1261'
categories:
  - - GNU/Linux
date: 2011-04-06 10:59:56
---

很简单的脚本,方便nginx,mysql,php安装,使用dotdeb.org的安装源。
<!-- more -->
执行./lnmp_install.sh安装,安装过程中需要设置mysql root密码,安装完毕后,只需在nginx virtualhox配置文件中增加include php-fpm.php;即可让虚拟主机支持PHP程序,额外再添加include wordpress.conf;即可支持wordpress程序

[脚本下载](/downloads/lnmp_install.sh)

 1 #!/bin/bash  
 2   
 3 ########################  
 4 \# [http://openwares.net](https://openwares.net) #  
 5 ########################  
 6   
 7 **set** \-e  
 8   
 9 #dotdeb source  
10 sudo **sed** \-i **'**$a\\\\n#dotdeb for nginx,mysql,php\\ndeb [http://packages.dotdeb.org](http://packages.dotdeb.org) squeeze all**'** /etc/apt/sources.list   
11   
12 wget [http://www.dotdeb.org/dotdeb.gpg](http://www.dotdeb.org/dotdeb.gpg)  
13 cat dotdeb.gpg sudo apt-key add -  
14 **rm** dotdeb.gpg  
15   
16 sudo apt-get update  
17   
18 ###install nginx,php5(fastcgi),mysql5###  
19 sudo apt-get \-y **install** nginx-light mysql-server php5-cli php5-fpm php5-mysql  
20   
21 ###awstats,perl-fcgi modules###  
22 #sudo apt-get -y install awstats  
23 #sudo apt-get -y install libfcgi-perl libfcgi-procmanager-perl libio-all-perl  
24   
25 #php config file for nginx  
26 sudo sh \-c **'**echo "#pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000\\nlocation ~ \\.php$ {\\n\\tfastcgi_pass\\t127.0.0.1:9000;\\n\\tfastcgi_index\\tindex.php;\\n\\tinclude\\t\\t\\tfastcgi_params;\\n}" > /etc/nginx/php-fpm.conf**'**  
27   
28 #nginx rewrite rules for wordpress  
29 sudo sh \-c **'**echo "#rewrite rules for wordpress\\nlocation / {\\n\\tif (-d \\$request_filename){\\n\\t\\trewrite (.*) /\\$1/index.php last;\\n\\t}\\n\\tif (!-f \\$request_filename){\\n\\t\\trewrite (.*) /index.php?\\$1 last;\\n\\t}\\n}" > /etc/nginx/wordpress.conf**'**  
30   
31 sudo /etc/init.d/nginx **start**  
32 sudo /etc/init.d/php5-fpm **start**