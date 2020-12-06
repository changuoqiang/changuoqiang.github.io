---
title: 'ZFS文件系统介绍 - 存储池(1):创建存储池'
tags:
  - Debian
  - ZFS
id: '2262'
categories:
  - - GNU/Linux
date: 2012-05-14 14:14:07
---

ZFS使用存储池来管理物理存储,文件系统不再受限于单个物理设备。
<!-- more -->
不再需要预先考虑并确定文件系统的大小,因为文件系统会在分配给存储池的磁盘空间内自动增长。添加新的物理存储设备后,无需执行其他操作,池中的所有文件系统即可立即使用所增加的磁盘空间。所以有了ZFS,就不再需要传统的卷管理器，甚至也不再需要传统的RAID设备了。

下文及后续文章涉及到的命令皆基于如下KVM虚拟系统环境：

debian amd64 testing + zfsonlinux 0.6.0-rc8

**创建存储池**

可以使用整块磁盘,磁盘上面的分区或者文件来创建ZFS存储池,但是推荐使用整块磁盘来创建存储池，并且最好不要用硬件RAID提供的虚拟卷。

下面只演示使用整块物理磁盘的情形。这里创建了6个1G的磁盘设备,从KVM客户机里看到的“物理设备”名称为/dev/vdb,/dev/vdc,/dev/vdd,/dev/vde,/dev/vdf,/dev/vdg。所有6个磁盘没有进行分区,处于原始状态。

**1、创建基本存储池**

先查看下物理磁盘状态
# fdisk /dev/vdb

Disk /dev/vdb: 1073 MB, 1073741824 bytes
16 heads, 63 sectors/track, 2080 cylinders, total 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

Disk /dev/vdb doesn't contain a valid partition table

创建池
# zpool create reservoir /dev/vdb /dev/vdc /dev/vdd

会有提示：
invalid vdev specification
use '-f' to override the following errors:
/dev/vdb does not contain an EFI label but it may contain partition
information in the MBR

这是ZFS检测到磁盘不是GPT格式的,而且有可能存在分区,所以进行了提示,加上-f选项继续执行会成功创建存储池。

# zpool create -f reservoir /dev/vdb /dev/vdc /dev/vdd

reservoir是存储池的名字,solaris提供的zfs手册里举例喜欢用tank做池子的名字,tank与reservoir都有蓄水池的意思。这个存储池基于/dev/vdb,/dev/vdc和/dev/vdd这三个物理磁盘设备创建。从ZFS的角度看,这三个物理磁盘设备同时还是顶层的vdev设备。

查看存储池基本信息

# zpool list reservoir NAME      SIZE  ALLOC FREE  CAP DEDUP HEALTH ALTROOT  
reservoir 2.95G 112K  2.95G 0%  1.00x ONLINE - 

ZFS在这三个设备上执行动态条带,但没有任何数据冗余,任何一个磁盘出现故障都将导致存储池不可用,而且无法动态更换磁盘。其容量为3块物理磁盘之和。

这种类型的池子对物理磁盘数量没有限制

查看下存储池reservoir的状态和布局
# zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
          vdc1      ONLINE       0     0     0  
          vdd1      ONLINE       0     0     0  
  
errors: No known data errors 

可以看到池子并没有如预期使用整个磁盘,而是在磁盘上自动创建了一个覆盖全部存储空间的GPT分区来做为存储池的底层物理设备,可以再看下物理磁盘的分区状态

# fidsk /dev/vdb
Disk /dev/vdb: 1073 MB, 1073741824 bytes
256 heads, 63 sectors/track, 130 cylinders, total 2097152 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

 Device Boot Start End Blocks Id System
/dev/vdb1 1 2097151 1048575+ ee GPT

可以清楚的看到ZFS为物理磁盘自动创建了一个GPT分区,为什么会这样呢？可以看此处[对这个问题的讨论](https://github.com/zfsonlinux/zfs/issues/94),Brian Behlendorf对此的解释是为了对齐，而且ZFS的行为尽量与solaris一致云云。
总之目前在zfsonlinux上面,你给了它整个物理磁盘,它自动为你分区,然后使用整个分区,这也不是什么大问题。

**2、创建镜像池**

没有任何冗余的池子你敢用吗？这也体现不出ZFS的优势。使用mirror命令来创建镜像池,至少需要两块物理磁盘。

# zpool create reservoir mirror /dev/vdb /dev/vdc

查看池子的基本信息

# zpool list reservoir NAME      SIZE  ALLOC FREE  CAP DEDUP HEALTH ALTROOT  
reservoir 1008M 109K  1008M 0%  1.00x ONLINE - 可以看到其容量为一块磁盘的容量,与RAID1基本类似。

查看存储池状态和布局

# zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
  
errors: No known data errors 

此镜像池reservoir的顶层虚拟设备vdev为mirror-0,而不是那两块物理磁盘。
这个池子是双向镜像池,还可以创建三向或更多向镜像池,其冗余度越来越高。

三向镜像池
# zpool create reservoir mirror /dev/vdb /dev/vdc /dev/vdd
这个新池子只是多了一份冗余,其容量仍然是一块物理磁盘的容量。

ZFS存储池支持层次结构,比如可以创建一个池子，动态条带化两个顶层镜像虚拟设备,如下

# zpool create reservoir mirror /dev/vdb /dev/vdc mirror /dev/vdd /dev/vde

查看池子的基本信息
# zpool list reservoir NAME      SIZE  ALLOC FREE  CAP DEDUP HEALTH ALTROOT  
reservoir 1.97G 91.5K 1.97G 0%  1.00x ONLINE - 
其容量为两个镜像虚拟设备的容量之和

查看池子的状态和布局
# zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
          mirror-1  ONLINE       0     0     0  
            vdd1    ONLINE       0     0     0  
            vde1    ONLINE       0     0     0  
  
errors: No known data errors 

可以看到这个池子有两个顶层vdev,mirror-0和mirror-1,ZFS在这两个vdev之间执行动态条带化,而每个vdev又对其数据进行镜像。

**3、创建raidz池**

RAID-Z有3种,分别为单奇偶校验的raidz或叫raidz1,双奇偶校验的raidz2和三奇偶校验的raidz3。一个RAID-Z配置包含 N 个大小为 X 的磁盘,其中有 P 个奇偶校验磁盘,该配置可以存放大约 (N-P)*X 字节的数据,并且只有在 P 个设备出现故障时才会危及数据完整性。单奇偶校验 RAID-Z 配置至少需要两个磁盘,双奇偶校验 RAID-Z 配置至少需要三个磁盘,三奇偶校验 RAID-Z 配置至少需要四个磁盘。单奇偶校验至多只能掉一块磁盘,双奇偶校验至多只能掉2块盘,三奇偶校验至多只能掉3块盘。

创建raidz2池
# zpool create reservoir raidz2 /dev/vdb /dev/vdc /dev/vdd

查看池子基本信息
# zpool list reservoir NAME      SIZE  ALLOC FREE  CAP DEDUP HEALTH ALTROOT  
reservoir 2.95G 279K  2.95G 0%  1.00x ONLINE - 

查看池子的状态和布局
# zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          raidz2-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
            vdd1    ONLINE       0     0     0  
  
errors: No known data errors 

可以看到池子的顶层vdev设备为raidz2-0

**4、创建使用日志设备的存储池**

默认情况下,ZFS的日志从主池中分配,通过提供单独的日志设备，可以提高ZFS的性能和安全性,也可以使用镜像日志设备,但日志设备不支持RAID-Z,也就是日志设备不可以作成RAID-Z方式,但是RAID-Z池可以使用日志设备。
创建使用镜像日志设备的raidz池
# zpool create reservoir raidz /dev/vdb /dev/vdc log mirror /dev/vdd /dev/vde

查看池子的状态和布局
#zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          raidz1-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
        logs  
          mirror-1  ONLINE       0     0     0  
            vdd1    ONLINE       0     0     0  
            vde1    ONLINE       0     0     0  
  
errors: No known data errors 

**5、创建使用高速缓存设备的存储池**
为池子指定高速缓存设备可以有效提高ZFS的性能,比如使用SSD作为高速缓存设备

# zpool create reservoir raidz /dev/vdb /dev/vdc cache /dev/vdd /dev/vde

查看池子的状态和布局
#zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          raidz1-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
        cache  
          vdd1      ONLINE       0     0     0  
          vde1      ONLINE       0     0     0  
  
errors: No known data errors 

**6、创建使用热备件的存储池**
ZFS支持hot spare,通过指定热备件,当池中的活动设备发生严重故障时必须更换时,ZFS可以自动使用热备件来替换故障设备

# zpool create reservoir raidz /dev/vdb /dev/vdc spare /dev/vdd /dev/vde

查看池子的状态和布局
# zpool status reservoir pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          raidz1-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
        spares  
          vdd1      AVAIL     
          vde1      AVAIL     
  
errors: No known data errors