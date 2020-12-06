---
title: firefox使用dnscrypt-proxy内建doh服务器
tags:
  - mac
id: '9163'
categories:
  - - Misc
date: 2020-02-10 10:08:04
---


<!-- more -->
dnscrypt-proxy内建doh服务器，可以为本机或外部提供doh服务

**本地使用**

先生成自签证书
```js
$ openssl req -x509 -nodes -newkey rsa:2048 -days 5000 -sha256 -keyout localhost.pem -out localhost.pem
```

编辑/usr/local/etc/dnscrypt-proxy.toml，添加
```js
\[local_doh\]
 listen_addresses = \['127.0.0.1:3000'\]
 path = "/dns-query"
 cert_file = "localhost.pem"
 cert_key_file = "localhost.pem"
```

重启dnscrypt-proxy服务
```js
$ sudo brew services restart dnscrypt-proxy
```

打开firefox浏览器，访问https://127.0.0.1:3000/dns-query并接受自签证书
然后输入about:config配置如下选项：
```js
network.trr.custom_uri = https://127.0.0.1:3000/dns-query
network.trr.uri = https://127.0.0.1:3000/dns-query
network.trr.resolvers = \[{ "name": "local", "url": "https://127.0.0.1:3000/dns-query" }\]
network.trr.mode = 3
network.security.esni.enabled = true
```

重新启动firefox，访问[Browsing Experience Security Check](https://www.cloudflare.com/ssl/encrypted-sni/)检查浏览器设置结果。

References:
\[1\][Local DoH](https://github.com/DNSCrypt/dnscrypt-proxy/wiki/Local-DoH)