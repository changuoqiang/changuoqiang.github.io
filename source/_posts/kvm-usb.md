---
title: KVM客户机使用主机USB设备
tags:
  - KVM
id: '1506'
categories:
  - - GNU/Linux
date: 2011-06-02 16:27:17
---

有些时候KVM客户机还是要使用USB设备,比如USB密钥等
<!-- more -->
**KVM命令行参数**

-usb 打开usb驱动程序,启动客户机usb支持
-usbdevice devname 为客户机增加usb设备,devname有多种形式,详见man kvm,这里只涉及一种形式host:vendor_id:product_id,也就是-usbdevce vendor_id:product_id

**获取USB设备参数**

将usb设备插入主机之前

$lsusb > usb.old

usb设备插入主机之后

$lsusb > usb.new

然后

vimdiff usb.old usb.new

找到新增加的那一行，类似下面这行

Bus 002 Device 004: ID 13fd:1040 Initio Corporation

ID后面的两个字段分别是vendor_id和product_id

**映射usb设备**
客户机命令行添加这两个参数
sudo kvm -usb -usbdevice host:13fd:1040 ... 

这样客户机就可以看到映射的USB设备了

**小问题**

把移动硬盘映射到客户机做测试,虚拟客户机竟然无法启动了，从远程vnc看一直停留在Booting from Hard Disk...,搜索了下下也无结果,后来灵光一闪，是不是因为移动硬盘成了启动磁盘？果然如此,修改引导参数如下

-boot order=c,menu=on

这里增加了menu=on,这样启动的时候按F12可以选择从哪个驱动器启动,重新启动，果然看到移动硬盘成了第一个启动设备，选择本地硬盘正常启动系统，从客户机里也可以看到移动硬盘。

据了解，现在KVM还没有命令行参数可以设置从第二块硬盘启动，也有人在提这个事情，建议order=e从第二块硬盘启动，依次类推。

**update:**
参数-usbdevice devname映射普通的USB设备有两种格式,devname可以指定为
host:bus.addr 
host:vendor_id:product_id
上面-usbdevice host:13fd:1040指定的是host:vendor_id:product_id这种格式，对于例子中显示的USB设备，也可以以host:bus.addr格式设定参数
host:2.4
其中2为总线号,4为设备在总线上的地址Bus 002 Device 004,但是使用host:bus.addr这种格式有一个缺点，如果USB设备换一个插口，其总线和设备号会发生变化，而host:vendor_id:product_id这种格式则不受影响,即便客户机换到另一台主机上跑也是一样。

**update again(09/19/2012):**

KVM主机上插了两个同类型的usb设备,这个两个usb设备的verdor_id和product_id竟然完全一样,那只能通过host:bus.addr这种方式为客户机指定usb设备了,不然kvm主机会不知所措吧。