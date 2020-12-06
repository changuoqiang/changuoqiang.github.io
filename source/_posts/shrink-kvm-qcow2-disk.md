---
title: 缩小qcow2格式kvm虚拟镜像磁盘大小
tags:
  - Debian
  - KVM
id: '2154'
categories:
  - - GNU/Linux
date: 2012-04-26 12:49:04
---

qcow2格式的虚拟磁盘初始容量设置过大,虽然并不会实际占用主机这么大的磁盘空间,只占用客户机实际使用的空间大小,但有时候还是有些不太方便,所以需要将其收缩(shrink)以下。
<!-- more -->
qemu-img命令有一个选项resize可以改变磁盘镜像的大小,其格式如下

#qemu-img resize filename \[+-\]size

+就是增加磁盘镜像的大小,-就是缩小磁盘镜像的大小,此处的磁盘镜像的大小并不是磁盘镜像文件在KVM主机中实际占用的存储空间大小,而是KVM客户机看到的磁盘的大小。

但是扩大或收缩磁盘镜像大小远没有这么简单。

man qemu-img如是说:
当使用此命令收缩磁盘镜像之前,必须使用客户机的文件系统和分区工具来收缩文件系统和分区,然后再执行resize操作,不然会可能丢失数据。当使用此命令扩大了磁盘镜像之后,必须使用客户机的文件系统和分区工具来使用新增加的磁盘容量。这很好理解,KVM支持的客户机操作系统多种多样,而且都有成熟的文件系统和分区操作工具,resize操作只是简单的扩大或缩小磁盘镜像大小,而不能也无需来了解客户机怎么应对这个改变,这是客户机的事情。面对这么多种类型的客户机,resize也只能做这么多工作了。

不幸的是resize尚不支持qcow2格式的磁盘镜像收缩,会有提示

qemu-img: This image format does not support resize

但是扩大qcow2磁盘镜像没有问题。磁盘镜像扩大另文再叙,先说下缩小,针对不同的客户机会有不同的操作方式。

**linux客户机**

这里收缩的是一个debian客户机磁盘镜像,其他linux客户机应无不同。

主要的思路就是通过分配一个新的小容量的磁盘镜像,挂载为虚拟机的新的磁盘,然后使用gparted live cd启动虚拟机,将分区拷贝到新的磁盘,然后用新的磁盘启动客户机。

主要步骤如下：

1.  创建新的小容量的磁盘镜像
    
    #qemu-img create -f qcow2 debian_new.qcow2 15G
    Formatting 'debian_new.qcow2', fmt=qcow2 size=16106127360 encryption=off cluster_size=65536
    下载[GParted](http://gparted.sourceforge.net/) live cd iso镜像,将二者挂载为客户机的新磁盘驱动器和光驱
     1 #!/bin/bash  
    2   
    3 kvm \-bios /usr/share/seabios/bios.bin \-smp 32 \-m 2G \-rtc base\=utc,clock\=host     **\**  
    4     \-net nic,model\=virtio,macaddr\=52-54-00-12-34-02 \-net tap,ifname\=tap2                   **\**  
    5     \-boot order\=d \-no-fd-bootchk                                                            **\**  
    6     \-drive file\=debian.qcow2,if\=virtio,index\=0,media\=disk,format\=qcow2,cache\=writeback  **\**  
    7     \-drive file\=debian_new.qcow2,if\=virtio,index\=1,media\=disk,format\=qcow2,cache\=writeback  **\**  
    8     \-drive file\=gparted.iso,index\=2,media\=cdrom  **\**  
    9     \-vnc :0 
    启动虚拟机
    

为新硬盘分区,然后将老硬盘上的分区拷贝到新的硬盘分区,如果原硬盘上的分区大于新的硬盘上的分区,可以通过GParted将原分区resize到小于新分区即可。交换分区不用拷贝,只要划出交换分区,在客户机内重新设置即可。分区拷贝完成后关闭虚拟机。
2.  用原硬盘引导客户机,使用dd将原硬盘的MBR及grub2用到的扇区拷贝到新的硬盘,grub2用到了MBR后面的保留扇区。这个保留扇区叫做post-MBR gap,范围为MBR之后,第一个分区之前。
    
    #fdisk -l
    Disk /dev/vda: 64.4 GB, 64424509440 bytes
    255 heads, 63 sectors/track, 7832 cylinders, total 125829120 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x000c6773
    
     Device Boot Start End Blocks Id System
    /dev/vda1 * 2048 27262975 13630464 83 Linux
    /dev/vda2 120637438 125827071 2594817 5 Extended
    /dev/vda5 120637440 125827071 2594816 82 Linux swap / Solaris
    
    Disk /dev/vdb: 16.1 GB, 16106127360 bytes
    255 heads, 63 sectors/track, 1958 cylinders, total 31457280 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0x0005fc82
    
     Device Boot Start End Blocks Id System
    /dev/vdb1 2048 27262975 13630464 83 Linux
    /dev/vdb2 27262976 31457279 2097152 82 Linux swap / Solaris
    
    可以看到客户机磁盘的第一个分区从2048扇区开始,保留扇区为2-2047扇区,第一扇区为MBR。因为两个硬盘分区并不完全相同,所以只拷贝MBR中的前446字节的引导代码即可。
    
    拷贝MBR引导代码
    #dd if=/dev/vda of=/dev/vdb bs=446 count=1
    拷贝保留扇区
    #dd if=/dev/vda of=/dev/vdb bs=512 seek=1 skip=1 count=2046
    

3.  关闭客户机,为客户机换上新的硬盘并从新硬盘启动
    一般来说拷贝过来的分区与原分区有相同的UUID,如若不然,新硬盘将无法引导客户机,但新建的swap分区其UUID发生了变化
    
    查看新硬盘分区的UUID
    #blkid
    /dev/vda1: UUID="48ed13f7-8640-4aba-8b8a-5efb087fadbf" TYPE="ext4" 
    /dev/vda2: UUID="b484c752-69be-4bcd-86c1-a3f70185cde1" TYPE="swap"
    
    打开/etc/fstab文件,将自动挂载文件系统的UUID修改成新硬盘上对应分区的UUID
    
    重新启动客户机,调整完毕。
    

**windows客户机**

1.  创建新的小容量的磁盘镜像
    
    #qemu-img create -f qcow2 windows_new.qcow2 20G
    将其挂载为客户机的第二块硬盘,将GParted挂载为客户机的光驱,设置客户机为光驱启动并启动客户机
    
2.  用gparted resize调整老硬盘分区使其略小于新硬盘容量并apply
    

3.  打开终端
    $sudo su -
    #dd if=/dev/vda of=/dev/vdb bs=512 count=1
    将老硬盘的MBR完整复制到新硬盘
    
4.  用GParted复制老硬盘分区至新硬盘,然后resize拷贝过来的分区至新硬盘全部容量
    
5.  将新硬盘挂载为客户机的第一块硬盘,并从新硬盘启动即可。启动时windows会检查磁盘,之后一切正常。