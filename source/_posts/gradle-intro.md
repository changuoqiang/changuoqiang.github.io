---
title: Gradle安装与简单使用
tags:
  - Java
id: '4859'
categories:
  - - java
date: 2014-01-18 16:48:35
---

Gradle是使用Groovy做为DSL的构建工具,十分强大且易用。
<!-- more -->
**安装**

Debian tesing 源里虽然有gradle,但其还依赖于tomcat6的一些库。因此直接从[官方下载](http://www.gradle.org/downloads)安装,官方下载的gradle是自包含的,自带了groovy库。
当前版本为[1.10](http://services.gradle.org/distributions/gradle-1.10-bin.zip)。

安装很简单,只要将gradle的可执行文件bin/gradle加入$PATH环境变量就可以了。

```js
# unzip gradle-1.10-bin.zip -d /opt/
# ln -sf /opt/gradle-1.10 /opt/gradle
# mkdir /opt/bin 
# ln -sf /opt/gradle/bin/gradle /opt/bin/gradle
```

编辑/etc/profile,添加如下行:
```js
# set PATH so it includes opt bin if it exists
if \[ -d "/opt/bin" \] ; then
 PATH="/opt/bin:$PATH"
fi
```

测试安装:
```js
$ gradle -v
------------------------------------------------------------
Gradle 1.10
------------------------------------------------------------

Build time: 2013-12-17 09:28:15 UTC
Build number: none
Revision: 36ced393628875ff15575fa03d16c1349ffe8bb6

Groovy: 1.8.6
Ant: Apache Ant(TM) version 1.9.2 compiled on July 8 2013
Ivy: 2.2.0
JVM: 1.7.0_21 (Oracle Corporation 23.7-b01)
OS: Linux 3.12-1-amd64 amd64
```
**构建java web工程**

gradle使用[约定优于配置](http://zh.wikipedia.org/wiki/%E7%BA%A6%E5%AE%9A%E4%BC%98%E4%BA%8E%E9%85%8D%E7%BD%AE)(Convention over Configuration)的理念。使用与maven兼容的目录结构布局。完全按照约定的目录结构来布置工程文件,会大大简化build配置文件。

除了常见的src/main/java等目录,默认的web应用程序根目录为src/main/webapp,也就是包含WEB-INF目录的上一级目录。如果工程没有完全依照约定布局,可以通过脚本文件指定相应的路径。

Gradle中有两个最基本的对象：project和task。每个Gradle的构建由一个project对象来表达，它代表着需要被构建的组件或者构建的整个项目。每个project对象由一个或者多个task对象组成。

gradle已经自带了很多pugins,可以满足大部分的常见构建任务。

gradle的默认构建脚本文件为工程根目录下的build.gradle,下面是一个简单的web app构建脚本,脚本虽然简单,但完整的完成了系统的构建和测试,这就是gradle的魅力所在。简约但不简单。

```js
apply plugin: 'war'

webAppDirName = 'root'

dependencies {
 compile fileTree(dir: 'root/WEB-INF/lib', include: '*.jar')
 runtime fileTree(dir: 'root/WEB-INF/lib', include: '*.jar')
 testCompile fileTree(dir: 'root/WEB-INF/lib', include: '*.jar')
 testRuntime fileTree(dir: 'root/WEB-INF/lib', include: '*.jar')
 providedCompile files('/usr/share/java/servlet-api-3.0.jar')
 providedRuntime files('/usr/share/java/servlet-api-3.0.jar')
}

compileJava { 
 options.compilerArgs << '-Xlint:unchecked'
}
```

工程根目录下执行构建脚本,下面是脚本中没有添加编译器参数-Xlint:unchecked的输出:
```js
$ gradle build
:compileJava
Note: Some input files use unchecked or unsafe operations.
Note: Recompile with -Xlint:unchecked for details.
:processResources UP-TO-DATE
:classes
:war
:assemble
:compileTestJava
:processTestResources UP-TO-DATE
:testClasses
:test
:check
:build

BUILD SUCCESSFUL

Total time: 9.064 secs
```
即可完成整个编译,测试,打包,输出文件在build目录下,生成的war包在build/libs目录。

这个脚本使用war插件,webAppDirName指定web应用程序的根目录,工程依赖没有使用仓库,设置为本地文件路径。
providedCompile指定的依赖只在编译时使用,不会打包到war文件中。providedXxxx与其他依赖的区别就是,
其他的依赖会自动拷贝到war包的WEB-INF/lib目录中。

gradle使用groovy作为DSL语言,因此了解一下groovy还是十分有必要的。有一篇[groovy入门](http://blog.csdn.net/kmyhy/article/details/4200563)和[闭包](http://romejiang.iteye.com/blog/214812)的介绍文章比较不错。
gradle更详细的用法参见官方文档\[1\],其文档十分丰富,直接阅读官方文档即可以解决绝大部分问题。

Gradle真的不错,只是有点点儿慢！

References:
\[1\][Gradle User Guide](http://www.gradle.org/docs/current/userguide/userguide_single.html)
\[2\][Groovy入门教程](http://blog.csdn.net/kmyhy/article/details/4200563)
\[3\][Groovy 闭包深入浅出](http://romejiang.iteye.com/blog/214812)

**\===
\[erq\]**