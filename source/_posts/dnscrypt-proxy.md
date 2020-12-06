---
title: dnscrypt-proxy
tags:
  - Debian
id: '8813'
categories:
  - - GNU/Linux
date: 2019-10-10 09:38:42
---


<!-- more -->
**端口绑定错误**
dnscrypt-proxy默认设置是绑定到53端口，1024以下的端口为特权端口，普通用户并无权绑定，启动时提示:
```js
\[FATAL\] listen udp 127.0.0.1:53: bind: permission denied
```
尝试authbind无果，/lib/systemd/system/dnscrypt-proxy.service文件中的ExecStart修改为:
```js
ExecStart=/usr/bin/authbind --deep /usr/sbin/dnscrypt-proxy -config /etc/dnscrypt-proxy/dnscrypt-proxy.toml
```
并设置了authbind的byport,byuid,byaddr皆无果，修改User=root了事。

**动态生成blacklist**
官方提供了一个python脚本[generate-domains-blacklist.py](https://github.com/DNSCrypt/dnscrypt-proxy/tree/master/utils/generate-domains-blacklists)，可以从多个来源动态生成blacklist列表文件。

下载generate-domains-blacklist.py，domains-blacklist-local-additions.txt，domains-blacklist.conf，domains-time-restricted.txt，domains-whitelist.txt这几个文件，然后执行
```js
$ ./generate-domains-blacklist.py > blacklist.txt
```
dnscrypt-proxy.toml中配置blacklist使用生成的blacklist.txt文件即可。
可以使用cron周期性自动重新生成/更新blacklist.txt文件。

References:
\[1\][dnscrypt-proxy wiki](https://github.com/DNSCrypt/dnscrypt-proxy/wiki)