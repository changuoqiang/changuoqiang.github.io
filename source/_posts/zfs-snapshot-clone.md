---
title: ZFS文件系统介绍 - 快照和克隆
tags:
  - Debian
  - ZFS
id: '2355'
categories:
  - - GNU/Linux
date: 2012-05-16 22:18:32
---

快照是文件系统或卷的只读副本,而克隆是可读写的卷或文件系统,克隆只能从快照创建。
<!-- more -->
**ZFS快照**

创建快照几乎没有任何成本,可以即时创建完成,而且快照创建的最初几乎不占用额外的存储池空间，ZFS采用COW策略,快照会与原始文件系统共享快照创建后一直没有变化的存储块。无法直接访问卷的快照,但是可以对它们执行克隆、备份、回滚等操作

**创建ZFS快照**

使用zfs snapshot filesystem@snapname,快照名称由两部分组成,@前面为文件系统名称,@后面为快照标识,二者组成完成的快照名

# zfs snapshot reservoir/data@thursday

查看ZFS快照
# zfs list -t snapshot NAME                      USED  AVAIL  REFER  MOUNTPOINT  
reservoir/data@thursday      0      -    30K  - 

使用-r选项为所有后代文件系统递归创建快照
# zfs snapshot -r reservoir/data@thursday

**销毁ZFS快照**

使用zfs destroy filesystem@snapname销毁ZFS快照
# zfs destroy reservoir/data@thursday

如果数据集(dataset)存在快照,则不能销毁该数据集。也可指定-r选项一起销毁快照和数据集。

**重命名ZFS快照**

可以重命名快照,但是不能跨越池和数据集对它们进行重命名。
# zfs rename reservoir/data@thursday reservoir/data@thursday1

可以使用更快捷的方式重命名快照
# zfs rename reservoir/data@thursday thursday1

**回滚ZFS快照**

可以使用 zfs rollback 命令放弃自特定快照创建以来对文件系统所做的全部更改。文件系统恢复到创建快照时的状态。缺省情况下,该命令无法回滚到除最新快照以外的快照。
要回滚到早期快照,必须销毁所有的中间快照。可以通过指定 -r 选项销毁早期的快照。如果存在任何中间快照的克隆,则还必须指定 -R 选项以销毁克隆。

# zfs rollback reservoir/data@thursday
则自此快照之后文件系统的任何改变都会被丢弃。

**ZFS快照差异比较**

可以使用 zfs diff 命令来比较两个ZFS快照之间的差异。

比如下面的例子
# cd /reservoir/data/
# touch file1
# zfs snapshot reservoir/data@snap1
# touch file2
# zfs snapshot reservoir/data@snap2
# zfs diff reservoir/data@snap1 reservoir/data@snap2
M /reservoir/data/
+ /reservoir/data/file2

M表示目录被修改过了,+表示文件/reservoir/data/file2存在与更新的快照中
zfs diff 命令输出符号的含义见下表
 文件或目录更改                                          标识符  
--------------------------------------------------      ------  
文件或目录已被修改,或文件或目录链接已更改               M  
文件或目录出现在较旧的快照中,但未出现在较新的快照中     -  
文件或目录出现在较新的快照中,但未出现在较旧的快照中     +  
文件或目录已重命名                                      R 

**ZFS克隆**

克隆是可写入的卷或文件系统,其初始内容与从中创建它的数据集的内容相同。与快照一样,创建克隆几乎是即时的,而且最初不占用其他磁盘空间。此外,还可以创建克隆的快照。克隆只能从快照创建。克隆快照时,会在克隆和快照之间建立隐式相关性。即使克隆是在文件系统分层结构中的其他位置创建的,但只要克隆存在,就无法销毁原始快照。

**创建ZFS克隆**

使用 zfs clone 命令创建克隆,指定从中创建克隆的快照以及新文件系统或卷的名称。新文件系统或卷可以位于ZFS文件系统分层结构中的任意位置。新数据集与从其中创建克隆的快照属同一类型(例如文件系统或卷)。不能在原始文件系统快照所在池以外的池中创建该文件系统的克隆,亦即克隆是不能跨越存储池的。

# zfs clone reservoir/data@snap2 reservoir/clone_snap2

**销毁ZFS克隆**

# zfs destroy reservoir/clone_snap2
必须先销毁克隆,才能销毁父快照。

**发送和接收ZFS快照流**

通过使用zfs send命令,可以将 ZFS 文件系统或卷的快照转换为快照流。然后可以通过zfs receive命令使用快照流重新创建 ZFS 文件系统或卷。
可以生成两种快照流：
完整流 - 包含从创建数据集时开始到指定的快照为止的所有数据集内容。zfs send 命令生成的缺省流是完整流。它包含一个文件系统或卷,直到并包括指定的快照。流不会包含在命令行上指定的快照之外的快照。

增量流 - 包含一个快照与另一个快照之间的差异。

使用 zfs send 命令来发送快照流,并在同一系统的另一个池中或用于存储备份数据的不同系统上的另一个池中接收快照流。

例如
# zfs send reservoir/data@snap1 zfs receive reservoir/data_received

这样通过send和receive发送和接收快照流生成一个新的ZFS文件系统reservoir/data_snap_stream

使用 zfs send -i 选项可以发送增量数据。

例如:
# zfs send -i reservoir/data@snap1 reservoir/data@snap2 zfs receive reservoir/data_received

这里snap1是较早的快照,snap2是较晚的快照,而且reservoir/data_received必须已经存在而且已经接收了snap1快照流,增量接收才能成功。

可以通过SSH将快照流发送到远程系统
# zfs send reservoir/data@snap1 ssh remote_system zfs receive reservoir/data_received

还可以将快照流压缩归档保存
# zfs send reservoir/data@snap1 gzip > data.gz

然后可以接收压缩归档的快照流
# zfs gunzip -c data.gz zfs receive reservoir/data_recv

可以将发送接收ZFS快照流以及其增量机制作为备份ZFS文件系统的一种策略,但这种备份方式不能逐个恢复文件,必须恢复整个文件系统。