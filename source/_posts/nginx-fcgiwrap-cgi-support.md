---
title: 使用fcgiwrap为nginx提供cgi支持
tags:
  - Nginx
id: '2913'
categories:
  - - GNU/Linux
date: 2013-05-11 23:40:15
---

nginx不支持cgi程序，通过fcgi包装程序，可以使nginx间接支持cgi程序。
<!-- more -->
现在fcgiwrap已经进入了官方源，因此[以前的fcgi包装方法](https://openwares.net/linux/nginx_cgi_support.html)就不用了。

**安装**

#apt-get install fcgiwrap

**配置** 

/etc/nginx/fcgiwrap.conf
```js
location ~ \\.(cgipl).*$ {
 gzip off;
 fastcgi_pass unix:/var/run/fcgiwrap.socket;
 fastcgi_index index.cgi;
 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
 include fastcgi_params;
}
```

**使用**

在站点配置文件中包含fcgiwrap.conf即可
...
include fcgiwrap.conf
...

**配置 -TCP方式**
还可以将fcgiwrap配置成TCP方式提供服务，不过这需要修改/etc/init.d/fcgiwrap服务脚本

#socket 方式配置
# FCGI_APP Variables
FCGI_CHILDREN="1"
FCGI_SOCKET="/var/run/$NAME.socket"

改为
#TCP 方式
# FCGI_APP Variables
FCGI_CHILDREN="1"
FCGI_PORT="8999"
FCGI_ADDR="127.0.0.1"

然后修改/etc/nginx/fcgiwrap.conf为：
```js
location ~ \\.(cgipl).*$ {
 gzip off;
 fastcgi_pass 127.0.0.1:8999;
 fastcgi_index index.cgi;
 fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
 include fastcgi_params;
}
```

参见[Nginx and Perl-FastCGI on Debian 6](https://library.linode.com/web-servers/nginx/perl-fastcgi/debian-6-squeeze)