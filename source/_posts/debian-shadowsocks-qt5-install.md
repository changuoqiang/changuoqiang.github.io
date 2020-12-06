---
title: debian安装shadowsocks-qt5
tags:
  - Debian
id: '6906'
categories:
  - - GNU/Linux
date: 2015-11-14 10:17:06
---


<!-- more -->
debian官方源里的shadowsocks最近用不了了。/var/log/shadowsocks.log里出现错误提示：
```js
ERROR M2Crypto is required to use aes-256-cfb, please run apt-get install python-m2crypto
```

但是实际上python-m2crypto已经安装了，重新安装也不行。那就换个客户端shadowsocks-qt5试试。

**安装依赖**
```js
$ sudo apt-get install qt5-qmake qtbase5-dev libqrencode-dev libappindicator-dev libzbar-dev libbotan1.10-dev
```

**安装libQtShadowsocks**
shadowsocks-qt5依赖于libQtShadowsocks,所以先安装libQtShadowsocks。

下载或clone libQtShadowsocks,项目根目录下执行:
```js
$ dpkg-buildpackage -uc -us -b
```

在上一级目录中生成三个deb包:
```js
libqtshadowsocks_1.8.0-1_amd64.deb 
libqtshadowsocks-dev_1.8.0-1_amd64.deb 
shadowsocks-libqtshadowsocks_1.8.0-1_amd64.deb
```

安装前两个即可
```js
$ sudo dpkg -i libqtshadowsocks_1.8.0-1_amd64.deb 
$ sudo dpkg -i libqtshadowsocks-dev_1.8.0-1_amd64.deb 
```

**安装shadowsocks-qt5**
下载或clone shadowsocks-qt5，项目根目录下执行:
```js
$ dpkg-buildpackage -uc -us -b
```

在上一级目录中生成：
```js
shadowsocks-qt5_2.6.0-1_amd64.deb
```

安装deb包
```js
$ sudo dpkg -i shadowsocks-qt5_2.6.0-1_amd64.deb
```

安装完成，配置见[Shadowsocks科学上网](https://openwares.net/linux/shadowsocks_fuck_gfw.html)。

References:
\[1\][shadowsocks-qt5](https://github.com/shadowsocks/shadowsocks-qt5)
\[2\][libQtShadowsocks](https://github.com/shadowsocks/libQtShadowsocks)
===
\[erq\]