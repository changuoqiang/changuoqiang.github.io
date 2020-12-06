---
title: debian 10 buster安装jdk8
tags:
  - Debian
id: '8404'
categories:
  - - GNU/Linux
  - - java
date: 2019-06-20 18:49:04
---


<!-- more -->
buster官方源里已经不再提供openjdk-8-jdk, default-jdk版本为openjdk-11-jdk

可以使用java-packge包来安装oracle jdk 8,或者build openjdk8u

_1\. oracle jdk 8_

**安装**

安装java-package及其他需要的依赖包

```js
$ sudo apt install java-package java-common libgtk-3-dev libcairo-gobject2
```

**下载**

oracle官方下载jdk-8u211-linux-x64.tar.gz

**打包**

切换到下载目录执行
```js
$ make-jpkg jdk-8u211-linux-x64.tar.gz
```
会在当前目录下生成oracle-java8-jdk_8u211_amd64.deb

**安装**

```js
$ sudo dpkg -i oracle-java8-jdk_8u211_amd64.deb
```

_2\. openjdk8u_

[openjdk8u](http://hg.openjdk.java.net/jdk8u/jdk8u/)是openjdk8的更新版本，其官方代码仓库为http://hg.openjdk.java.net/jdk8u/jdk8u/

根据其[官方build说明文件](https://hg.openjdk.java.net/jdk8u/jdk8u/raw-file/tip/README-builds.html)，clone源代码并编译安装即可。

References:
\[1\][OpenJDK / jdk8u / jdk8u](http://hg.openjdk.java.net/jdk8u/jdk8u/)
\[2\][OpenJDK Build README](https://hg.openjdk.java.net/jdk8u/jdk8u/raw-file/tip/README-builds.html)