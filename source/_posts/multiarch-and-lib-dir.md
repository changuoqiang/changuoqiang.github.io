---
title: multiarch架构与lib目录
tags:
  - Debian
id: '2013'
categories:
  - - GNU/Linux
date: 2012-03-27 19:35:11
---

Debian的下一个版本Wheezy将会全面支持Multiarch架构。
<!-- more -->
Multiarch本质上是一个文件系统规范,为在一个系统内安装不同架构的库和二进制目标程序提供一个通用的解决方案,目前的multiarch仅限于库文件,对二进制目标文件的支持尚未提上日程,还有许多工作要做。

multiarch对跨平台编译(cross-build)和模拟器/兼容层同样有重要意义。multiarch会大大降低cross-build的复杂性,因为编译和运行时都使用同样的库目录,大大减少了出现问题的可能性。multiarch对模拟器/兼容层一视同仁,为其支持库提供与native库一样的布局视图,改善用户体验。

有一点需要澄清,multiarch并不能支持二进制应用程序跨平台运行。比如为power架构编译的二进制程序是不可能拿到amd64平台上来直接运行的,multiarch也不行。只有类似java这种字节码的应用程序才可以真正做到无修改跨平台直接运行,其实java并不是跨平台的,java本身就是一种平台。但是multiarch规范了同一个平台下不同的子平台之间的混合运行环境,比如amd64与x86之间。

FHS 2.3制定的库规范可以称之为双架构"biarch"。FHS规定64bits平台,包括PPC64, s390x, sparc64 and AMD64,必须将其64bits共享库部署到/lib64目录,而32bits共享库部署到/lib目录,这样方便大量的32位程序正常运行而不用做任何改变,而IA64平台则须将其64bits库部署到/lib目录，因为其并没有32bits平台的负担。red hat和suse采用了这种设计,但是debian没有。因为biarch缺乏伸缩性,并不能轻易的扩展到其他多种平台,而debian的目标之一是成为通用操作系统,支持多种异构平台,因此需要更通用的解决方案,这就是multiarch。

multiarch的实现也十分简洁,就是将架构相关的库部署到架构相关的路径下。比如/usr/lib/libfoo,如果机器是amd64架构,则将其放置到/usr/lib/x86_64-linux-gnu/libfoo,如果机器是i386架构,则将其放置到/usr/lib/i386-linux-gnu/libfoo,如果机器是ppc64架构,则将其放置到/usr/lib/powerpc64-linux-gnu/libfoo。

multiarch路径包含一个GNU三位元组,用来描述系统架构。比如,x86_64-linux-gnu,x86_64指处理器类型,linux指操作系统内核,gnu则指用户空间的ABI。对于原生库,cross-build库还是模拟器支持库的部署路径都是一样的,没有任何差别。

Debian Squeeze及之前的版本,AMD64平台上,/lib64是/lib目录的符号链接,/usr/lib64是/usr/lib的符号链接。而如果安装了ia32-libs库,则/lib32和/usr/lib32用来部署32位程序的共享库。这并没有遵守FHS 2.3的规定。从Wheezy开始,Debian全面支持multiarch架构。/lib64,/usr/lib64,/lib32,/usr/lib32等和ia32-libs库都是debian要消灭的目标,现在testing AMD64版本中,/lib64目录下还只剩一个符号链接ld-linux-x86-64.so.2,指向/lib/x86_64-linux-gnu/ld-2.13.so,这是因为bash的大部分命令还在硬编码/lib64/ld-linux-x86-64.so.2,估计不久的将来,最晚到wheezy正式发布,/lib64目录会被彻底消灭。ia32-libs也会被化解整合到/lib/i386-linux-gnu/,/usr/lib/i386-linux-gnu等目录下。这样有些软件在testing平台安装时,可能不得不手工做很多的符号链接以弥合这种库路径的变化,当然源内的软件是不会存在这种问题的。

如果multiarch的目标完全实现,在同一个系统内安装不同架构的库和二进制目标文件。那么下一个目标极有可能就是通用二进制([Universal binary](http://en.wikipedia.org/wiki/Universal_binary)),这也算是水到渠成的事了。通用二进制的目标文件里面用不同section存储不同架构的二进制代码,比如支持power和amd64的通用二进制目标程序,在power平台运行时会执行存储power机器码的section,而在amd64平台运行时则会执行存储amd64机器码的section。当然这种方式存在冗余,每一种平台上只会用到一种机器码段,其他的机器码则没有任何用处,只是在白白的浪费存储空间。通用二进制势必会对操作系统底层,以及应用程序的build和release模式产生重大影响。

其实现在linux平台上已经有了[FatELF](http://icculus.org/fatelf/)(Universal Binaries for Linux)项目,不过据说开发者Ryan Gordon[已经放弃该项目](http://techsingular.net/?p=480)。