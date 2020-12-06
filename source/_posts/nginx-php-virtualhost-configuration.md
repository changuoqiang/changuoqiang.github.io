---
title: nginx php fastcgi虚拟主机配置
tags:
  - Nginx
id: '1366'
categories:
  - - GNU/Linux
date: 2011-04-23 10:38:37
---

[安装lnmp](https://openwares.net/linux/nginx_mysql_phpfastcgi_install.html)或使用[lnmp一键安装脚本](https://openwares.net/linux/debian_lnmp_one_click_install.html)完成后,php的FastCGI接口php-fpm(FastCGI Process Manager)已经就绪,nginx通过php-fpm来处理用户对php应用程序的请求。
<!-- more -->
**配置文件布局**

nginx的主配置目录位于/etc/nginx,可用的虚拟主机配置文件请放置到/etc/nginx/sites-available,启用虚拟主机只需在/etc/nginx/sites-enabled目录下建一个到虚拟主机配置文件的符号链接即可,与apache的配置文件布局基本一致。Debian的配置文件布局还是很赏心悦目的。

**虚拟主机配置**

/etc/nginx目录下新建文件php-fpm.conf,输入一下内容,注意不要带行号

1 #pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000  
2 location ~ \\.php$ {  
3     fastcgi_pass   127.0.0.1:9000;  
4     fastcgi_index  index.php;  
5     include        fastcgi_params;  
6 }  

php-fpm默认配置是在127.0.0.1:9000上监听php请求的,也可以配置成使用unix domain socket监听请求,根据你的配置，相应的修改第三行的参数fastcgi_pass。

/etc/nginx/sites-available目录下新建虚拟主机配置文件,这里是openwares.net.conf,内容如下：

 1 server {  
 2     listen      80;  
 3     server_name openwares.net www.openwares.net;  
 4     root        /home/username/www/openwares.net;  
 5     index       index.php;  
 6     access_log  /var/log/nginx/openwares.net_access.log;  
 7     error_log   /var/log/nginx/openwares.net_error.log;  
 8  
 9     include php-fpm.conf;  
10 }  

最后在/etc/nginx/sites-enabled目录下建立一个符号链接就可以了

$cd /etc/nginx/sites-enabled
$sudo ln -sf /etc/nginx/sites-available/openwares.net.conf openwares.net.conf

配置完成后重新装载nginx配置
$sudo /etc/init.d/nginx reload

**测试**

在/home/username/www/openwares.net/目录下新建about.php



从浏览器访问about.php，输出php版本信息就配置成功了。