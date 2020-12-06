---
title: 基于KVM的P2V迁移
tags:
  - Debian
  - KVM
id: '2112'
categories:
  - - GNU/Linux
date: 2012-04-19 15:11:21
---

物理机迁移到虚拟机称之为P2V迁移即Phisycal to Virtual migration
<!-- more -->
虚拟化迁移技术按迁移方向分为P2V,V2V(Virtual to Virtual),V2P(Virtual to Phisycal)这三种类型，按迁移方式又有静态迁移和动态迁移之分。动态迁移的好处是可以基本保证物理机或虚拟机提供的服务在迁移过程中不会中断或极短时间中断,适用于那些十分关键的服务。当然动态迁移要求也会很高,相对来说静态迁移要简单的多,而且静态迁移相对来说更能保证数据的完整性。

最近共享存储的KVM虚拟化环境已经正常运行了一段时间,所以考虑将一些非关键的物理机迁移到KVM平台。

**P2V on KVM**

因为物理机提供的服务在某些时间段是可以中断的,所以选择相对简单的静态迁移。

P2V的主要工作是将物理机的磁盘设备制作成KVM可以使用的虚拟机磁盘镜像。常见的方法有使用dd命令或者使用磁盘/分区克隆工具。比如使用systemrescuecd引导物理机,然后使用dd制作磁盘/分区的镜像,并将其保存到移动设备或者网络。但是dd制作镜像会将磁盘完整复制,包括未使用的区域,镜像文件大,浪费时间和空间。这里使用linux克隆工具clonezilla来制作磁盘镜像，clonezilla只克隆使用到的数据区。

物理机操作系统为windows 2003 r2 sp2 x86版本。

**P2V迁移主要步骤：**

1.  下载[clonezilla](http://clonezilla.org/) live cd镜像并刻录CD或制作usb引导设备
  
3.  为源物理主机打开IDE设备支持。IDE设备是windows和linux沟通的最好桥梁,IDE十分成熟,而对于SCSI设备两个系统的支持则存在很多问题。所以KVM的虚拟机磁盘要设置为IDE接口才能顺利完成迁移。物理机使用SCSI接口的RAID磁盘设备,这种情况下,windows 2003默认并未提供IDE设备的支持,因此需要在物理机打开对IDE设备的支持。否则会遇到BSOD错误STOP: 0x0000007B。参考M$文章[Article ID: 314082](http://support.microsoft.com/kb/314082/en-us),导入注册表设置Mergeide.reg,然后将Atapi.sys, Intelide.sys, Pciide.sys和Pciidex.sys四个驱动文件拷贝到%SystemRoot%\\System32\\Drivers目录下。Intelide.sys在windows\\Driver Cache\\I386\\sp2.cab文件中,其他三个文件在windows\\Driver Cache\\I386\\driver.cab文件中。
  
5.  用clonezilla引导物理机,因为使用device-device模式未成功,所以使用device-image模式,选择ssh_server通过ssh将存储设备的镜像文件保存到ssh服务器,按clonezilla的向导一步步操作即可
  
7.  在KVM主机上分配虚拟机,虚拟机的硬盘容量要比物理机硬盘容量稍微大一些,加1G够了。虚拟机磁盘接口设置为IDE,将clonezilla镜像文件挂载为虚拟机的CDROM设备并从CDROM启动虚拟机,然后通过ssh_server模式从ssh服务器将物理机生成的镜像恢复到虚拟机，完成之后关机。
  
9.  对于P2V迁移,问题最大的是块存储设备和网络设备,块存储设备通过IDE这个桥梁来解决。而虚拟机添加的网络设备则需要重新安装驱动程序,物理机原来的网络设备和驱动就都废弃了。virtio是KVM的半虚拟化驱动,大大提高了虚拟机的IO性能。所以网卡使用virtio接口。下载[virtio驱动iso镜像](http://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/),将其挂载为虚拟机的CDROM设备,然后从硬盘启动虚拟机。windows客户机启动后会自动安装变化了的设备的驱动程序,同时也要安装网卡的virtio驱动
  
11.  如果物理机的网络接口使用静态IP,将其迁移到虚拟机后,使用了新的虚拟网络接口,这时如果给虚拟机赋予相同的静态IP,则windows会有提示有隐藏设备使用了相同的IP。此时可以打开隐藏的不存在的设备,然后找到物理机原来的网络接口将其删除,再为虚拟网络设备设置IP地址即可。如果在克隆物理机磁盘之前,将物理机的网络配置为自动获取IP,则此问题就不会存在了。
      
    如果想看到并删除原物理机的网卡,执行以下步骤
    打开一个控制台窗口,输入
    set devmgr_show_nonpresent_devices = 1
    然后在同一个控制台窗口输入
    start devmgmt.msc
    最后在打开的设备管理器窗口“显示隐藏的设备”,就可以看到原物理网卡了,将他们删除即可。
    
  

这样P2V迁移算是完成了,但是现在虚拟机使用的是IDE磁盘设备,为了提高磁盘IO性能,有必要将其转换到半虚拟化的virtio磁盘设备。

**虚拟机磁盘从IDE转换到virtio步骤：**

1.  停止虚拟机，创建一个新的磁盘映像并以virtio接口将其挂载为虚拟机的第二块硬盘,将virtio驱动iso镜像挂载为虚拟机的CDROM设备
  
3.  启动虚拟机,系统会提示安装virtio设备的驱动程序,按提示从CDROM安装驱动即可
  
5.  关闭虚拟机,去掉新添加的第二块磁盘,将原来磁盘的接口从IDE更改为virtio,启动虚拟机即完成磁盘设备的接口转换
  

至此完整的将物理机迁移到支持半虚拟化IO的虚拟机,完成P2V迁移。