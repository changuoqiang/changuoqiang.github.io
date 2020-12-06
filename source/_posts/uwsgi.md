---
title: uWSGI简介
tags:
  - Debian
id: '6290'
categories:
  - - GNU/Linux
date: 2015-04-06 22:31:50
---


<!-- more -->
为了实现动态web,我们发展出了各式各样的技术，那真是五花八门，乱花渐欲迷人眼。

各种网关接口协议，从最古老的[CGI](http://en.wikipedia.org/wiki/Common_Gateway_Interface)(Common Gateway Interface)到[SCGI](http://python.ca/scgi/protocol.txt)(Simple Common Gateway Interface),[FastCGI](http://www.fastcgi.com/drupal/),[WSGI](https://www.python.org/dev/peps/pep-0333/)(Python Web Server Gateway Interface),[PSGI](http://plackperl.org/)(Perl Web Server Gateway Interface),[rack](http://rack.github.io/),[WSAPI](http://keplerproject.github.io/wsapi/)(Lua Web Server API),甚至还出现了JWSGI(Java Web Server Gateway Interface)等,当然还有HTTP协议。这些协议大部分已经标准化，还有许许多多的私有协议。只有协议是不够的，所以又有了对协议的各种各样的实现，比如[php-fpm](http://php-fpm.org/),[spawn-fcgi](http://redmine.lighttpd.net/projects/spawn-fcgi/wiki),[fcgiwrap](http://wiki.nginx.org/Fcgiwrap),[uWSGI](http://uwsgi-docs.readthedocs.org/en/latest/index.html#)等

web server也通过很多内置的模块来直接实现对动态web支持，比如[mod_perl](https://perl.apache.org/),[mod_python](http://modpython.org/),mod_php,[mod_lua](http://httpd.apache.org/docs/trunk/mod/mod_lua.html)等。

传统的web server，比如apache,nginx等，自身处理静态资源请求，然后将动态资源请求通过内置模块或者支持相关网关协议的application server转发到相应的应用程序来处理。当然也有tomcat此类的应用服务器，可以通过http来与传统的web服务器进行集成，甚至自身完全担当起application server和web server两种角色。有很多web框架自己也提供了http服务器。但一般来讲传统的web server除了处理静态资源性能上的优势，还有其他很多丰富的功能，比如访问控制，反向代理，负载均衡等等。

为什么会有这么多的协议，这么多的模块？应该讲主要还是性能方面的考量，动态web从无到有，从小规模到大规模，还要面对各种各样的后端开发技术，有这么多的协议和模块也是无可避免的。

一般来讲，部署一个动态应用可以有多种不同的选择。比如部署php应用可以使用php-fpm,也可以使用mod_php,甚至也可以使用其他的FCGI服务器，只要FCGI服务器实现了对PHP的支持即可。

**uWSGI是个什么东东?**

uWSGI是一个应用服务器，支持几乎所有现有的网关接口协议，同时自己也实现了另一个网关接口协议，叫做[uwsgi](http://uwsgi-docs.readthedocs.org/en/latest/Protocol.html)。这么多接口了，为什么再造一个？据说还是性能，据说uwsgi比fastcgi和wsgi都快的多。

且不论uWSGI的性能有多高，只是能支持几乎所有的网关接口协议就已经很不错了。nginx已经内置支持uWSGI,这样nginx + uWSGI这种组合可以应对各种各样的后端应用，部署和管理起来都方便的多。

nginx不支持CGI,只能通过[FastCGI](https://openwares.net/internet/fastcgi_intro.html)来调用CGI程序。

References:
\[1\][uWSGI](http://uwsgi-docs.readthedocs.org/en/latest/index.html)
\[2\][Running (almost) anything on Nginx with uWSGI](http://metz.gehn.net/2013/02/running-anything-on-nginx-with-uwsgi/)

**\===
\[erq\]**