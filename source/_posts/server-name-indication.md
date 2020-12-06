---
title: 服务器名字指示SNI(Server Name Indication)
tags: []
id: '489'
categories:
  - - Misc
date: 2009-09-21 20:11:26
---

Server Name Indication是用来改善SSL(Secure Socket Layer)和TLS(Transport Layer Security)的一项特性。它允许客户端在服务器端向其发送证书之前请求服务器的域名。这对于在虚拟主机模式使用TLS是必要的。
<!-- more -->
**TLS背景**

加密一个面向流的通讯会话最常用的方法之一就是使用TLS协议。比如，当用户在浏览器的地址栏里面输入https时就是在使用这个协议。

为了确认用户想要连接的站点就是浏览器实际连接到的站点，TLS使用包含站点域名的数字签名证书。客户端软件(比如浏览器)通常信任这个证书，如果这个证书是由其内置信任的认证机构签发的。
在TLS启动阶段，客户端软件比较用户输入的URI的域名部分与在服务器证书里面找到的域名部分，如果比较失败，浏览器会提示用户，这个站点的证书存在问题。
**缺点**

SSL v2的设计顺应经典的公钥基础设施PKI(public key infrastructure)设计，后者认为一个服务器只提供一个服务从而也就只使用一个证书。这意味着服务器可以在TLS启动的早期阶段发送或提交证书，因为它知道它在为哪个域服务。

HTTP服务器开启虚拟主机支持后，每个服务器通过相同的地址可以为很多域提供服务。服务器检查每一个请求来决定它在为哪个域服务。这个信息通常从HTTP请求头获得。不幸的是，当设置了TLS加密，服务器在读取HTTP请求里面的域名之前已经向客户端提交了证书，也就是已经为默认域提供了服务。

因此，这种为虚拟主机提供安全的简单途径经常导致使用了错误的数字证书，从而导致浏览器对用户发出警告。

**钓鱼连接**

实际上，这意味着每一个HTTP服务器只能为一个域提供安全浏览。而事实上每一个web服务器都为很多域提供服务，结果就是其他的域无法使用安全通信，从而处于危险境地。此外，安全浏览的缺乏使浏览器无法认证服务器，亦即它无法校验站点是否真的是属于宣称它的那个人或实体。钓鱼的一个重要因素是他们企图通过虚假站点来获取用户的信息。使用SSL或者TLS安全连接，浏览器可以基于它的证书来认证站点。钓鱼站点不会作为一个欺骗性的站点得到认证，浏览器会警告这个安全风险。然而，没有安全HTTP就没有标准的方法去认证服务器，使这种钓鱼的企图很容易就能实现。

**修正**

一个叫做SNI的TLS扩展通过发送虚拟域的名字做为TSL协商的一部分修正了这个问题。这会使服务器更早的切换到正确的虚拟域，并且发送给浏览器包含正确名字的数字证书。

**行动**

在2005年，人们意识到从SSL v2到TLS没有很容易的升级路径，并且站点不得不升级他们的软件来。为了尽快的推进，Mozilla宣告完全抛弃对SSL v2的支持。Firefox社区确信其余的站点会升级他们的服务器到SSL v3或TLS v1。

从2005年开始，CAcert在虚拟服务器上用不同的方法使用TLS来进行试验，大部分试验是不满意并且不实际的。比如，可以使用subjectAltName在一个数字证书中包含多个域，但是这是一个证书，意味着所有的域必须被一个人拥有并控制，并且每次域列表发生变化，证书必须重新发放。

2004年，EdelKey project为OpenSSL里面的TLS/SNI开发了一个补丁。2006年这个补丁进入OpenSSL的开发分支，2007年，它被向后移植到了OpenSSL 0.9.8，也就是当前的发行版本。

**支持状况**

支持SNI的浏览器

 * Mozilla Firefox 2.0 or later
 * Opera 8.0 or later (the TLS 1.1 protocol must be enabled)
 * Internet Explorer 7 or later on Windows Vista or higher
 * Google Chrome (Vista, not XP)
 * Safari 3.2.1 Mac OS X 10.5.6

支持SNI的服务器

 * Apache 2.2.12 or later using mod_ssl (or alternatively with experimental mod_gnutls)
 * Cherokee if compiled with TLS support
 * Versions of lighttpd 1.4.x and 1.5.x with patch
 * Nginx with an accompanying OpenSSL built with SNI support
 * acWEB with OpenSSL 0.9.8j and later (on Windows)

支持SNI的库

 * Mozilla NSS 3.11.1 client side only
 * OpenSSL
 0.9.8f (released 11 Oct 2007) - not compiled in by default, can be compiled in with config option '--enable-tlsext'.
 0.9.8j (released 07 Jan 2009) - now compiled in by default
 Unreleased 0.9.9 is likely to include SNI compiled in by default.
 * GNU TLS

不支持SNI的操作系统,浏览器和库

客户端

 * Internet Explorer 6 or earlier and any IE version on Windows XP , windows 2003 or earlier
 * Konqueror/KDE in any version

服务器端

 * Microsoft Internet Information Server IIS (As of 2009).
 * Apache Tomcat 8 or earlier

库
 
 * Qt
 * Mozilla NSS server side
 * Python

**windows和IE**

可以看得出，windows XP和windows 2003 server系统上的任何IE版本浏览器都是不支持SNI的, vista及以后系统上的IE 7及更高版本的IE浏览器支持SNI。IE6及更早版本的IE浏览器在任何系统上都是不支持SNI的。

**tomcat**

tomcat当前的稳定版8尚不支持SNI,tomcat 9才会支持,以后可能会backport到tomcat 8和7。可以使用nginx反向https代理后端的tomcat,参见\[2\]

**SNI测试**

用浏览器或其他https客户端比如wget等访问SNI测试站点https://sni.velox.ch/即可以知道浏览器或客户端是否支持SNI。

References:
\[1\][Server Name Indication](https://en.wikipedia.org/wiki/Server_Name_Indication)
\[2\][Setting up NGINX SSL reverse proxy for Tomcat](http://webapp.org.ua/sysadmin/setting-up-nginx-ssl-reverse-proxy-for-tomcat/)
\[3\][HowTo setup Tomcat serving two SSL Certificates using SNI?](http://stackoverflow.com/questions/20190464/howto-setup-tomcat-serving-two-ssl-certificates-using-sni)

**\===
\[erq\]**