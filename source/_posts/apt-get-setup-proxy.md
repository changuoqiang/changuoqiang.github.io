---
title: 为apt-get设置代理服务器
tags:
  - Debian
id: '6198'
categories:
  - - GNU/Linux
date: 2015-03-24 10:01:16
---


<!-- more -->
1.  使用配置文件
在全局配置文件中添加如下格式的代理：
```js
Acquire::http::Proxy "http://proxy_ip:8080";
Acquire::ftp::proxy "ftp://proxy_ip:8000/";
Acquire::https::proxy "https://proxy_ip:8000/";
Acquire::socks::proxy "socks://proxy_ip:proxy_port/";
# 如果ftp需要登陆
Acquire::ftp
 {
 Proxy "ftp://proxy_ip:2121/";
 ProxyLogin
 {
 "USER $(SITE_USER)@$(SITE)";
 "PASS $(SITE_PASS)";
 }
 }
```
或者在apt-get 命令行指定参数文件的位置：
```js
# apt-get -c ~/apt_proxy.conf update
```
2.  命令行参数
```js
# apt-get -o Acquire::http::proxy="http://proxy_ip:proxy_port/" update
# apt-get -o Acquire::http::proxy="http://proxy_ip:proxy_port/" upgrade
```
3.  全局环境变量
```js
$ export http_proxy=http://proxy_ip:proxy_port
```
不过貌似apt-get不是用全局代理配置了？

**\===
\[erq\]**