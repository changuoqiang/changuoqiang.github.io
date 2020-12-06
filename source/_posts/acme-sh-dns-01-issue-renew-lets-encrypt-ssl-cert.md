---
title: acme.sh使用DNS-01申请/自动更新Let's Encrypt ssl证书
tags:
  - Debian
id: '9359'
categories:
  - - GNU/Linux
date: 2020-12-03 10:49:23
---


<!-- more -->
**安装acme.sh**
```js
$ curl https://get.acme.sh sh
$ source ~/.bashrc
```
会自动添加cron任务

**创建api token**

acme.sh支持name.com，访问https://www.name.com/account/settings/api，随意设置token昵称acme_sh_dns，生成token
编辑~/.acme.sh/account.conf添加如下两行：
```js
export Namecom_Username="your_name_com_username"
export Namecom_Token="*********"
```
Namecom_Username指定你在name.com的用户名而不是token name

**申请证书**
```js
$ acme.sh --issue --dns dns_namecom -d g.openwares.net
```
可以会有提示
```js
g.openwares.net:Verify error:DNS problem: SERVFAIL looking up CAA for openwares.net - the domain's nameservers may be malfunctioning
```
忽略即可

**安装证书**

```js
$ acme.sh --install-cert -d g.openwares.net \\
--cert-file /path/to/certfile/cert.pem \\
--key-file /path/to/keyfile/key.pem \\
--fullchain-file /path/to/fullchain/certfile/fullchain.pem
```

**自动更新**
acme.sh自动安装了crontab入口，acme.sh会自动记录下申请证书和安装证书的命令，所以会在设定的周期内自动更新证书。