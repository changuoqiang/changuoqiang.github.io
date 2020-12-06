---
title: ZFS文件系统介绍 - 文件系统
tags:
  - Debian
  - ZFS
id: '2266'
categories:
  - - GNU/Linux
date: 2012-05-14 14:16:01
---

ZFS 文件系统构建于存储池上。文件系统可以动态创建和销毁,而不需要分配或格式化任何底层磁盘空间。
<!-- more -->
**创建ZFS文件系统**

创建存储池时若没有通过-m选项指定挂装点,则默认会将池子挂载到/poolname这个目录下,比如前文例子中的池子自动挂载到/reservoir,而且ZFS会在开机时自动挂载池子。

在池子中创建新的ZFS文件系统

# zfs create pool-name/\[filesystem-name/\]filesystem-name

pool-name为新创建ZFS文件系统要驻留其中的池子,路径中最后的filesystem-name为要创建的ZFS文件系统,ZFS文件系统为分层结构,新创建的文件系统可能居于其他文件系统的层次之下,但前提是这里提到的其他文件系统必须是已经存在的，无法一次递归创建多个ZFS文件系统。

比如在池子reservoir上创建文件系统data
# zfs create reservoir/data

如果文件系统创建成功,ZFS会自动挂载该文件系统。此处新创建的文件系统挂载于/reservoir/data

也可以在创建文件系统时指定挂载点
# zfs create -o mountpoint=/mnt/data reservoir/data
# zfs list
 NAME            USED AVAIL  REFER MOUNTPOINT  
reservoir       146K 1.94G  30K   /reservoir  
reservoir/data  30K  1.94G  30K   /mnt/data 

**销毁ZFS文件系统**

使用zfs destroy命令来销毁 ZFS 文件系统,销毁的文件系统将自动取消挂载,并取消共享。
# zfs destroy reservoir/data

**重命名ZFS文件系统**

使用zfs rename命令不但可以重命名zfs文件系统,而且可以重定位文件系统所在的层级

重命名文件系统
# zfs rename reservoir/data reservoir/data_new
# zfs list NAME                 USED  AVAIL  REFER  MOUNTPOINT  
reservoir            144K  1.94G    30K  /reservoir  
reservoir/data_new    30K  1.94G    30K  /mnt/data 
可以看到虽然文件系统的名字变化了,但其挂载点仍然未变,以下命令改变文件系统的挂载点
# zfs set mountpoint=/mnt/data_new reservoir/data_new
# zfs list NAME                 USED  AVAIL  REFER  MOUNTPOINT  
reservoir            146K  1.94G    30K  /reservoir  
reservoir/data_new    30K  1.94G    30K  /mnt/data_new 

重命名并重定位zfs文件系统层级
# zfs create reservoir/somefs
# zfs rename reservoir/data_new reservoir/somefs/data
# zfs list NAME                  USED AVAIL REFER MOUNTPOINT  
reservoir             184K 1.94G   31K /reservoir  
reservoir/somefs      60K 1.94G   30K /reservoir/somefs  
reservoir/somefs/data 30K 1.94G   30K /mnt/data_new 

**共享ZFS文件系统**

ZFS支持两种共享方式发布ZFS文件系统,NFS和SAMBA

**NFS方式发布ZFS文件系统**
首先ZFS所在的主机要安装nfs服务器,debian系统可以安装包nfs-kernel-server

设置ZFS文件系统NFS共享
# zfs set sharenfs=on reservoir/somefs/data
# zfs get sharenfs reservoir/somefs/data NAME                  PROPERTY VALUE SOURCE  
reservoir/somefs/data sharenfs on    local 

对外共享的目录即该文件系统挂载的目录/mnt/data_new

从其他主机访问该文件系统
# mount -t nfs4 ip:/mnt/data_new /mnt/data_new

取消NFS共享
# zfs set sharenfs=off reservoir/somefs/data

**SAMBA方式发布ZFS文件系统**

zfsonlinux有sharesmb属性,但当前实现尚不支持直接以samba方式发布ZFS文件系统,但仍然可以以传统的方式对ZFS文件系统设置smaba共享。