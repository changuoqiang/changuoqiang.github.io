---
title: nginx ssl 反向代理wordpress
tags:
  - Wordpress
id: '8475'
categories:
  - - GNU/Linux
date: 2019-07-07 19:49:02
---


<!-- more -->
wordpress部署在docker上，使用http协议，现在部署https协议，增设一个nginx服务器，反向代理http协议的wordpress

nginx反向代理需要增设协议头
```js
proxy_set_header X-Forwarded-Proto $scheme; 
```
完整的nginx反向代理设置
```js
server {
server_nameopenwares.net;
listen8443 ssl http2;

ssl_certificate /etc/nginx/ssl/fullchain.cer;
ssl_certificate_key /etc/nginx/ssl/openwares.net.key;
ssl_protocols TLSv1.3;

location / {
proxy_pass http://localhost/;
proxy_set_header Host $host;
 proxy_set_header X-Forwarded-Proto $scheme; 
 proxy_set_header Accept-Encoding "gzip";
}
}
```

编辑wordpress的wp-config.php文件，在文件前面添加
```js
define('FORCE_SSL_ADMIN', true);
if ($_SERVER\['HTTP_X_FORWARDED_PROTO'\] == 'https')
 $_SERVER\['HTTPS'\]='on';
```

最后需要参考\[3\]将数据库中的链接从http修改为https。

References:
\[1\][Administration Over SSL](https://wordpress.org/support/article/administration-over-ssl/)
\[2\][WordPress使用Nginx做反向代理的SSL设置](https://zhihu.websoft9.com/6408/wordpress%E4%BD%BF%E7%94%A8nginx%E5%81%9A%E5%8F%8D%E5%90%91%E4%BB%A3%E7%90%86%E7%9A%84ssl%E8%AE%BE%E7%BD%AE)
\[3\][MySQL Queries To Change WordPress From HTTP to HTTPS In The Database](https://isabelcastillo.com/mysql-wordpress-http-to-https)