---
title: squid 3 最简配置
tags: []
id: '6193'
categories:
  - - GNU/Linux
date: 2015-03-24 09:47:23
---


<!-- more -->
squid是老牌的代理服务器，支持代理多种网络协议，acl安全配置强大，但十分复杂。

如果简单的作为http代理，只需更改几个选项就可以了，其他默认。

安装
```js
# apt-get install squid3
```

编辑/etc/squid3/squid.conf
```js
# 配置一个需要访问squid的内网段
acl localnet src 192.168.0.0/24 # RFC1918 possible internal network 
# 允许从上面配置的内网段访问代理服务器
http_access allow localnet
```
就可以了

更改默认代理端口：
```js
http_port 3128 # 改成想用的端口就可以了
```

 **===
\[erq\]**