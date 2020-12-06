---
title: VirtualBox虚拟硬盘VDI扩展容量(resize/expand capacity)
tags:
  - Virtualbox
id: '339'
categories:
  - - GNU/Linux
date: 2009-07-11 22:52:28
---

虽然VirtualBox支持虚拟硬盘的动态扩展,也就是VDI文件的大小随着guest使用的容量而增大，但是动态扩展的上限就是你最初指定的虚拟硬盘的大小值。也许是因为心理的原因，这个值你指定的过小了，你使用了一段时间才会发现这个问题。我就是这样:(。但是很不幸，现在VirtualBox还没有提供改变虚拟硬盘大小上限的功能。其实安装guest时完全可以指定一个很大的值，毕竟它不会占用多余的硬盘空间，仅仅占用guest真正利用到的空间而已。但是问题已经出现了，重新来过显然太过麻烦了，办法还是有的。
<!-- more -->
最简单的办法也许就是给guest增加一块虚拟硬盘吧，这样最省时省力了。但是我真的不想再搞出一块硬盘来，虚拟机还是越简单越好。
那怎么办呢？答案就是用一块更大容量的虚拟硬盘来替换原来的虚拟硬盘，把原来的内容完整的clone到新的虚拟硬盘上来。这次不要吝啬了，把虚拟硬盘设置的大一点吧。resize之前记得备份一下guest,如果搞坏了别怪我没告诉你:) 下面就说一说具体的步骤。

1.  为你的guest新增一块大容量的虚拟硬盘，并在guest的HDD设置里面把它挂在IDE的primary slave接口上，原来的硬盘一般应该在primary master上面，当然你也可以随便挂，但会影响到后面的硬盘编号。

2.  从[http://gparted.sourceforge.net/](http://gparted.sourceforge.net/)下载GParted LiveCD,将下载的ISO文件挂载到guest的光驱上面，并且从光驱启动。简单的回车默认启动就可以了。

3.  因为新硬盘是空的，必须将旧硬盘的MBR拷贝过来，这样才能正常启动。从虚拟机桌面上点击terminal启动X终端模拟器,可以输入fdisk -l来查看一下你的硬盘设备号，按上面的设置，旧硬盘应该是hda,而新硬盘是hdb。
    dd if=/dev/hda of=/dev/hdb bs=512 count=1
    切记不要搞反了，否则旧硬盘的MBR就成空白了。dd是dataset definition的缩写,此命令来源于古老的IBM JCL(作业控制语言)，是一个底层I/O facility。MBR里面包含有分区表信息，这样拷贝以后新硬盘里面也有了一个和旧硬盘一般大小的分区，这是我们不需要的，删除掉先。
    fdisk /dev/hdb,然后输入fdisk命令d也就是在Command (m for help):后面输入d就可以删除掉这个分区，然后输入fdisk命令w把改变写回硬盘，然后q退出。

4.  启动GParted程序。GParted会扫描到这两个硬盘。在旧硬盘hda的分区(我的是主分区hda1)上面右击选择copy,然后选择新硬盘hdb,在其上右击选择paste,并把目的分区拖到最大，起码我的guest只要一个主分区就可以了,如下图所示。最后点击apply进行真正的拷贝动作。耐心的等待一段时间。[![gparted](/images/2009/07/gparted-300x206.png "gparted")](/images/2009/07/gparted.png)

5.  在新硬盘的主分区hdb1上右击选择"manage flags",为此分区添加boot标志，以便从该分区启动。

6.  从虚拟机设置里面为guest去掉cd rom，去掉旧的虚拟硬盘，把新虚拟硬盘挂载到IDE的Primary master上面，启动guest。第一次用新硬盘启动可能会遇到磁盘检查。
到此应该就OK了,以后新建guest的时候一定要把虚拟硬盘搞大一点，省的这么麻烦。
-----------
最后是广告时间：
GNU牌GParted Live CD实在是您居家旅行,打家劫舍,杀人越货之必备佳品:)