---
title: Nginx部署Let's Encrypt证书
tags:
  - Debian
id: '7275'
categories:
  - - GNU/Linux
date: 2016-05-14 14:06:13
---


<!-- more -->
**感谢[Let's Encrypt](https://letsencrypt.org/)让互联网更安全。**

Let's Encrypt的客户端刚刚更名为certbot,以前叫letsencrypt。certbot可以自动化的申请，安装和更新证书，让生活更美好。
不过当前nginx插件尚不成熟，而且certbot自身尚处于beta阶段，当前版本0.7.0，debian源里的版本也比较陈旧。

因此还是需要一些简单的手工配置。

**安装**

从官方仓库克隆certbot
```js
$ sudo git clone https://github.com/certbot/certbot /opt/certbot
```

执行certbot-auto会自动安装发行版依赖和python依赖：
```js
$ cd /opt/certbot
$ ./certbot-auto 
```

**配置nginx**

申请证书时，let's encrypt需要访问域名的特定目录来确认域名的所有权，由certbot配合来完成验证。

需要访问的目录为${webroot-path}/.well-known/acme-challenge/,申请证书时,certbot会写入认证所需信息，由let's encrypt来验证。

将此目录映射到/var/www/letsencrypt,先建立目录：
```js
$ cd /var/www
# mkdir letsencrypt
# chgroup www-data letsencrypt
```

然后修改站点配置文件：
```js
server {
 listen 80 default_server;
 server_name my-domain;

 location /.well-known/acme-challenge {
 root /var/www/letsencrypt;
 }
 ...
}
```

最后重新加载nginx配置文件:
```js
# nginx -t && sudo nginx -s reload
```

**配置certbot**

新建一个配置文件/etc/letsencrypt/configs/my-domain.conf来指定要申请证书的域名等相关信息：
```js
# This is an example of the kind of things you can do in a configuration file.
# All flags used by the client can be configured here. Run Certbot with
# "--help" to learn more about the available options.

# Use a 4096 bit RSA key instead of 2048
rsa-key-size = 2048 # or 4096

# Uncomment and update to register with the specified e-mail address
email = xxx@gmail.com

# Uncomment and update to generate certificates for the specified
# domains.
domains = my-domain, www.my-domain

# Uncomment to use a text interface instead of ncurses
text = True

# Uncomment to use the standalone authenticator on port 443
# authenticator = standalone
# standalone-supported-challenges = tls-sni-01

# Uncomment to use the webroot authenticator. Replace webroot-path with the
# path to the public_html / webroot folder being served by your web server.
authenticator = webroot
webroot-path = /var/www/letsencrypt/
```

可以使用webroot插件来减轻验证配置，自动修改web server来完整验证。

**申请证书**

因为let's encrypt限制每个站点在一定时间内申请的证书数量，所以可以用`--test-cert`选项进行测试，此时申请的证书是无效的，
但操作步骤是完全一样的，测试通过后去掉此选项就是申请正式证书了。

```js
$ ./certbot-auto --test-cert --config /etc/letsencrypt/configs/mydomain.conf certonly
Checking for new version...
Requesting root privileges to run certbot...
 sudo CERTBOT_AUTO=./certbot-auto /home/xxx/.local/share/letsencrypt/bin/letsencrypt 
--test-cert --config /etc/letsencrypt/configs/mydomain certonly

-------------------------------------------------------------------------------
Please read the Terms of Service at https://letsencrypt.org/documents/LE-
SA-v1.0.1-July-27-2015.pdf. You must agree in order to register with the ACME
server at https://acme-staging.api.letsencrypt.org/directory
-------------------------------------------------------------------------------
(A)gree/(C)ancel: A

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at
 /etc/letsencrypt/live/mydomain/fullchain.pem. Your cert
 will expire on 2016-08-12. To obtain a new version of the
 certificate in the future, simply run Certbot again.
 - If you lose your account credentials, you can recover through
 e-mails sent to xxx@gmail.com.
 - Your account credentials have been saved in your Certbot
 configuration directory at /etc/letsencrypt. You should make a
 secure backup of this folder now. This configuration directory will
 also contain certificates and private keys obtained by Certbot so
 making regular backups of this folder is ideal.
```

申请的证书位于/etc/letsencrypt/live/mydomain/目录下

**安装证书**

```js
server {
 listen 443 ssl default_server;
 server_name my-domain;

 ssl_certificate /etc/letsencrypt/live/my-domain/fullchain.pem;
 ssl_certificate_key /etc/letsencrypt/live/my-domain/privkey.pem;

 ...
}
```

更多ssl优化设置参见\[4\]

**更新证书**

let's encrypt发行的证书只有90天的有效期，到期需要更新证书。如果参数没有变化，更新证书只需简单的执行:

```js
$ ./certbot-auto renew
```

certbot-auto会使用上次申请证书时使用的参数来更新证书。
如果要测试证书更新，添加选项`--dry-run`，此时不会更改系统当前设置。
```js
$ ./certbot-auto renew --dry-run
Checking for new version...
Requesting root privileges to run certbot...
 sudo CERTBOT_AUTO=./certbot-auto /home/guoqiang/.local/share/letsencrypt/bin/letsencrypt renew --dry-run

-------------------------------------------------------------------------------
Processing /etc/letsencrypt/renewal/cucc.tazzfdc.com.conf
-------------------------------------------------------------------------------
** DRY RUN: simulating 'certbot renew' close to cert expiry
** (The test certificates below have not been saved.)

Congratulations, all renewals succeeded. The following certs have been renewed:
 /etc/letsencrypt/live/cucc.tazzfdc.com/fullchain.pem (success)
** DRY RUN: simulating 'certbot renew' close to cert expiry
** (The test certificates above have not been saved.)
```

**自动更新证书**

可以添加cron脚本来自动更新证书，当证书无需更新时，renew命令并不会去更新证书，所以crontab设置的时间间隔并无强制要求，但一般无需设置太过频繁的调度。
let's encrypt证书大约还剩一个月有效期时，可以进行更新。

自动更新脚本renew‑letsencrypt.sh：
```js
#!/bin/bash

cd /opt/certbot/
./certbot-auto renew
if \[ $? -ne 0 \]; then
 ERRORLOG=\`tail /var/log/letsencrypt/letsencrypt.log\`
 echo -e "The Let's Encrypt cert has not been renewed! \\n \\n" \\
 $ERRORLOG
else
 nginx -s reload
fi

exit 0
```

将脚本添加到crontab自动运行即可。比如，每月1号执行此脚本：
```js
0 0 1 * * /usr/local/bin/renew-letsencrypt.sh
```

**未来**

以上安装配置仍然十分繁琐，nginx插件成熟并且进入官方源后，只要几条指令就可以安装和更新证书了：

安装certbot:
```js
# apt install certbot certbot-nginx
```

安装证书：
```js
$ certbot --nginx
```

更新证书：
```js
$ certbot renew
```

References:
\[1\][Getting Started](https://letsencrypt.org/getting-started/)
\[2\][User Guide](https://certbot.eff.org/docs/using.html#installation)
\[3\][Using Free SSL/TLS Certificates from Let’s Encrypt with NGINX](https://www.nginx.com/blog/free-certificates-lets-encrypt-and-nginx/)
\[4\][Configuring HTTPS servers](http://nginx.org/en/docs/http/configuring_https_servers.html)

**\===
\[erq\]**