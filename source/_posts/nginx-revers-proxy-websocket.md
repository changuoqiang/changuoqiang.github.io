---
title: nginx反向代理websocket
tags:
  - Nginx
id: '6857'
categories:
  - - GNU/Linux
date: 2015-11-05 13:15:33
---


<!-- more -->
配置文件中添加如下行:

```js
server {
...
 location /wsapp/ {
 proxy_pass http://wsbackend;
 
 # proxy websocket reverse
 proxy_http_version 1.1;
 proxy_set_header Upgrade $http_upgrade;
 proxy_set_header Connection "upgrade";
 }
...
}
```

References:
\[1\][NGINX as a WebSocket Proxy](https://www.nginx.com/blog/websocket-nginx/)

**\===
\[erq\]**