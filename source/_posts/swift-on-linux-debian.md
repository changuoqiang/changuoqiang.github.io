---
title: swift on linux debian
tags:
  - Debian
id: '7187'
categories:
  - - GNU/Linux
date: 2016-04-19 13:58:23
---


<!-- more -->
swift已经支持ubuntu,也可以在debian上安装

**下载**

下载ubuntu 15.10版本的安装包
```js
$ wget https://swift.org/builds/swift-2.2-release/ubuntu1510/swift-2.2-RELEASE/swift-2.2-RELEASE-ubuntu15.10.tar.gz
```

**解压重新打包**

```js
$ tar zxvf swift-2.2-RELEASE-ubuntu15.10.tar.gz
$ cd swift-2.2-RELEASE-ubuntu15.10
$ tar czvf swift-2.2.tar.gz usr
$ sudo alien -v swift-2.2.tar.gz 
```

会生成deb安装包swift_2.2-2_all.deb

**安装**

```js
$ sudo dpkg -i swift_2.2-2_all.deb
```

**测试**

新建main.swift文件
```js
print("hello swift")
```

编译

```js
$ swiftc main.swift -o main.s
```

查看
```js
$ file main.s
main.s: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked,
interpreter /lib64/ld-linux-x86-64.so.2, for GNU/Linux 2.6.32, 
BuildID\[sha1\]=9ed9fa8e5accc18cd0a4482b465aecf814a2a114, not stripped

$ ldd main.s
 linux-vdso.so.1 (0x00007ffe06af4000)
 libswiftCore.so => /usr/lib/swift/linux/libswiftCore.so (0x00007fc4d764f000)
 libstdc++.so.6 => /usr/lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007fc4d72bc000)
 libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007fc4d6fbd000)
 libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007fc4d6da7000)
 libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fc4d6a03000)
 libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007fc4d67e5000)
 libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007fc4d65e1000)
 libicuuc.so.55 => /usr/lib/x86_64-linux-gnu/libicuuc.so.55 (0x00007fc4d624d000)
 libicui18n.so.55 => /usr/lib/x86_64-linux-gnu/libicui18n.so.55 (0x00007fc4d5dea000)
 libbsd.so.0 => /lib/x86_64-linux-gnu/libbsd.so.0 (0x00007fc4d5bd4000)
 /lib64/ld-linux-x86-64.so.2 (0x0000557356b81000)
 libicudata.so.55 => /usr/lib/x86_64-linux-gnu/libicudata.so.55 (0x00007fc4d411c000)
```

也可以动态解释执行
```js
$ swift
Welcome to Swift version 2.2 (swift-2.2-RELEASE). Type :help for assistance.
 1> print("hello, swift")
hello, swift
 2> :q
```

**\===
\[erq\]**