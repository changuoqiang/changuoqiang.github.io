---
title: virtualbox vmdk虚拟硬盘扩容
tags:
  - Virtualbox
id: '7654'
categories:
  - - GNU/Linux
date: 2016-10-28 13:46:55
---


<!-- more -->
virtualbox的原生虚拟磁盘格式是vdi,也支持vmware的vmdk格式。virtualbox提供的工具vboxmanage支持vdi动态扩展磁盘的扩容。
对于vmdk格式可以先转换成vdi格式再行扩容，如果有必要扩容后可以转换回vmdk格式

**虚拟硬盘扩容**
```js
$ vboxmanage clonehd "source.vmdk" "cloned.vdi" --format vdi
$ vboxmanage modifyhd "cloned.vdi" --resize 20480
$ vboxmanage clonehd "cloned.vdi" "resized.vmdk" --format vmdk //如果需要转换回原格式
```

**客户系统扩容**

上一个步骤只是扩展了虚拟磁盘的容量，客户操作系统还需要扩展分区才能利用新的容量。
linux客户系统可以使用GParted动态扩展分区
windows客户系统可以使用diskpart命令来扩展分区，但此命令不能扩展当前启动分区，如需扩展启动分区，可以用其他虚拟机启动，扩容后的磁盘作为附加磁盘。

然后运行cmd，执行diskpart
```js
cmd> list disk // 查看磁盘
cmd> select disk 1 // disk后面的数值为扩容后磁盘的编号，从list disk中可以查到
cmd> list partition // 查看磁盘分区
cmd> select partition 0 // 根据list partition的显示，将0替换成C盘对应的分区号
cmd> extend // 扩容分区0
```


Refereces:
\[1\][VirtualBox扩容vmdk格式的Windows分区](http://blog.csdn.net/bourne_again/article/details/8063907)

**\===
\[erq\]**