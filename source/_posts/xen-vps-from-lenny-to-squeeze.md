---
title: xen vps从Debian Lenny升级到Squeeze
tags:
  - Debian
  - VPS
id: '1250'
categories:
  - - GNU/Linux
date: 2011-04-04 00:02:28
---

Squeeze发布有一段时间了,连Debian 6.0.1都出来了,vps还是用的lenny,真让人看在眼里,疼在蛋上,升级,必须的!
<!-- more -->
咨询了供应商,说vps现在已经可以独立升级系统了,但目前的vps还是运行在HVM(hardware Virtual Machine)模式下,必须重装vps转换到PV(ParaVirtualization)模式下才可以自由升级系统,真蛋疼!

备份,连上xen-shell,shutdown,rebuild后的却可以从/boot下看到内核了,从/boot/grub下也可以看到grub的配置文件了,不过还是lenny,开始升级...

 1 #vim /etc/apt/source.list  
 2 :%s/lenny/squeeze/g  
 3 :wq  
 4   
 5 #wget http://ftp-master.debian.org/keys/archive-key-6.0.asc  
 6 #apt-key add archive-key-6.0.asc  
 7   
 8 #apt-get update  
 9 #apt-get install apt dpkg  
10 #apt-get dist-upgrade  

先升级一下apt工具,这样才比较稳妥。最后配置grub2时选择不配置,就算选择配置其实也不行的。
最后修改一下/etc/grub/menu.lst,将第一个引导项设置为如下:

1 title       Debian GNU/Linux, kernel 2.6.32\-5\-xen\-amd64  
2 root        (hd0)  
3 kernel      /boot/vmlinuz\-2.6.32\-5\-xen\-amd64 root\=/dev/xvda ro  
4 initrd      /boot/initrd**.img**\-2.6.32\-5\-xen\-amd64  

1 #reboot  
2 #uname -a  

可以看到vps已经使用新的内核了。