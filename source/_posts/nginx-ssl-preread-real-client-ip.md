---
title: nginx启用ssl_preread时获取客户真实ip地址
tags:
  - Nginx
id: '9158'
categories:
  - - GNU/Linux
date: 2020-02-07 16:48:38
---


<!-- more -->
使用ssl_preread分流请求时，真正的服务程序无法获取到真实的客户ip，这时候可以借助[proxy_protocol](https://www.haproxy.org/download/1.8/doc/proxy-protocol.txt)来获取真实的客户ip地址
```js
http {
 proxy_headers_hash_bucket_size 6400; #添加此行
 include mime.types;
 default_type application/octet-stream;

 log_format main '$proxy_protocol_addr - $remote_user \[$time_local\] "$request" '
 '$status $body_bytes_sent "$http_referer" '
 '"$http_user_agent" "$http_x_forwarded_for"'; #修改此行,用$proxy_protocol_addr替换$remote_addr
...

server {
 listen 8443 ssl http2 proxy_protocol default_server;#此行添加proxy_protocol指令
...
# ssl preread for request certs
stream {
 map $ssl_preread_alpn_protocols $tls_port {
 ~\\bacme-tls/1\\b 10443;
 default 8443;
 }
 server {
 listen 443;
 listen \[::\]:443;
 proxy_pass 127.0.0.1:$tls_port;
 proxy_protocol on; #添加此行
 ssl_preread on;
 }
}
```

这样access日志就可以获取到真实的客户ip地址($proxy_protocol_addr)了，但是nginx的error日志格式无法改变，只能更改日志级别，因此preread之后的错误日志就没办法了。