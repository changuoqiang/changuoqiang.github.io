---
title: openssl升级导致的shadowsocks报错问题
tags:
  - Debian
id: '7796'
categories:
  - - GNU/Linux
date: 2016-11-30 08:57:11
---


<!-- more -->
ss无法启动了，/var/log/shadowsocks.log报错:
```js
AttributeError: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup
```

是因为openssl1.1.0版本中，废弃了EVP_CIPHER_CTX_cleanup函数，可以用EVP_CIPHER_CTX_reset来代替此函数

此文件/usr/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py中搜索所有的EVP_CIPHER_CTX_cleanup以EVP_CIPHER_CTX_reset代替即可，总共有两处。

References:
\[1\][解决openssl升级到1.1.0后shadowsocks服务报错问题](https://blog.lyz810.com/article/2016/09/shadowsocks-with-openssl-greater-than-110/)

**\===
\[erq\]**