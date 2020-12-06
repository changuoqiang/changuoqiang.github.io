---
title: certbot验证方法TLS-SNI-01即将过时
tags: []
id: '8202'
categories:
  - - uncategorized
date: 2018-12-29 21:19:22
---

Let's Encrypt因为安全性问题已经将TLS-SNI-01验证方法标记为过时，而且很快就不能使用了。
<!-- more -->
今天renew站点的证书时，突然提示开始使用http-01验证方式，然鹅80端口并没有配置，所以毫无悬念的更新失败了。

临时更改了renew的配置文件/etc/letsencrypt/renewal/xxx.com.conf，在renewalparams节添加参数
```js
pref_challs=tls-sni-01
```
或者也可以在命令行添加
```js
--preferred-challenges tls-sni-01
```
然后renew证书成功，但出现deprecated提示:
```js
TLS-SNI-01 is deprecated, and will stop working soon.
```
下次renew证书就要改用http-01或者dns-01了。

References:
\[1\][Upcoming TLS-SNI Deprecation in Certbot](https://community.letsencrypt.org/t/upcoming-tls-sni-deprecation-in-certbot/76383)
\[2\][Let's Encrypt: Migrating From TLS-SNI-01](https://www.vultr.com/docs/let-s-encrypt-migrating-from-tls-sni-01)