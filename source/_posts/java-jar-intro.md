---
title: Java jar命令详解
tags:
  - Java
id: '1047'
categories:
  - - Lang
date: 2011-03-04 12:34:46
---

jar是 Java ARchive的缩写,是JDK内建支持的标准打包工具和方法
<!-- more -->
命令行下输入不带任何参数的jar命令将输出jar的用法,也可用man jar来获取帮助资讯

$jar

Usage: jar {ctxui}\[vfm0Me\] \[jar-file\] \[manifest-file\] \[entry-point\] \[-C dir\] files ...
Options:
-c  create new archive
-t  list table of contents for archive
-x  extract named (or all) files from archive
-u  update existing archive
-v  generate verbose output on standard output
-f  specify archive file name
-m  include manifest information from specified manifest file
-e  specify application entry point for stand-alone application
bundled into an executable jar file
-0  store only; use no ZIP compression
-M  do not create a manifest file for the entries
-i  generate index information for the specified jar files
-C  change to the specified directory and include the following file
If any file is a directory then it is processed recursively.
The manifest file name, the archive file name and the entry point name are
specified in the same order as the 'm', 'f' and 'e' flags.

Example 1: to archive two class files into an archive called classes.jar:
jar cvf classes.jar Foo.class Bar.class
Example 2: use an existing manifest file 'mymanifest' and archive all the
files in the foo/ directory into 'classes.jar':
jar cvfm classes.jar mymanifest -C foo/ .

下面详细的介绍以下各子命令以及选项的用法

其中ctxui为子命令,每次只能使用一个而不能同时使用,vfm0Me为选项,根据相应的子命令选择适合的选项

-c 创建一个新的jar文件

-t 列出一个jar包的内容列表

-x 从jar包或者标准输入提取指定或者全部文件

-u 更新已经存的jar包,向其添加或删除文件

-v 向标准输出打印详细打包过程资讯

-f 指定jar文件名称,适用于ctxui子命令,指定将要创建的(c)、更新的(u)、提取的(x)、索引的(i)或者查看的(t) jar文件名

-m 指定manifest文件, 生成的jar包中包含指定的manifest文件中的内容，生成的manifest文件为jar包内的META-INF/MANIFEST.MF

-e 指定jar内主类的应用程序入口点,如果使用java标准的main入口点则可以忽略此选项

-0 只存储不压缩,使用zip格式

-M 对于子命令c不产生manifest文件，对于子命令u删除可能存在的manifest文件

-i 对指定的jar文以及其以来的jar文件产生索引信息，将会在jar包内的META-INF子目录下插入一个INDEX.LIST文件

-C dir 更改到指定目录dir并打包其下文件和目录

\[jar-file\] 指定jar包，适用于子命令ctxu

\[manifest-file\]  指定需要包含的manifest清单文件,当指定-m选项时适用

\[entry-point\] 生成的jar包内主类的程序入口点

file... 为需要打包的class及其他资源文件

注意：指定的manifest清单文件名,jar包文件名和程序入口点的顺序必须与选项m,f和e选项的指定顺序一致