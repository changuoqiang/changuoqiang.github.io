---
title: Debian Wheezy AMD64编译安装原生ZFS文件系统
tags:
  - Debian
  - ZFS
id: '2195'
categories:
  - - GNU/Linux
date: 2012-04-27 21:57:40
---

由于license不兼容,ZFS一直无法进入linux kernel
<!-- more -->
ZFS使用CDDL(Common Development and Distribution License)协议分发,而linux kernel则采用了GPL2协议,由于这两个协议存在冲突,因而ZFS无法进入内核主线。

虽然之前有个用户空间的ZFS实现zfs-fuse,但是性能肯定是无法保证的,玩玩可以,真正使用还是算了吧。

虽然不能进入内核,但还是有办法将ZFS原生地移植到linux平台,那就是将ZFS作为内核模块来运行,这就是[ZFS on Linux](http://zfsonlinux.org)项目。ZFS on Linux是由美国能源部(Department of Energy)委托劳伦斯利弗莫尔国家实验室LLNL(Lawrence Livermore National Laboratory)开发的。

ZFS on Linux只支持64bits平台,包括两个组件SPL(Solaris Porting Layer)和ZFS,当前版本为0.6.0-rc8,支持的zfs pool版本为28,文件系统版本为5。

**安装solaris移植层SPL**

下载spl-0.6.0-rc8.tar.gz,解压生成spl-0.6.0-rc8子目录,进入该目录执行以下操作
$ sudo apt-get install build-essential gawk alien fakeroot linux-headers-$(uname -r)
$ ./configure
$ make deb

这会在当前目录下生成三个deb包
spl_0.6.0-1_amd64.deb
spl-modules_0.6.0-1_amd64.deb
spl-modules-devel_0.6.0-1_amd64.deb

安装生成的deb包
$sudo dpkg -i *_amd64.deb

**安装ZFS**

下载zfs-0.6.0-rc8.tar.gz,解压缩生成zfs-0.6.0-rc8子目录,进入该目录执行以下操作
$ sudo apt-get install zlib1g-dev uuid-dev libblkid-dev libselinux-dev parted lsscsi
$ ./configure
$ make deb

这会在当前目录下生成六个deb包
zfs_0.6.0-1_amd64.deb
zfs-dracut_0.6.0-1_amd64.deb
zfs-modules-devel_0.6.0-1_amd64.deb
zfs-devel_0.6.0-1_amd64.deb
zfs-modules_0.6.0-1_amd64.deb
zfs-test_0.6.0-1_amd64.deb

安装生成的deb包
$sudo dpkg -i *_amd64.deb

让系统启动时自动加载zfs内核模块,编辑/etc/modules文件,zfs作为单独的一行添加到文件中。

**测试**

加载ZFS模块
# modprobe zfs

查看zfs模块信息
$ lsmod grep zfs
Module Size Used by
zfs 791314 0 
zunicode 324466 1 zfs
zavl 13115 1 zfs
zcommon 35811 1 zfs
znvpair 31373 2 zcommon,zfs
spl 120446 6 znvpair,zcommon,zavl,zunicode,zfs,splat

加载splat(Solaris Porting LAyer Test)模块
#modprobe splat

查看splat使用说明
#splat
usage: splat \[hvla\] \[-t <subsystem:>\]
 --help -h This help
 --verbose -v Increase verbosity
 --list -l List all tests in all subsystems
 --all -a Run all tests in all subsystems
 --test -t Run 'test' in subsystem 'sub'
 --exit -x Exit on first test error
 --nocolor -c Do not colorize output

Examples:
 splat -t kmem:all # Runs all kmem tests
 splat -t taskq:0x201 # Run taskq test 0x201

执行kmem测试
#splat -t kmem:all
-----------Running SPLAT Tests ----------------
 kmem:kmem_alloc Pass 
 kmem:kmem_zalloc Pass 
 kmem:vmem_alloc Pass 
 kmem:vmem_zalloc Pass 
 kmem:slab_small Pass 
 kmem:slab_large Pass 
 kmem:slab_align Pass 
 kmem:slab_reap Pass 
 kmem:slab_age Pass 
 kmem:slab_lock Pass 
 kmem:slab_overcommit Pass 
 kmem:vmem_size Pass