---
title: MAC平台PAC文件编写和自动代理配置
tags:
  - mac
id: '5354'
categories:
  - - Internet
date: 2014-03-27 23:38:17
---

使用PAC(Proxy auto-config)可以使用户代理根据不同的URL采用不同的代理访问策略。
<!-- more -->
PAC是由netscape在很早以前提出的,没想到在多年以后在我朝发扬光大。因为主流系统平台(linux/mac/windows)和用户代理(firefox,chrome,safari,opera)都支持PAC,因此使用PAC就可以在一个集中的位置来维护全局代理策略,再也不用为各个用户代理单独安装插件,单独维护代理策略了。

**PAC撰写**
PAC 文件用 JavaScript 编写,其入口函数为FindProxyForURL(url, host),用户代理调用此函数,根据返回值来决定如何访问指定的URL。

最简单,看起来没什么用处的PAC文件,所有的网址都不通过代理直接访问:

```js
function FindProxyForURL(url, host){
 return "DIRECT";
}
```

参数:

*   url
将要访问的网络地址
*   host
将要访问的网络地址中的host部分。比如访问https://www.github.com/path/to/resources,则host部分为www.github.com

返回值:

*   DIRECT
直接访问,不经过代理
*   PROXY host:port
使用HTTP代理访问
*   SOCKS host:port
使用SOCKS代理访问
*   SOCKS5 host:port
使用SOCKS5代理访问。注意safari虽然支持socks5,但不支持PAC文件返回的SOCKS5,会将返回的SOCKS5类型的代理忽略掉,只能识别SOCKS。因此对于SOCKS5代理,可以写两种形式,不支持的用户代理自动忽略即可。

PAC文件中可以使用的一些函数:

*   isPlainHostName(host) 判断是否是简单域名，例如 localhost 就是一个简单域名

*   dnsDomainIs(host, domain) 判断给定的 host 是否属于某个域名

*   dnsResolve(host) 做 DNS 解析，返回 host 的 ip，注意：DNS 解析可能会 block 住浏览器

*   isInNet(ip, subnet, netmask) 判断 ip 是否属于某个子网

*   myIpAddress() 返回本机的 ip (貌似不太可靠，见 wikipedia 的说明)

*   shExpMatch(str, pattern) 判断两个字符串是否匹配，pattern 中可以包含 shell 使用的通配符。不要使用javascript的RegExp

Reference\[2\]对PAC文件的编写描述的十分详细。

**PAC配置**
MAC现在已经不能使用本地的pac文件,必须通过网络访问PAC文件。可以将proxy.pac放在网络上,比如自己的VPS上。也可以开启本地web服务器,将其放在本地。
应该在web服务器上将pac文件的MIME类型设置为application/x-ns-proxy-autoconfig 或者 application/x-javascript-config,当然不设置也没有关系。
如果使用nginx,则在/etc/nginx/mime.types文件中添加即可。

启用本地apache服务:
```js
# apachectl start
```
然后将proxy.pac放入/Library/WebServer/Documens/目录下。

配置PAC代理时,填入http://localhost/proxy.pac即可。

References:
\[1\][一波三折的PAC on Mac](http://www.poemcode.net/2011/07/pac-on-mac/)
\[2\][PAC 文件及其调试](http://chenyufei.info/blog/2012-03-18/pac-and-debug/)

**\===
\[erq\]**