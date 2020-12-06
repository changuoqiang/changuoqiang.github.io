---
title: jar文件规范
tags:
  - Java
id: '2879'
categories:
  - - java
date: 2013-05-04 16:11:50
---

JAR文件基于流行的ZIP文件格式,用来聚合很多分散的文件到一个档案。
<!-- more -->
JAR文件本质上是一个zip文件，包含一个可选的META-INF目录。可以使用[命令行工具jar创建JAR文件](https://openwares.net/lang/java_package_app_jar.html)，也可以使用java平台的java.util.jar API来创建。JAR文件的名字没有限制，可以是任何特定平台上允许的文件名字。

多数情况下，JAR文件并不是类文件和/或资源文件的简单聚合档案。他们经常用作应用程序和扩展的构建基础。如果存在的话，META-INF目录用来存储包和扩展的配置数据，包括安全、版本、扩展和服务。

**META-INF目录**

java 2 平台识别和解释META-INF目录下的文件/目录，用来配置应用程序，扩展，类装载器和服务。

*   MANIFEST.MF

清单文件用来定义扩展和包相关的数据

*   INDEX.LIST

索引文件由jar命令的-i选项产生，其中包含了应用程序或扩展定义的包里面的定位信息。他是JarIndex实现的一部分，类装载器使用索引文件来加速类装载进程。

*   x.SF

JAR包的签名文件(Signature File),x是JAR的基本文件名,也就是JAR文件名的前半部分

*   x.DSA

与签名文件关联的签名块文件，x是与jar包相同的基本文件名，这个文件存储了对应签名文件的数字签名。

*   services/

services目录存储了所有服务提供商的所有文件。

名值对和节

在详述单独的配置文件内容之前，需要先定义一些格式规范。通常，清单文件和签名文件里面的信息由所谓的名：值对来表达，这是受RFC822的启发而来。我们也成为这些名值对为标头或者属性。

一组名值对称之为一个。节之间使用空行来分隔。

任何形式的二进制数据用base64编码来表示，如果二进制数据超过了72字节的行长度，那么就必须续行。二进制数据的例子是摘要和签名。

实现应该支持头值最大到65535字节。

配置文件应遵循的规范
 section: *header +newline
 nonempty-section: +header +newline
 newline: CR LF LF CR (not followed by LF)
 header: name : value
 name: alphanum *headerchar
 value: SPACE *otherchar newline *continuation
 continuation: SPACE *otherchar newline
 alphanum: {A-Z} {a-z} {0-9}
 headerchar: alphanum - _
 otherchar: any UTF-8 character except NUL, CR and LF

; Also: To prevent mangling of files sent via straight e-mail, no
; header will start with the four letters "From".

注：规范中使用的符号*,+,{},等皆为正则表达式符号

JAR文件规范的其余部分详见[JAR File Specification](http://docs.oracle.com/javase/7/docs/technotes/guides/jar/jar.html#The_META-INF_directory)