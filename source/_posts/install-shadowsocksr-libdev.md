---
title: 安装shadowsocksr-libdev
tags: []
id: '7954'
categories:
  - - uncategorized
date: 2018-07-18 09:06:30
---


<!-- more -->
```js
$ git clone https://github.com/shadowsocksrr/shadowsocksr-libev
$ cd shadowsocksr-libev
$ sudo apt-get install --no-install-recommends build-essential autoconf libtool libssl-dev \\
 gawk debhelper dh-systemd init-system-helpers pkg-config asciidoc xmlto apg libpcre3-dev
$ dpkg-buildpackage -b -us -uc -i
$ cd ..
$ sudo dpkg -i shadowsocks-libev*.deb
```