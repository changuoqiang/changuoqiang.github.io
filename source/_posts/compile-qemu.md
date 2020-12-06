---
title: 编译qemu
tags:
  - Debian
id: '8373'
categories:
  - - GNU/Linux
date: 2019-06-11 20:05:08
---


<!-- more -->
**安装编译环境和必要的附加组件**

```js
$ sudo apt install dkms build-essential pkg-config libglib2.0-dev libpixman-1-dev libusb-dev libusbredirparser-dev libfdt-dev libbz2-dev flex bison
```

**下载解压源代码**

```js
$ wget https://download.qemu.org/qemu-4.0.0.tar.xz
$ tar xvJf qemu-4.0.0.tar.xz
```

**配置并编译**

只编译x86_64架构

```js
$ cd qemu-4.0.0
$ mkdir build
$ cd build
$ ../configure --target-list=x86_64-softmmu --enable-debug
$ make -j8
```

**安装**

```js
$ sudo make install
```

目标程序安装在/usr/local/