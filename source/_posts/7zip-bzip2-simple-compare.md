---
title: 7zip与bzip2简单比较
tags:
  - Debian
id: '2848'
categories:
  - - GNU/Linux
date: 2013-01-31 12:11:12
---

7zip与bizp2压缩率与消耗时间的简单比较
<!-- more -->
bzip2在GNU系统中使用广泛，一般与tar结合使用，bzip2负责压缩，tar(Tape ARchive)负责归档。
bzip2比gzip或者ZIP的压缩效率高，但是它的压缩速度较慢,某些情况下bzip2的压缩效率不如7zip。
一直使用tar和bzip2归档oracle导出备份文件,随着备份文件的增大，发现bzip2越来越力不从心。

遂将其**与7zip做一简单比较**

原始文件为一15.3G大小的oracle导出dmp文件，先由bzip2出场

**bzip2**
```js
$ date && bzip2 --best oracle.dmp && date
```
压缩时间为1小时33分，压缩后大小为4.7GB,best参数并不是最高压缩率，只是默认参数而已，参见man bzip2
```js
$ date && bunzip2 oracle.dmp.bz2 && date
```
解压缩时间为13分钟

**7zip**

快速压缩,压缩方法设置为x=3
```js
$ date && 7z a oracle.dmp.7z oracle.dmp -mx=3 && date
```
压缩时间为27分，压缩后大小为3.5G
```js
$ date && 7z e oracle.dmp.7z && date
```
解压缩时间为6分钟

正常压缩，压缩方法设置为x=5
```js
$ date && 7z a oracle.dmp.7z oracle.dmp -mx=5 && date
```
压缩时间为56分钟，压缩后大小为2.9G
```js
$ date && 7z e oracle.dmp.7z && date
```
解压缩时间为6分钟

**结论**

虽然这是很粗糙的测试，但是也可以看出端倪，7zip还是相当优秀的，压缩时间短，压缩后的文件小，压缩效率很高。

**7zip与tar结合使用**

debian源里关于7zip有如下几个包
```js$ apt-cache search 7zip
p7zip - 7z file archiver with high compression ratio
p7zip-full - 7z and 7za file archivers with high compression ratio
p7zip-rar - non-free rar module for p7zip
```
包p7zip-full比p7zip处理更多的压缩格式，p7zip-rar提供对rar格式的支持，但这是个非自由的模块。

与tar的结合

归档压缩目录
```js
$ tar cf - directory 7za a -si directory.tar.7z
```
解压缩还原目录
```js
$ 7za x -so directory.tar.7z tar xf -
```

参数说明
-si Read data from StdIn，从标准输入读取数据
-so Write data to StdOut，将数据写入标准输出