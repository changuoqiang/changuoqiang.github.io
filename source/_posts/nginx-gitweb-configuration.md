---
title: nginx gitweb配置
tags:
  - Nginx
id: '1457'
categories:
  - - GNU/Linux
date: 2011-05-10 20:42:30
---

gitweb是git的web接口，使用单向的http协议来发布git repositories。
<!-- more -->
关于gitweb在Apache服务器下的配置，见[gitweb配置(configuration)](https://openwares.net/linux/gitweb_configuration.html)

**配置**

假定git repositories所在的目录为/home/yourname/public_html/git，首先,把gitweb使用到的资源文件(图片和CSS)符号链接到此目录
$ln -sf /usr/share/gitweb/* .

然后将gitweb主程序gitweb.cgi链接到git repositories目录
$ln -sd /usr/lib/cgi-bin/gitweb.cgi gitweb.cgi

修改/etc/gitweb.conf文件中的$projectroot为/home/yourname/public_html/git

最后是nginx virtualhost配置文件：
1 server {  
2     listen      80;  
3     server_name git.openwares.net;  
4     root        /home/yourname/public_html/git;  
5     index       gitweb.cgi;  
6     access_log  off;  
7  
8     include     cgiwrap-fcgi.conf;  
9 }  

第8行 include cgiwrap-fcgi.conf; 让虚拟主机支持CGI应用程序,因为gitweb.cgi就是这样的CGI程序,nginx如何支持CGI程序见[debian squeeze配置nginx支持CGI程序](https://openwares.net/linux/nginx_cgi_support.html)