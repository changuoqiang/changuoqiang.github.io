---
title: 减少qcow2虚拟磁盘文件实际占用的存储空间
tags:
  - KVM
id: '2167'
categories:
  - - GNU/Linux
date: 2012-04-26 14:56:09
---

虚拟磁盘文件占用的空间会越来越大,就算从客户机里面删除了很多文件,但这些空间并未释放出来,qcow2文件仍然占用大量的主机存储空间。
<!-- more -->
虽然qcow2有一个特点,客户机需要时才分配存储空间,这工作的一直很好。但是当从客户机删除了很多文件,释放了很多空间时,从KVM主机端完全看不到qcow2虚拟磁盘文件有变小的迹象。这是因为现在的文件系统都有一个特点,删除文件时并没有真正的清除文件的内容,只是简单的做了标记,这样删除文件会很迅速,只有当用到这些空间时才重新写入新的数据。这也是反删除甚至反格式化软件存在的基础。所以要想缩小qcow2虚拟磁盘文件的大小,就要真正释放这些未使用的空间才可以。

不同的客户机类型有不同解决方式,基本思路就是用0填充未使用的客户机磁盘空间,然后用qemu-img转换磁盘镜像文件,转换后的磁盘镜像文件将只包含所有已使用的磁盘空间。

**linux客户机**

1.  使用dd命令将客户机未使用的磁盘空间用0填满
    $dd if=/dev/zero of=~/junk 
    dd: writing to \`/home/***/junk': No space left on device
    然后
    $rm junk
    关闭客户机
    
2.  转换磁盘镜像文件
    $qemu-img convert -O qcow2 debian.qcow2 debian_new.qcow2
    
    转换完成后可以看到debian_new.qcow2占用的KVM主机存储空间与客户机使用的磁盘空间基本是一致的。然后用新的磁盘镜像文件debian_new.qcow2启动客户机即可。
    

**windows客户机**

1.  删除不需要的文件,清理系统垃圾,然后整理磁盘碎片
2.  下载[SDelete](http://technet.microsoft.com/en-us/sysinternals/bb897443),借助sdelete用0来填充未使用硬盘空间
    
    查看sdelete帮助
    C:\\>sdelete
    SDelete - Secure Delete v1.6
    Copyright (C) 1999-2010 Mark Russinovich
    Sysinternals - www.sysinternals.com
    
    usage: sdelete.exe \[-p passes\] \[-s\] \[-q\] ...
     sdelete.exe \[-p passes\] \[-z-c\] \[drive letter\] ...
     -a Remove Read-Only attribute
     -c Clean free space
     -p passes Specifies number of overwrite passes (default is 1)
     -q Don't print errors (Quiet)
     -s or -r Recurse subdirectories
     -z Zero free space (good for virtual disk optimization)
    
    用0填充C分区空闲区域
    C:\\>sdelete -z c
    
    关闭客户机
    
3.  最后在KVM主机上转换qcow2磁盘镜像文件
    
    $qemu-img convert -O qcow2 windows.qcow2 windows_new.qcow2
    转换完成后可以看到windows_new.qcow2占用的KVM主机存储空间与客户机使用的磁盘空间基本是一致的。然后用新的磁盘镜像文件windows_new.qcow2启动客户机即可。