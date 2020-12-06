---
title: 使用tls-alpn-01部署Let’s Encrypt证书
tags:
  - Debian
id: '8484'
categories:
  - - GNU/Linux
date: 2019-07-08 18:41:39
---


<!-- more -->
TLS-SNI-01已经deprecated，但certbot尚不支持tls-alpn-01验证方法，因此可以使用dehydrated或者acme.sh通过https来获取Let’s Encrypt证书。

使用TLS_ALPN获取证书，需要使用443端口进行验证，借助nginx的ngx_stream_ssl_preread_module模块，可以路由来自443的请求到不同的处理后端。

**确保nginx支持ssl_preread特性**

```js
$ nginx -V 2>&1 grep -o ssl_preread
ssl_preread
```

**配置nginx**
/etc/nginx/nginx.conf文件最后添加
```js
stream {
 map $ssl_preread_alpn_protocols $tls_port {
 ~\\bacme-tls/1\\b 10443;
 default 8443;
 }
 server {
 listen 443;
 listen \[::\]:443;
 proxy_pass 127.0.0.1:$tls_port;
 ssl_preread on;
 }
}
```
这样来自签发证书时的验证请求会被路由到10443端口，而其他对443端口的访问会被路由到8443端口，所以虚拟主机应该在8443端口上监听ssl连接。

reload nginx使新配置生效
```js
$ sudo systemctl reload nginx
```

**申请证书**

```js
# acme.sh --issue --alpn --tlsport 10443 -d openwares.net
``` 

**安装证书**
```js
# acme.sh --installcert -d openwares.net \\
 --key-file /etc/nginx/ssl/openwares.net.key \\
 --fullchain-file /etc/nginx/ssl/fullchain.cer \\
 --reloadcmd "systemctl force-reload nginx"
```

**更新证书**
```js
# acme.sh --renew -d openwares.net --force
```

**注意(updated 02/29/2020)：**
如果[启用了proxy_protocol](https://openwares.net/2020/02/07/nginx-ssl-preread-real-client-ip/)以获取客户端的真实地址，申请或者更新证书时会出现错误：
```js
Verify error:Error getting validation data
```
因此申请或更新证书时需要临时禁止proxy_protocol协议。

References:
\[1\][Deploying Let’s Encrypt certificates using tls-alpn-01 (https)](https://medium.com/@decrocksam/deploying-lets-encrypt-certificates-using-tls-alpn-01-https-18b9b1e05edf)
\[2\][使用TLS-ALPN-01验证签发证书](https://www.wuzhiyuan.com/2018/11/18/tls-alpn/)
\[3\][TLS ALPN without downtime](https://github.com/Neilpang/acme.sh/wiki/TLS-ALPN-without-downtime)
\[4\][ssl_preread_protocol, multiplex HTTPS and SSH on the same port](https://raymii.org/s/tutorials/nginx_1.15.2_ssl_preread_protocol_multiplex_https_and_ssh_on_the_same_port.html)