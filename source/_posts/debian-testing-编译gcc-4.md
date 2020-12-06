---
title: debian testing 编译gcc 4
tags:
  - Debian
id: '7835'
categories:
  - - GNU/Linux
date: 2017-03-06 08:52:15
---

编译QCAD需要gcc 4,而当前debian系统的gcc版本为6.3.0，因此需要编译gcc 4。
<!-- more -->
**获取源代码**
可以从官方svn或者git镜像检出gcc 4分支的最新代码4.9.4
```js
$ svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_4_9_4_release gcc
$ git clone git://gcc.gnu.org/git/gcc.git --branch gcc-4_9_4-release
```

或者从[官方镜像](https://gcc.gnu.org/mirrors.html)直接下载打包好的源码包。

**安装依赖**
```js
$ sudo apt install libgmp-dev libmpfr-dev libmpc-dev
```
或者进入解压后的源代码目录下执行：
```js
$ ./contrib/download_prerequisites
```
会自动下载并部署依赖

**配置、编译和安装**

新建一个目标文件目录比如叫dest,然后配置源代码
```js
$ mkdir dest
$ cd dest
$ ../gcc-4.9.4/configure --prefix=$HOME/gcc_4 --enable-languages=c,c++ --disable-multilib
```

安装目录设定为用户主目录下的gcc_4，不需要支持32位架构。

最后编译、安装
```js
$ make
$ make install
```

如果有提示:
```js
checking LIBRARY_PATH variable... contains current directory
configure: error: 
*** LIBRARY_PATH shouldn't contain the current directory when
*** building gcc. Please change the environment variable
*** and run configure again.
```
只要
```js
$ unset LIBRARY_PATH
```
就可以了

References:
\[1\][InstallingGCC](https://gcc.gnu.org/wiki/InstallingGCC)

**\===
\[erq\]**