---
title: UEFI+GPT windows 8 超级本安装debian wheezy双启动
tags:
  - Debian
id: '2764'
categories:
  - - GNU/Linux
date: 2013-01-17 21:54:30
---

近期换了lenovo yoga 13超级变形本,windows本来用的就不多,windows 8更是无从下手,debian才顺手
<!-- more -->
yoga 13外形靓丽,还能360度旋转,价格还算适中,最终没有选macbook air选了yoga 13,还是有些大了,但是yoga 11性能差了太多，未做考虑。升级了8G内存,硬盘只有128G,空间略显紧张,但速度飞快。

yoga 13使用UEFI BIOS,硬盘为GPT分区格式,还是第一次用UEFI和GPT。

debian wheezy已经开始支持UEFI启动和传统的BIOS启动两种启动方式。

此处使用usb盘UEFI启动方式安装,大体过程如下：

**1、下载最新的**[debian testing netinst iso amd64 daily build](http://cdimage.debian.org/cdimage/daily-builds/daily/arch-latest/amd64/iso-cd/debian-testing-amd64-netinst.iso)

**2、制作启动usb stick**

# cat debian-testing-amd64-netinst.iso > /dev/sdb
# sync

此处sdb为usb stick的设备名,请一定要弄明白你的usb stick是哪个设备名再下手,切记！或者用dd命令亦可。
这样制作的usb stick启动盘支持UEFI和LEGACY两种启动模式。

**3、usb启动安装debian**

插入usb stick,进入BIOS,启动方式不要动,保持UEFI方式,启动设备会多了一个,将其调整到第一个启动顺序。保存启动后开始安装debian,安装过程与以往基本相同,只是grub2这次不会安装到MBR而已,其实MBR根本就不存在。

**4、修正grub2启动配置文件**

grub2也会扫描到windows 8的存在,但其配置文件却是错误的，如下：
 88 \### BEGIN /etc/grub.d/30_os-prober ###  
 89 menuentry "Windows Recovery Environment (loader) (on /dev/sda3)" --class windows --class os {  
 90     insmod part_gpt  
 91     insmod fat  
 92  **set root**\='(hd0,gpt3)'  
 93  **search --no-floppy --fs-uuid --set**\=root 80AB-6F68  
 94     drivemap -s (hd0) $**{root}**  
 95     chainloader +1  
 96 }  
 97 menuentry "Windows 8 (loader) (on /dev/sda5)" --class windows --class os {  
 98     insmod part_gpt  
 99     insmod ntfs  
100  **set root**\='(hd0,gpt5)'  
101  **search --no-floppy --fs-uuid --set**\=root F8FA707EFA703B48  
102     drivemap -s (hd0) $**{root}**  
103     chainloader +1  
104 }  
105 \### END /etc/grub.d/30_os-prober ### 

虽然是GPT分区模式,却仍然使用了传统BIOS的链式启动方式,也就是legacy模式,所以启动windows 8时会报错:

error: unknown command 'drivemap'
error: invalid EFI filepath

所以需要手动修正grub2的启动配置

首先禁止grub2探测其他windows 8系统
/etc/default/grub文件中添加
GRUB_DISABLE_OS_PROBER=true

然后在文件/etc/grub.d/40_custom文件中添加如下配置
 menuentry **"**windows 8 uefi**"** {  
    search --file --no-floppy --**set**\=root /efi/Microsoft/Boot/bootmgfw.efi  
    chainloader **(**${root}**)**/efi/Microsoft/Boot/bootmgfw.efi  
} 

最后
#update-grub
就可以顺利启动windows 8系统了。

**P.S.**
触摸屏在wheezy下还不能用,据说安装touchscreen驱动可以,但好像都支持的不好,还是等kernel 3.8更靠谱,彼时会支持windows多点触摸协议。bluetooth和wireless都没驱动起来,型号为RTL8723AU,但Realtek官方没有此芯片的信息,发送邮件询问尚未得到答复。现在使用了一个迷你usb wifi dongle上网,真悲催！从askubuntu找到了RTL8723AE的驱动,二者的区别在接口形式不同,RTL8723AU为usb 2.0接口,RTL8723AE为pci-e接口,RTL8723AE的驱动没有usb相关的支持,如果官方没有驱动,改造RTL8723AE使其支持usb 2.0接口?这是个挑战！