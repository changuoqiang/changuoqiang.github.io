---
title: debian更改默认java环境
tags:
  - Java
id: '6142'
categories:
  - - java
date: 2015-01-19 10:10:23
---


<!-- more -->
首先查看系统当前java版本和当前已经安装的java版本：
```js
$java -version
java version "1.7.0_65"
OpenJDK Runtime Environment (IcedTea 2.5.3) (7u71-2.5.3-2)
OpenJDK 64-Bit Server VM (build 24.65-b04, mixed mode)

$ update-java-alternatives -l
java-1.7.0-openjdk-amd64 1071 /usr/lib/jvm/java-1.7.0-openjdk-amd64
jdk-8-oracle-x64 318 /usr/lib/jvm/jdk-8-oracle-x64
```

可以看到系统当前java版本为openjdk 7,系统当前安装了两个java版本，分别是openjdk 7和 oracle jdk 8

然后更改系统默认java为oracle jdk 8
```js
# update-java-alternatives -s jdk-8-oracle-x64
update-alternatives: error: no alternatives for iceweasel-javaplugin.so
```

因为没有使用iceweasel,所以忽略错误即可。

**\===
\[erq\]**