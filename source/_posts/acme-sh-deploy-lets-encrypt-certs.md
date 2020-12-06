---
title: 使用acme.sh自动部署Let’s Encrypt证书
tags:
  - Debian
id: '8216'
categories:
  - - GNU/Linux
date: 2019-01-19 11:08:45
---


<!-- more -->
TLS-SNI-01已经deprecated，但certbot尚不支持tls-alpn-01验证方法，因此可以使用dehydrated或者acme.sh通过https来获取Let’s Encrypt证书。

下面使用acme.sh，由于使用80，443端口的权限，拷贝证书文件的权限以及reload nginx的权限等问题，使用acme.sh正确的姿势应该是使用root账户来运行。

**安装**

```js
# curl https://get.acme.sh sh
# source ~/.bashrc # 使acme.sh alias生效
```

如果使用acme.sh standalone方式来获取证书，还需要安装socat
```js
$ sudo apt install socat
```

**http方式获取证书**

http验证支持standalone、webroot或webserver(apache,nginx)方式获取证书，获取证书的过程不会破坏系统环境。

standalone方式,acme.sh会启动一个使用80端口的web server
```js
# acme.sh --issue -d mydomain.com --standalone
```
80端口需要特权用户才能监听

webroot方式，指定正在运行的网站的root目录
```js
# acme.sh --issue -d mydomain.com -d www.mydomain.com --webroot /home/wwwroot/mydomain.com/
```

webserver方式，指定使用的web server，目前支持apache和nginx
```js
# acme.sh --issue -d mydomain.com --apache
# acme.sh --issue -d mydomain.com --nginx
```

默认申请的是RSA证书，acme.sh同样支持申请ECC证书，只要添加额外的`--keylength`参数即可，支持申请256和384位的ECC证书
```js
# acme.sh --issue -d mydomain.com --standalone --keylength ec-256
```

**安装证书**

```js
# acme.sh --installcert -d mydomain.com \\
 --key-file /etc/nginx/ssl/mydomain.com.key \\
 --fullchain-file /etc/nginx/ssl/fullchain.cer \\
 --reloadcmd "systemctl force-reload nginx"
```

**自动更新证书**

acme.sh自动安装了crontab入口，acme.sh会自动记录下申请证书和安装证书的命令，所以会在设定的周期内自动自行这些指令。

**手动更新证书**

```js
# acme.sh --renew -d example.com --force
```

或者ECC证书

```js
# acme.sh --renew -d example.com --force --ecc
```

**acme.sh自动更新**

```js
# acme.sh --upgrade --auto-upgrade
```

关闭自动更新

```js
# acme.sh --upgrade --auto-upgrade 0
```

手动更新

```js
# acme.sh --upgrade
```

**卸载**
```js
# acme.sh --uninstall
```

References:
\[1\][Deploying Let’s Encrypt certificates using tls-alpn-01 (https)](https://medium.com/@decrocksam/deploying-lets-encrypt-certificates-using-tls-alpn-01-https-18b9b1e05edf)
\[2\][使用TLS-ALPN-01验证签发证书](https://www.wuzhiyuan.com/2018/11/18/tls-alpn/)
\[3\][dehydrated](https://github.com/lukas2511/dehydrated)
\[4\][acme.sh](https://github.com/Neilpang/acme.sh)
\[5\][TLS ALPN without downtime](https://github.com/Neilpang/acme.sh/wiki/TLS-ALPN-without-downtime)
\[6\][acme.sh中文说明](https://github.com/Neilpang/acme.sh/wiki/%E8%AF%B4%E6%98%8E)