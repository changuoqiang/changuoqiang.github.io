---
title: macos编译安装rtorrent
tags: []
id: '9120'
categories:
  - - Misc
date: 2020-01-28 16:08:54
---


<!-- more -->
确保安装xcode和brew

安装编译工具和部分依赖
```js
$ brew install automake libtool boost curl lzlib libsigc++ openssl xmlrpc-c
```

编译安装libtorrent
```js
$ git clone https://github.com/rakshasa/libtorrent.git
$ cd libtorrent
$ ./autogen.sh
$ CC=clang CXX=clang++ CXXFLAGS="-Wno-deprecated-declarations -O3 -std=c++11 -stdlib=libc++ -I/usr/local/opt/openssl/include" LDFLAGS="-L/usr/local/opt/openssl/lib" ./configure
$ make
$ make install
```
libtorrent安装到/usr/local/lib

编译安装rtorrent
```js
$ git clone https://github.com/rakshasa/rtorrent.git
$ cd rtorrent
$ ./autogen.sh
$ export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
$ CC=clang CXX=clang++ CXXFLAGS="-Wno-deprecated-declarations -O3 -std=c++11 -stdlib=libc++ -I/usr/local/opt/openssl/include" LDFLAGS="-L/usr/local/opt/openssl/lib" ./configure --with-xmlrpc-c
$ make
$ make install
```
rtorrent安装到/usr/local/bin

运行
```js
$ rtorrent
```
默认配置文件为~/.rtorrent.rc

References:
\[1\][libtorrent and rtorrent on mac.sh](https://gist.github.com/doctorpangloss/ecfbe70c61de9332698d4d4445848f81)
\[2\][rTorrent cheatsheet](https://devhints.io/rtorrent)
\[3\][Navigating](https://github.com/rakshasa/rtorrent/wiki/User-Guide#navigating)