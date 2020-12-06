---
title: KVM性能优化
tags:
  - Debian
  - KVM
id: '2207'
categories:
  - - GNU/Linux
date: 2012-04-28 11:28:45
---

KVM虚拟环境性能优化的几个措施
<!-- more -->
KVM本来性能已经很不错了,但还有一些微调措施来进一步提高KVM性能。

**1、virtio**

virtio是KVM的半虚拟化机制,用以提高IO性能,使用virtio可以显著提高KVM性能。virtio具体使用方法参见[1](https://openwares.net/linux/debian_kvm.html),[2](https://openwares.net/linux/kvm_client_install.html)。

**2、使用writeback缓存选项**

针对客户机块设备的缓存,drive有一个子选项cache来设置缓存模式。两个主要的选项为writeback和writethrough,man手册是这样说的

By default, writethrough caching is used for all block device. This means that the host page cache will be used to read and write data but write notification will be sent to the guest only when the data has been reported as written by the storage subsystem.

Writeback caching will report data writes as completed as soon as the data is present in the host page cache. This is safe as long as you trust your host. If your host crashes or loses power, then the guest may experience data corruption.

writethrough写操作时不使用主机的缓存,只有当主机接受到存储子系统写操作完成的通知后,主机才通知客户机写操作完成,也就是说这是同步的。而writeback则是异步的,它使用主机的缓存,当客户机写入主机缓存后立刻会被通知写操作完成,而此时主机尚未将数据真正写入存储系统,之后待合适的时机主机会真正的将数据写入存储。显然writeback会更快,但是可能风险稍大一些,如果主机突然掉电,就会丢失一部分客户机数据。

这样使用writeback选项
```js
-drive file=debian.img,if=virtio,index=0,media=disk,format=qcow2,cache=writeback 
```
CDROM设备也可以使用writeback选项

**3、客户机的磁盘IO调度策略**

磁盘IO要经过调度才可以写入磁盘,这种调度又称作电梯算法。对于客户机对磁盘的IO操作实际上要经过三次IO调度才能真正访问到物理磁盘,客户机对虚拟磁盘执行一次IO调度,KVM主机对所有上层的IO执行一次调度,当KVM主机将IO提交给磁盘阵列时,磁盘阵列也会对IO进行调度,最后才会真正读写物理磁盘。

客户机看到的磁盘只不过是主机的一个文件,所以其IO调度并无太大意义,反而会影响IO效率,所以可以通过将客户机的IO调度策略设置为NOOP来提高性能。NOOP就是一个FIFO队列,不做IO调度。

linux客户机使用grub2引导时,可以通过给内核传递一个参数来使用NOOP调度策略

编辑文件/etc/default/grub

行GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"后添加elevator=noop,变成为
```js
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash elevator=noop"
```
然后
```js
$ sudo update-grub
```

**4、打开KSM(Kernel Samepage Merging)**

页共享早已有之,linux中称之为COW(copy on write)。内核2.6.32之后又引入了KSM。KSM特性可以让内核查找内存中完全相同的内存页然后将他们合并,并将合并后的内存页打上COW标记。KSM对KVM环境有很重要的意义,当KVM上运行许多相同系统的客户机时,客户机之间将有许多内存页是完全相同的,特别是只读的内核代码页完全可以在客户机之间共享,从而减少客户机占用的内存资源,从而可以同时运行更多的客户机。

查看内核是否支持KSM特性:
```js
$ grep KSM /boot/config-\`uname -r\`
CONFIG_KSM=y
```

Debian系统中KSM默认是关闭的,通过以下命令来开启KSM
```js
# echo 1 > /sys/kernel/mm/ksm/run
```
关闭KSM
```js
# echo 0 > /sys/kernel/mm/ksm/run
```
这样设置后,重新启动系统KSM会恢复到默认状态,尚未找个哪个内核参数可以设置在/etc/sysctl.conf中让KSM持久运行。

可以在/etc/rc.local中添加
```js
echo 1 > /sys/kernel/mm/ksm/run
```
让KSM开机自动运行

有个哥们不喜欢rc.local,为ksm写了[个debian风格的system V init脚本](http://dnaeon.github.io/enable-ksm-during-boot-time-on-linux/),很简洁。

通过/sys/kernel/mm/ksm目录下的文件来查看内存页共享的情况,pages_shared文件中记录了KSM已经共享的页面数。

国人对KSM做了进一步优化,这就是[UKSM](http://kerneldedup.org/)(Ultra KSM)项目,据说比KSM扫描更全面,页面速度更快,而且CPU占用率更低,希望此项目能尽快进入内核mainline。

KSM会稍微的影响系统性能,以效率换空间,如果系统的内存很宽裕,则无须开启KSM,如果想尽可能多的并行运行KVM客户机,则可以打开KSM。

**5、KVM Huge Page Backed Memory** 

通过为客户机提供巨页后端内存,减少客户机消耗的内存并提高TLB命中率,从而提升KVM性能。x86 CPU通常使用4K内存页,但也有能力使用更大的内存页,x86_32可以使用4MB内存页，x86_64和x86_32 PAE可以使用2MB内存页。x86使用多级页表结构,一般有三级,页目录表->页表->页,所以通过使用巨页,可以减少页目录表和也表对内存的消耗。当然x86有缺页机制,并不是所有代码、数据页面都会驻留在内存中。

首先挂装hugetlbfs文件系统
```js
#mkdir /hugepages
#mount -t hugetlbfs hugetlbfs /hugepages
```
然后指定巨页需要的内存页面数
```js
#sysctl vm.nr_hugepages=xxx
```
最后指定KVM客户机使用巨页来分配内存
```js
kvm -mem-path /hugepages
```
也可以让系统开机自动挂载hugetlbfs文件系统,在/etc/fstab中添加
```js
hugetlbfs /hugepages hugetlbfs defaults 0 0
```
在/etc/sysctl.conf中添加如下参数来持久设定巨页文件系统需要的内存页面数
```js
vm.nr_hugepages=xxx
```
巨页文件系统需要的页面数可以由客户机需要的内存除以页面大小也就是2M来大体估算。

References:
\[1\][Enable KSM during boot-time on Linux](http://dnaeon.github.io/enable-ksm-during-boot-time-on-linux/)
\[2\][KSM init.d script for Debian GNU/Linux](https://github.com/dnaeon/ksm-init.d-debian)

**\===
\[erq\]**