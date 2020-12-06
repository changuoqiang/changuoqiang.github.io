---
title: 站点迁移过程中遇到的几个小问题
tags:
  - Debian
id: '5598'
categories:
  - - GNU/Linux
date: 2014-06-11 15:06:04
---

迁移到linode啦
<!-- more -->
1、fonts.googleapis.com

最近一直感觉站点很慢，这次迁移时仔细测试了下，发现wordpress使用了google在线自体google fonts，因此需要访问fonts.googleapis.com，但是这个地址撞墙了，因此我们应该 #Fuck GFW# 先。

360这次总算做了次好事，提供了google fonts的国内CDN镜像。因此将fonts.googleapis.com更换为fonts.useso.com就好了，换完真的变快不少。

找到站点根目录，然后执行以下语句批量替换掉：
```js
$ sed -i 's/fonts\\.googleapis/fonts\\.useso/g' \`find . xargs grep -rl 'fonts.googleapis'\`
```

2、awstats的qqhostinfo插件

qqhostinfo插件用来通过访问者的ip查找其地理位置，因为其原来的查找脚本qqwry.pl代码太乱，我以前自己写了一个[ip_geo_qqwry.pl](https://openwares.net/linux/awstats_ip_geo_qqwrypl.html)，使用纯真网络的IP数据库。

[qqhostinfo](/downloads/qqhostinfo.pm)也做了很简单的修改，从qqwry.pl切换到了[ip_geo_qqwry.pl](/downloads/ip_geo_qqwry.zip),使用的IP数据库名字为qqwry.dat。

下载后将qqhostinfo.pm拷贝到/usr/share/awstats/plugins目录，将ip_geo_qqwry.pl和qqwry.dat拷贝到/usr/local/lib/site_perl目录就可以了。

最新的qqwry.dat数据库可以去纯真网络下载。

3、安装perl模块URI

awstats需要URI模块，不然会有错误提示:

Error: Plugin load for plugin 'decodeutfkeys' failed with return code: Error: Can't locate URI/Escape.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl/5.14.2 /usr/local/share/perl/5.14.2 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.14 /usr/share/perl/5.14 /usr/local/lib/site_perl . /usr/share/awstats/lib /usr/share/awstats/plugins) at (eval 3) line 1. 


不要使用CPAN来安装，那玩意太烦了，直接apt-get就好了:
```js
# apt-get install liburi-perl
```

**\===
\[erq\]**