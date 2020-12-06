---
title: 申请Let’s Encrypt统配SSL证书
tags: []
id: '7910'
categories:
  - - uncategorized
date: 2018-06-02 12:29:05
---


<!-- more -->
**安装certbot**

stretch源里的版本太低，因此需要配置stretch backports源，然后用以下命令安装
```js
$ sudo apt-get install certbot -t stretch-backports
```

或者直接去官方下载安装使用：
```js
$ wget https://dl.eff.org/certbot-auto
$ chmod a+x ./certbot-auto
$ ./certbot-auto --help
```

**申请统配证书**
```js
$ sudo certbot certonly \\
--server https://acme-v02.api.letsencrypt.org/directory \\
--manual --preferred-challenges dns \\
-d *.openwares.net
```
或者如果手工安装certbot的话请用certbot-auto命令
这里只是申请证书，并不会自动安装，需要手工配置应用服务器，那些自动部署证书的插件并不是很好用。

要申请wildcard子域统配证书，certbot必须为0.22.0或以上版本，而且要使用ACMEv2服务器申请证书。

然后会有一通问题，看清楚回答即可，后面会要求为申请证书的域名配置TXT记录，类似如下：
```js
Please deploy a DNS TXT record under the name
_acme-challenge.openwares.net with the following value:

ZvjRBkEYcMVZSEslsuj*******************

Before continuing, verify the record is deployed.
```
按照要求配置域名TXT记录，确认TXT记录生效
```js
$ host -t TXT _acme-challenge.openwares.net
_acme-challenge.openwares.net descriptive text "ZvjRBkEYcMVZSEslsu************"
```
TXT记录生效可能稍微会需要一些时间，确认生效后继续,如果通过验证则会生成证书
```js
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
 /etc/letsencrypt/live/openwares.net/fullchain.pem
 Your key file has been saved at:
 /etc/letsencrypt/live/openwares.net/privkey.pem
 Your cert will expire on 2018-08-31. To obtain a new or tweaked
 version of this certificate in the future, simply run certbot
 again. To non-interactively renew *all* of your certificates, run
 "certbot renew"
 - If you like Certbot, please consider supporting our work by:

 Donating to ISRG / Let's Encrypt: https://letsencrypt.org/donate
 Donating to EFF: https://eff.org/donate-le
```

现在已经有了wildcard证书了，将证书配置到你的web服务器中就ok了。

证书的有效期只有三个月，距离失效期30日内，可以简单的执行以下命令来更新证书：
```js
$ sudo certbot renew
```

**\===
\[erq\]**