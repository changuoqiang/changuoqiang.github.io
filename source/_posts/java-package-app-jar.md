---
title: 打包Java package包和可执行Java应用程序
tags:
  - Java
id: '1045'
categories:
  - - Lang
date: 2011-03-04 13:18:48
---

为了便利的分发和部署Java package(类库)和可执行应用程序,Java提供了jar(Java ARchive)工具,jar在打包的过程中使用zip格式执行文件压缩,加快网络传输速度
<!-- more -->
**1\. 打包Java包(类库)**

比如现在有net.openwares.foo这个包,包里面有一个bar类,在硬盘上的目录结构为
JavaT/net/openwares/foo/bar.class

Java package依赖于分解package名字为分级目录来定位相应的包,所以打包时必须把相应的目录结构打包进去,这样JVM才能根据CLASSPATH环境变量附加上包的目录结构信息来找到相应的类文件,打成jar包亦不例外,不过这时jar包的全名称必须包含在CLASSPATH环境变量中。

对于package打包,一般用默认生成的manifest文件即可,进入JavaT目录,在该目录下执行以下命令

打包整个目录

$jar cvf bar.jar net

或者更详细指定具体的类名

$jar cvf bar.jar net/openwares/foo/bar.class

之后在JavaT目录下生成bar.jar,将此包拷贝到$JAVA_HOME/jre/lib/ext目录下,即可在其他地方import该包

**2\. 打包可执行java程序**

此处稍有不同,必须指定一个manifest清单文件来指定可执行jar包内的主类,也就是JVM加载时要从此主类开始执行,当然有必要的话还要指定主类的程序入口点

假设现在有两个类foo.class和bar.class,将其打包成foobar.jar,并且foo.class包含程序入口点,目录结构如下

JavaT/foo.class

JavaT/bar.class

在JavaT目录下建立一个文件manifest,其内容如下

Manifest-Version: 1.0
Created-By:  openwares.net

Main-Class: foo

最后一行Main-Class即用来指定jar包内的主类,如果此主类属于某一个包,此处要输入类的全限定名字,亦即packagename.foo

然后进入JavaT目录,执行

$jar cvfm foobar.jar manifest foo.class bar.class

生成foobar.jar,拷贝此文件至任意目录,通过以下命令即可执行此jar包

$java -jar foobar.jar

如果可执行java程序在一个命名的包内,也就是不使用默认包,那么其打包方式与package基本一样，除了需要增加一个manifest文件来指定完整的主类名。

**3\. 其他打包方式**

因为jar是一个标准的zip格式文件,所以只要组织好文件的目录结构,增加必要的元文件,比如META-INF/MANIFEST.MF等,用支持zip格式压缩的工具比如7zip等将完整的目录结构压缩成一个zip格式扩展名为.jar的文件即可