---
title: Shadowsocks科学上网
tags: []
id: '6496'
categories:
  - - GNU/Linux
date: 2015-06-26 14:52:41
---

ssh tunnel全面失效,WTF!
<!-- more -->
ssh tunnel无论如何更改端口都无效了，听说Shadowsocks科学上网不错，记录一下安装过程．

为了使用Gmail也是拼了！当然前提是要有个VPS,我用linode．

**服务器端**

安装

/etc/apt/sources.list目录下添加shadowsocks.list,文件内容如下：
```js
deb http://shadowsocks.org/debian wheezy main
```

添加GPG公钥
```js
$ wget -O- http://shadowsocks.org/debian/1D27208A.gpg sudo apt-key add -
```

最后安装：
```js
$ sudo apt-get update
$ sudo apt-get install shadowsocks-libev
```

配置:
/etc/shadowsocks-libev/config.json
```js
{
 "server":"your_server_ip",
 "server_port":8388,
 "local_port":1080,
 "password":"barfoo!",
 "timeout":60,
 "method":"aes-256-cfb"
}
```

填上服务器密码,修改一下访问密码,加密方法选择高强度加密方法aes-256-cfb,最后重新启动shadowsocks-libev即可．
```js
$ sudo service shadowsocks-libev restart
```

**客户端**

linux(debian testing Stretch):
安装
```js
$ sudo apt-get install shadowsocks
```

配置:
/etc/shadowsocks/config.json
```js
{
 "server":"my_server_ip",
 "server_port":8388,
 "local_address": "127.0.0.1",
 "local_port":1080,
 "password":"mypassword",
 "timeout":300,
 "method":"aes-256-cfb",
 "fast_open": false,
 "workers": 1
}
```
修改与服务器相关的item
默认安装的shadowsocks是用于启动服务器的,因此修改一下/etc/init.d/shadowsocks使其用于运行客户端daemon程序
```js
...
#DAEMON=/usr/bin/ssserver # Introduce the server's location here
DAEMON=/usr/bin/sslocal # Introduce the cilent's location here
...
```

保存后重新启动shadowsocks
```js
$ sudo service shadowsocks restart
```

客户端软件访问本地端口127.0.0.1:1080即可．

Mac OS X:
下载安装[ShadowsocksX](https://github.com/shadowsocks/shadowsocks-iOS/releases)

References:
\[1\][shadowsocks](https://github.com/shadowsocks/shadowsocks)
\[2\][shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
\[3\][Shadowsocks (简体中文)](https://wiki.archlinux.org/index.php/Shadowsocks_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))

**\===
\[erq\]**