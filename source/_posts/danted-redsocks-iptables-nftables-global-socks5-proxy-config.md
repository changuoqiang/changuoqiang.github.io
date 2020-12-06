---
title: danted + redsocks + iptables/nftables全局socks5代理配置
tags:
  - Debian
id: '9314'
categories:
  - - GNU/Linux
date: 2020-06-28 17:46:44
---


<!-- more -->
1、danted
安装
```js
$ sudo apt install dante-server
```

配置/etc/danted.conf
```js
logoutput: syslog /var/log/sockd.log stdout
internal: br0 port = 1080
external: 10.100.0.32
clientmethod: none
socksmethod: none
user.privileged: proxy
user.unprivileged: nobody
user.libwrap: nobody
client pass {
 from: 0.0.0.0/0 port 1-65535 to: 0.0.0.0/0
}
socks pass {
 from: 0.0.0.0/8 to: 0.0.0.0/0
 command: bind connect udpassociate
 log: error
}
```

References:
\[1\]