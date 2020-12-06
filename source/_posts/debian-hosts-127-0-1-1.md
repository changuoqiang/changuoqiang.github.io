---
title: debian hosts文件中的 127.0.1.1 主机地址
tags:
  - Debian
id: '2839'
categories:
  - - GNU/Linux
date: 2013-01-30 10:11:08
---

有时候/etc/hosts文件会看到127.0.1.1这个地址,这是什么呢?
<!-- more -->
127.0.0.1这个loopback地址很常见，就是本地接口的回路/回环地址。但有时候/etc/hosts文件中还会出现127.0.1.1,这又是什么地址呢？这也是个本地回路/回环地址。

出现这个地址的原因是因为有些应用程序需要规范的全限定域名FQDN(Fully Qualified Domain Name)，FQDN不只需要主机名还需要主机域名，其表达形式为hostname.domainname

如果你的主机有一个静态IP地址，则FQDN名字解析到这个静态地址，否则解析到127.0.1.1这个本地回路地址。所以一般情况下不会看到127.0.1.1这个地址。

127.0.0.1一般只对应hostname，这也是二者的主要区别，如下

127.0.0.1 hostname
127.0.1.1 hostname.domainname

当然并一定非要用127.0.1.1这个IP,RFC规定的127.0.0.0/8这个IP段内的任意IP都可以，只要没有冲突，debian选择了127.0.1.1

查看主机名
# hostname 
hostname

查看FQDN名字
# hostname --fqdn
hostname.domainname