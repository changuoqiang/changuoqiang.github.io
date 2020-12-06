---
title: Debian无盘工作站安装指南
tags:
  - Debian
id: '892'
categories:
  - - GNU/Linux
date: 2010-09-12 20:04:59
---

写此文缘于有一台老本IDE控制器坏掉了,无法正常使用硬盘，但其他硬件尚好，遂折腾之，将折腾过程记录於此。当然虽然安装成功，老本仍难免束之高阁。

一、服务器端安装配置

1、参考《[PXE网络安装Debian](https://openwares.net/it/linux/pxe_install_debian.html)》安装配置好DHCP和TFTP服务

2、安装配置nfs服务器

sudo apt-get install nfs-common nfs-kernel-server,然后配置nfs,打开 /etc/exports文件，在最后添加一行,/srv/nfs/homes 192.168.1.0/24(rw,no_root_squash,no_subtree_check,sync),/srv/nfs/homes是服务器通过nfs对外提供的磁盘空间的根目录,当然无盘客户机可能不只一台，所以我们会在这个目录下再建立以无盘客户机的hostname为名字的子目录作为无盘机运行时的根文件系统。文中只有一台无盘客户机，hostname定为diskless

3、安装syslinux

sudo apt-get install syslinux,安装syslinux只是为了使用pxelinux.0文件，将此文件拷贝到tftpboot目录，sudo cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/
<!-- more -->
4、创建支持nfs的initird和kernel,以便从pxe启动并使用nfs磁盘

修改服务器的/etc/initramfs-tools/initramfs.conf文件，修改MODULES行为MODULES=netboot,BOOT行为BOOT=nfs，然后生成支持nfs的初始化虚拟磁盘,$sudo mkinitramfs -o /var/lib/tftpboot/initrd.nfs

内核则可以直接使用服务器安装的内核,当然前提是架构要相同，比如都是amd64或i386,$sudo cp /boot/vmlinuz-*** /var/lib/tftpboot/vmlinuz

5、利用debootstrap生成一个无盘客户机登录后可使用的根文件系统

在/srv/nfs/homes目录下以无盘客户机的hostname为名建立无盘客户机登录后根文件系统所在的目录，这里是diskless目录，然后在此目录下生成一个可登录的debian基本系统,$ sudo debootstrap - -arch=i386 lenny /srv/nfs/homes/diskless http://ftp.debian.org.tw/debian/

6、建立无盘客户机配置文件

在/var/lib/tftpboot目录建立pxelinux.cfg目录，然后在pxelinux.cfg目录下建立default文件,也可以是以无盘客户机ip地址为文件名称,default为无盘客户机缺省的配置文件,default文件内容如下

DEFAULT debian
LABEL debian
kernel vmlinuz 
append initrd=initrd.nfs root=/dev/nfs nfsroot=192.168.1.2:/srv/nfs/homes/diskless ip=dhcp rw vga=792
其中nfsroot指定了服务器的ip和客户机在该服务器上的根文件系统路径
至此无盘客户机应该可以通过PXE启动方式，进入一个字符终端，root密码为空。

二、无盘客户端安装配置

客户机端就比较简单了,以pxe方式启动，进入一个debian基本系统，虽然无盘客户机使用的内核是/var/lib/tftpboot/目录下的内核，但仍然需要安装一下内核，以解决这个基本系统的很多对内核的依赖问题，最好安装与启动内核一致的版本。安装好内核后就可以自由的安装其他软件了，当然安装X系统也是没问题的。