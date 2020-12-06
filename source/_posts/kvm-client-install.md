---
title: 'Debian Squeeze KVM虚拟机安装笔记(2):客户机安装'
tags:
  - KVM
id: '1481'
categories:
  - - GNU/Linux
date: 2011-05-13 13:35:52
---

KVM主机端设置完毕后,开始安装客户机,这里介绍两个客户机的安装,Debian Squeeze AMD64和Windows 2003 x64
<!-- more -->
当然主机系统是64位平台,必须的。

**准备**

因为要使用半虚拟化(Paravirtualized)驱动virtio,但是当前的Debian Stable版本也就是squeeze发行版的kvm并不支持从virtio驱动器启动,所以需要更新一下seabios,从Debian官方sid源下载[seabios 0.6.1.2](http://ftp.us.debian.org/debian/pool/main/s/seabios/seabios_0.6.1.2-2_all.deb),然后手动安装该包 seabios_0.6.1.2-2_all.deb

$sudo dpkg -i seabios_0.6.1.2-2_all.deb

主机系统只安装了debian基本系统(base system),没有X,因此使用VNC来远程安装客户机，如果使用windows系统,请自行下载TightVNC Viewer。

**KVM核心参数**

这是只简单介绍几个主要的参数,详细的文档请见man kvm。

-bios file 
指定虚拟机使用的BIOS,file指定BIOS文件路径

-smp n\[,cores=cores\]\[,threads=threads\]\[,sockets=sockets\]\[,maxcpus=maxcpus\]
模拟一个有n个cpu的smp系统,可以简单的指定n为一个数值,或者分别指定socket数,core数/socket,线程数/core

-m megs
指定虚拟机使用的内存数量,可以使用M或G后缀

-rtc \[base=utclocaltimedate\]\[,clock=hostvm\]\[,driftfix=noneslew\]
指定虚拟机使用的时间,linux客户机使用-rtc base=utc,clock=host,windows客户机使用-rtc base=localtime,clock=host

-net nic,model=virtio,macaddr=52-54-00-12-34-01 -net tap,ifname=tap0
桥接网络，客户机网络接口通过tap接口桥接到主机网络，使用的tap接口名为tap0，由/etc/kvm/kvm-ifup来动态配置tap0接口。model=virtio指定虚拟机网卡使用半虚拟化驱动,如果有多个虚拟客户机同时运行则必须指定macaddr为一个独一无二的值,否则会出现mac地址冲突。如果通过主机的/etc/network/interfaces来静态配置tap接口,则此处应在-net tap接口处附加两个另外的参数script=no,downscript=no

-drive file=debian.img,if=virtio,index=0,media=disk,format=qcow2,cache=writeback
指定客户机使用的硬盘驱动器,if=virtio指定使用半虚拟化驱动,index=0指定该硬盘为接口的第一个驱动器,media=disk指定为硬盘驱动器,如果是光盘则为media=cdrom。旧式指定第一个硬盘驱动器的参数为-hda debian.img,已经不再推荐使用。

-drive file=debian.iso,index=2,media=cdrom或者-hdc debian.iso
指定光盘驱动器,debian.iso为使用的光驱映像文件

-fda file
指定软盘驱动器,file为软磁盘镜像 

-no-fd-bootchk
客户机启动时不检查软盘驱动器,加速客户机启动

-boot order=c
指定引导顺序,c为第一个硬盘驱动器,d为第一个光盘驱动器

-vnc :0
将虚拟机的视频输出重定向到vnc端口,通过vnc viewer可以连接到虚拟机的视频输出

-nographic
禁止kvm虚拟机的视频输出

-daemonize
后台运行虚拟机

**安装Debian Squeeze AMD64客户机**

使用一下脚本开始安装debian客户机

1 #!/bin/bash  
2   
3 sudo kvm \-bios /usr/share/seabios/bios.bin \-smp 16 \-m 4G \-rtc base\=utc,clock\=host       **\**  
4     \-net nic,model\=virtio,macaddr\=52-54-00-12-34-01 \-net tap,ifname\=tap0                **\**  
5     \-boot order\=c \-no-fd-bootchk                                                        **\**  
6     \-drive file\=debian.img,if\=virtio,index\=0,media\=disk,format\=qcow2,cache\=writeback    **\**  
7     \-drive file\=debian.iso,index\=2,media\=cdrom                                          **\**  
8     \-vnc :0  

这里指定虚拟机使用的BIOS,这样安装完成后才能从virtio磁盘启动客户机,debian.iso为客户机安装光盘镜像,远程通过vnc viewer连接到主机开始安装客户机,Debian Squeeze内置支持virtio设备支持,因此正常安装即可。

安装完毕开启sshd后,将-vnc :0参数更换为-nographic -daemonize,以后通过ssh登录即可。

**安装windows 2003 R2 x64客户机**

首先从Fedora下载[virtio for windows驱动](http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/),使用如下脚本启动虚拟安装
1 #!/bin/bash  
2   
3 sudo kvm \-bios /usr/share/seabios/bios.bin \-smp 16 \-m 2G \-rtc base\=localtime,clock\=host     **\**  
4     \-boot order\=d                                                                           **\**  
5     \-net nic,model\=virtio,macaddr\=52-54-00-12-34-02 \-net tap,ifname\=tap1                    **\**  
6     \-drive file\=win2k3_dns.qcow2,if\=virtio,index\=0,media\=disk,format\=qcow2,cache\=writeback  **\**  
7     \-drive file\=windows_2003_r2_x64_cd1.iso,index\=2,media\=cdrom                             **\**  
8     \-fda virtio-win\-1.1.16.vfd                                                              **\**  
9     \-vnc :0   

使用vnc viewer连接到主机开始安装,按F6从[virtio软磁盘镜像](/downloads/virtio-win-1.1.16.vfd)加载virto驱动,否则会找不到硬盘驱动器,系统安装完成后将光驱换上virtio-win-1.1.16.iso安装virtio网卡驱动,打开远程桌面后将-vnc :0替换成-nographic -daemonize,然后用远程桌面管理虚拟机即可。