---
title: linux amd64 memory mapping
tags: []
id: '8244'
categories:
  - - GNU/Linux
date: 2019-02-16 14:40:21
---


<!-- more -->
amd64架构linux kernel使用四级页表映射结构，但是存在两套terminology来描述这个事情

其一：

PML4(Page Map Leve4)(Level 4) -> PDP(Page Directory Pointer) (Level 3) -> PD(Page Directory) (Level 2) -> PTE(Page Table Entry)(Level 1)

另一：

PGD(Page Global Directory)(Level 4) -> PUD(Page Upper Directory)(Level 3) -> PMD(Page Middle Directory)(Level 2) -> PTE(Page Table Entry) (Level 1)

这两套术语其实表达的都是一样的东西,CR3寄存器保存Level 4表的物理地址，Level 4只有一页，4K大小，总共512个表项，每个表项可以寻址512GB内存，总共可以寻址256TB内存。
当前amd64处理器只是用了64位中的48位来寻址，因此使用四级页表时，虚拟地址的低48位为9+9+9+9+12映射结构，每个物理页框(Page Frame)为4K，4K地址对齐。
当使用2M的大页/巨页时，使用三级页表映射，虚拟地址的低48位为9+9+9+21映射结构，每个物理页框为2M,2M地址对齐。

参见下面两图：

4K页面地址转换
![4K页面地址转换](https://www.ibm.com/developerworks/cn/linux/l-lvm64/images/image004.gif)

2M 页面地址转换
![2M 页面地址转换](https://www.ibm.com/developerworks/cn/linux/l-lvm64/images/image006.gif)

为了支持更大的线性地址空间，以后的CPU会扩展到57位虚拟地址寻址。linux目前已经提供5级页表映射，如果启用5级页表，会在PGD和PUD之间插入新的一级页表，叫做P4D(Page 4 Directory)，这样PGD会成为第五级页表,参见\[1\]。

References:
\[1\][Five-level page tables](https://lwn.net/Articles/717293/)