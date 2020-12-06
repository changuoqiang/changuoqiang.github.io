---
title: debian安装oracle  jdk
tags:
  - Java
id: '6139'
categories:
  - - java
date: 2015-01-19 09:36:43
---


<!-- more -->
debian源里默认的java是openjdk,当前版本是7。如果需要安装oracle官方的jdk8,可以使用java-package打包官方jdk的方式来安装：

1、安装java-package
```js
# apt-get install java-package
```

2、下载[oracle jdk 8](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)

下载linux x64的tar.gz包,当前下载回来的文件为:jdk-8u25-linux-x64.tar.gz

3、打包
进入jdk下载目录,执行:
```js
$ make-jpkg jdk-8u25-linux-x64.tar.gz
```
简单回答几个问题,即可以生成oracle jdk 8的deb安装包oracle-java8-jdk_8u25_amd64.deb

如果遇到类似如下问题：
```js
dpkg-checkbuilddeps: Unmet build dependencies: libgl1-mesa-glx libxxf86vm1
```
直接apt-get install就可以了：
```js
sudo apt-get install libgl1-mesa-glx libxxf86vm1
```

4、安装
```js
# dpkg -i oracle-java8-jdk_8u25_amd64.deb
```

安装完成。

**\===
\[erq\]**