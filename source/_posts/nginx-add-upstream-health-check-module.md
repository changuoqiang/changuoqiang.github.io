---
title: nginx添加upstream健康检查模块
tags:
  - Debian
  - Nginx
id: '8601'
categories:
  - - GNU/Linux
date: 2019-07-27 16:12:56
---


<!-- more -->
nginx社区版仅支持十分有限的upstream健康检查，其他高级特性需要商业订阅。
github上有个开源的upstream检查模块[nginx_upstream_check_module](https://github.com/yaoweibin/nginx_upstream_check_module)

**安装**

安装必要的编译环境
```js
$ sudo apt install build-essential patch libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl1.1 libssl-dev
```

下载最新的nginx stable ~~1.16~~ 1.22版本，clone nginx_upstream_check_module master分支
```js
//$ wget http://nginx.org/download/nginx-1.16.1.tar.gz
$ wget https://nginx.org/download/nginx-1.22.0.tar.gz
$ git clone https://github.com/yaoweibin/nginx_upstream_check_module
```

为源码打补丁
```js
//$ tar zxvf nginx-1.16.1.tar.gz
//$ cd nginx-1.16.1/
//$ patch -p1 < ../nginx_upstream_check_module/check_1.14.0+.patch
$ tar zxvf nginx-1.22.0.tar.gz
$ cd nginx-1.22.0/
$ patch -p1 < ../nginx_upstream_check_module/check_1.20.1+.patch
```

配置、编译、安装nginx
```js
$ ./configure --add-module=../nginx_upstream_check_module --with-http_ssl_module --with-stream_ssl_preread_module --with-http_v2_module --with-stream
...
Configuration summary
 + using system PCRE library
 + using system OpenSSL library
 + using system zlib library

 nginx path prefix: "/usr/local/nginx"
 nginx binary file: "/usr/local/nginx/sbin/nginx"
 nginx modules path: "/usr/local/nginx/modules"
 nginx configuration prefix: "/usr/local/nginx/conf"
 nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
 nginx pid file: "/usr/local/nginx/logs/nginx.pid"
 nginx error log file: "/usr/local/nginx/logs/error.log"
 nginx http access log file: "/usr/local/nginx/logs/access.log"
 nginx http client request body temporary files: "client_body_temp"
 nginx http proxy temporary files: "proxy_temp"
 nginx http fastcgi temporary files: "fastcgi_temp"
 nginx http uwsgi temporary files: "uwsgi_temp"
 nginx http scgi temporary files: "scgi_temp"
$ make
$ sudo make install
```
安装目录位于/usr/local/nginx

添加systemd服务nginx.service
将以下内容的文件nginx.service添加到/lib/systemd/system/nginx.service
```ini
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```

enable服务并启动
```js
$ sudo systemctl enable nginx.service 
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /lib/systemd/system/nginx.service.
$ sudo systemctl start nginx.service
```

**健康检查配置**

```js
http {
 upstream cluser {
server 192.168.0.17:8080;
server 192.168.0.18:8080;
server 192.168.0.19:8080;

check interval=1000 fall=1 rise=2 timeout=1000 default_down=true type=http;
check_http_send "HEAD /aurl/ HTTP/1.0\\r\\n\\r\\n";
}

 server {
 listen 80;
 server_name localhost;

 location /aurl/ {
proxy_pass http://cluser/aurl/;
 }

 location /status {
 check_status;
 }
 }
}
```
设置的检查间隔为1000毫秒，一次没有响应就标记节点down(fall)了，接连两次检查有响应节点才算up(rise)，没有检查之前节点的默认状态为down，使用http方式检查，检查的超时时间为1000毫秒，总之1000毫秒没有应答就是无响应。

使用_http方式_检查upstream服务的_业务入口/aurl/_是否已经就绪

**upstream状态**

访问http://your_ip/status查看检查结果
Nginx http upstream check status
Check upstream server number: 3, generation: 1

|Index|Upstream|Name|Status|Rise counts|Fall counts|Check type|Check port|
|---|---|---|---|---|---|---|---|
|0|cluser|192.168.0.17:8080|up|30|0|http|0|
|1|cluser|192.168.0.18:8080|up|19|0|http|0|
|2|cluser|192.168.0.19:8080|up|15|0|http|0|

References:

\[1\][Health checks upstreams for nginx](https://github.com/yaoweibin/nginx_upstream_check_module)

\[2\][HTTP Health Checks](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-health-check/)