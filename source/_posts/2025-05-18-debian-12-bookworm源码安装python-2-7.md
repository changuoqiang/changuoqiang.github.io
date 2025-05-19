---
title: debian 12 bookworm安装python 2.7
date: 2025-05-18 15:41:59
tags:
  - Debian
categories:
  - - GNU/Linux
---

cassandra 2.2 依赖python2.7，但debian 12开始官方源已经不再提供python2
<!-- more -->

一、从源码编译安装

0. 安装编译依赖

```bash
$ sudo apt update
$ sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev wget -y 
```

2. 从官方下载解压源码

```bash
$ wget https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tgz
$ tar -xzvf Python-2.7.18.tgz
$ cd Python-2.7.18
```

3. 配置编译参数‌

```bash
$ ./configure --prefix=/opt/python --enable-unicode=ucs4
```

4. 编译 
```bash
$ make -j$(nproc)
$ sudo make install
```

5. 创建链接

```bash
$ sudo ln -s /opt/python/bin/python2.7 /usr/local/bin/python
$ python --version
$ Python 2.7.18
```

二、从buster官方源安装

debian在一定程度上是可以混源安装的

`/etc/apt/sources.list` 中添加buster源
```bash
deb https://mirrors.163.com/debian/ buster main
```
然后
```bash
$ sudo apt update
$ sudo apt install python
$ python --version
$ Python 2.7.16
```

安装完python后，注释掉buster源，然后`apt update`，以免引起其他混乱。

References:

[1] [Debian 12 安装Python 2.7 ](https://www.cnblogs.com/fanqisoft/p/18834438)
