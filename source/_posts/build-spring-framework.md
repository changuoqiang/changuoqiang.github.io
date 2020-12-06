---
title: 源码编译Spring Framework
tags:
  - Java
id: '3298'
categories:
  - - java
date: 2013-10-10 15:27:45
---

最新的Spring Framework没有jar包提供下载了，推荐用maven或gradle来引用Spring Framework,找了好久没找到下载的地方。
<!-- more -->
**前置条件**

JDK是必须的，安装openjdk7即可。
Spring Framework已经迁移到Gtihub,并且使用gradle建构系统,所以需要安装git。
gradle可装可不装，如果不安装，spring framework的构建脚本会自动下载特定版本的gradle

**下载**

使用git克隆Spring Framework的源代码库
$ git clone git://github.com/SpringSource/spring-framework.git

克隆完成后，代码库处于最新的master分支，最好检出稳定的版本进行编译,所以检出最新的稳定版本3.2.4 GA release, 其tag为v3.2.4.RELEASE

$ cd spring-framework
$ git checkout v3.2.4.RELEASE
这样代码库就是最新的稳定版本3.2.4了

**编译**
Spring Framework已经切换到了gradle构建系统，编译也比较简单，不过要从网络上下载很多依赖的东西，时间会比较久

$ ./gradlew build

构建时间依网络速度会有所不同，最后输出
BUILD SUCCESSFUL
Total time: 1 hrs 27 mins 12.286 secs
算是构建完成了

build/distributions/目录下会生成完整的发布包spring-framework-3.2.4.RELEASE-dist.zip,里面包含拆分开的各个jar包，现在已经没有一个完整的spring.jar单包了，根据项目需要选用拆分开的jar包即可。

参考：[spring-projects/spring-framework](https://github.com/spring-projects/spring-framework/tree/3.2.x)