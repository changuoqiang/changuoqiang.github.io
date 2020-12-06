---
title: FastCGI介绍
tags: []
id: '1354'
categories:
  - - Internet
date: 2011-04-22 21:16:21
---

FastCGI是web服务器与交互式应用程序之间的接口协议。
<!-- more -->
FastCGI是早期CGI(Common Gateway Interface)的进化,FastCGI的主要目标是减少web服务器与CGI程序接口之间的性能开销，允许服务器一次处理更多的web页面请求。

**历史渊源**

CGI是web服务器与外部应用程序的接口协议。CGI程序运行在与web服务器分离的单独进程中,web服务器的每一个请求到来时建立CGI进程，请求结束时销毁CGI进程。这种“每个请求建立一个新进程”的模型，使CGI程序十分容易实现，但是严重限制了效率和伸缩性。在负载很高时，操作系统的进程创建和销毁负担变的很重。此外，CGI进程模型限制了资源复用技术，比如重用数据库连接，内存缓冲等

为了克服CGI的这些缺陷，Open Market公司开发了FastCGI,1990年代中期在他们的服务器产品中第一次引入了FastCGI技术。Open Market起初开发FastCGI技术是为了与Netscape专有的，用于开发web应用程序的web服务器进程内API(NSAPI)竞争。

虽然最初由Open Market开发，FastCGI也被其他的一些web服务器实现。FastCGI与其他加速和简化服务器与应用程序通讯的技术产生了竞争。Apache的mod_perl和mod_php模块也在同一时期出现，并且很快流行起来。时至今日，这些不同的技术，也包括古老的CGI技术，都还在不同的场合使用。

**FastCGI实现**

相对于每个请求建立一个新的进程，FastCGI使用一个持续的进程来处理一系列的请求。这些进程归属于FastCGI服务器而不是web服务器。

为了满足一个请求，web服务器通过unix domain socket(FastCGI进程与web服务器在一台机器上)或者TCP连接(FastCGI进程在远程服务器上或者FastCGI进程与web服务器在一台机器上)向FastCGI进程发送环境变量信息和页面请求信息。FastCGI的回应通过原路返回给web服务器，web服务器随即向最终用户交付这个响应。连接可能在响应结束后关闭，但是web服务器和FastCGI服务进程是持续存在的。

每一个单独的FastCGI进程在它的生命周期内可以处理很多的请求，因此避免了每请求进程创建和销毁的开销。可以配置多个FastCGI服务器来增加可靠性和伸缩性。

web站点管理员和开发者会发现web应用程序从web服务器分离到FastCGI比起那些嵌入式的解释器比如mod_perl和mod_php等有更多的优势。这种分离允许web服务器和应用程序进程可以独立的重新配置和启动，对于一些繁忙的站点来说这很重要。不同类型的请求可以分发到为此种请求优化过的、更高效的专用FastCGI服务器处理。

**PHP-FPM**

PHP-FPM (FastCGI Process Manager)是PHP的一个FastCGI实现，从PHP 5.3.3开始php-fpm已经并入php core，随php一起发行。

**\===
\[erq\]**