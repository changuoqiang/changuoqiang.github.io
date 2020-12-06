---
title: 为无盘系统增加交换空间(Add Swap over NFS)
tags:
  - Debian
id: '899'
categories:
  - - GNU/Linux
date: 2010-09-12 20:52:13
---

内核现在尚不支持直接在NFS磁盘空间上启用swap，如果你在NFS上创建一个swapfile，然后强行swapon，系统会毫不犹豫的提示：
swapon:swap file has holes
swapon: /path/to/swapfile: Invalid argument
<!-- more -->
只能智取，不能强攻.步骤如下：

在NFS共享文件系统上创建一个ext3 loop文件系统

dd if=/dev/zero of=/var/cache/swap.ext3 bs=1024 count=262144
mkfs -t ext3 /var/cache/swap.ext3

然后挂装之

echo '/var/cache/swap.ext3 /var/cache/swap ext3 defaults,noauto 0 0' >> /etc/fstab
mkdir /var/cache/swap
mount -o loop /var/cache/swap

挂装后，在其中建立真正的swap文件

dd if=/dev/zero of=/var/cache/swap/swap0 bs=1024 count=260000
mkswap swap0
swapon swap0

最后一点也很重要

那就是这个loop文件系统不能自动挂装(noauto),因为系统启动的时候可能NFS共享还未准备好，所以在/etc/rc.local文件里增加下面两句
mount -o loop /var/cache/swap
swapon /var/cache/swap/swap0

---
It's OK!