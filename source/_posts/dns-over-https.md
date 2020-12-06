---
title: DNS over HTTPS
tags:
  - Debian
id: '8565'
categories:
  - - GNU/Linux
date: 2019-07-20 14:50:53
---


<!-- more -->
DNS over HTTPS用于解决DNS解析的隐私问题

**Debian**
可以使用[dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy/wiki)

**MacOSX**
建议使用[dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy/wiki)

_安装cloudflared_
```js
$ brew install cloudflare/cloudflare/cloudflared
$ cloudflared --version
cloudflared version 2019.7.0 (built 2019-07-11-1655 UTC)
```

_添加配置文件config.yaml_
```js
$ mkdir -p /usr/local/etc/cloudflared
$ cat << EOF > /usr/local/etc/cloudflared/config.yml
proxy-dns: true
proxy-dns-upstream:
 - https://1.1.1.1/dns-query
 - https://1.0.0.1/dns-query
EOF
```

_安装服务_

```js
$ sudo cloudflared service install
INFO\[0000\] Installing Argo Tunnel client as a system launch daemon. Argo Tunnel client will run at boot 
INFO\[0000\] Outputs are logged to /Library/Logs/com.cloudflare.cloudflared.err.log and /Library/Logs/com.cloudflare.cloudflared.out.log
```

_卸载cloudflare_
```js
$ sudo cloudflared service uninstall
$ brew uninstall cloudflare/cloudflare/cloudflared
```

_校验_

```js
$ dig +short @127.0.0.1 cloudflare.com A
198.41.214.162
198.41.215.162
$ dig +short @127.0.0.1 cloudflare.com AAAA
2606:4700::c629:d7a2
2606:4700::c629:d6a2
```

_设置系统dns_

将系统DNS设置为127.0.0.1

**Firefox浏览器**

_DOH设置_

地址栏输入about:config进入配置界面，修改以下参数配置DOH：

network.trr.mode = 3 
#3为只使用DOH，1为关闭DOH特性，2为优先使用DOH，还可以fallback到传统dns

network.trr.uri = https://1.1.1.1/dns-query 
#cloudflare提供的DOH公共服务器

_ESNI设置_

同一个IP地址可以托管很多的站点,在建立TLS链接时[SNI](https://openwares.net/2009/09/21/server_name_indication/)域名会明文发送，Encrypted SNI就是为了解决这个问题，防止第三方窃取隐私。

network.security.esni.enabled设置为true打开Encrypted SNI浏览器支持

_服务器端_

OpenSSL尚未支持ESNI，因此下游的nginx当前亦不支持，相信很快就会支持。
[DEfO](https://defo.ie/)是一个为OpenSSL添加ENSI支持的项目[github地址](https://github.com/sftcd/openssl/tree/master/esnistuff)。

**chrome浏览器**

即将支持:-(，参考\[5\]
今年10月晚期发布的chrome 78会开始实验性的支持DOH，参见\[9\]
ESNI一样尚未支持

版本78以后，打开Secure DNS lookups
（chrome://flags/#dns-over-https）标志，并将系统dns设置为1.1.1.1和/或1.0.0.1

**References:**
\[1\][对比4种强化域名安全的协议——DNSSEC，DNSCrypt，DNS over TLS，DNS over HTTPS](https://program-think.blogspot.com/2018/10/Comparison-of-DNS-Protocols.html)
\[2\][Browsing Experience Security Check](https://www.cloudflare.com/ssl/encrypted-sni/)
\[3\][DNS over HTTPS](https://github.com/curl/curl/wiki/DNS-over-HTTPS)
\[4\][Trusted Recursive Resolver](https://wiki.mozilla.org/Trusted_Recursive_Resolver)
\[5\][Add DNS-over-HTTPS to chrome://flags](https://chromium-review.googlesource.com/c/chromium/src/+/1639663)
\[6\][Running a DNS over HTTPS Client](https://developers.cloudflare.com/1.1.1.1/dns-over-https/cloudflared-proxy/)
\[7\][dnscrypt-proxy](https://github.com/jedisct1/dnscrypt-proxy)
\[8\][MacOS 开启 DNS over HTTPS (DoH)](https://blog.ysoup.org/tech/doh.html)
\[9\][Google to run DNS-over-HTTPS (DoH) experiment in Chrome](https://www.zdnet.com/article/google-to-run-dns-over-https-doh-experiment-in-chrome/)
\[10\][Trusted Recursive Resolver](https://wiki.mozilla.org/Trusted_Recursive_Resolver)