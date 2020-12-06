---
title: 贝奥武夫高性能计算集群(Beowulf Cluster)
tags:
  - Cluster
id: '1349'
categories:
  - - GNU/Linux
date: 2011-04-22 13:18:40
---

Beowulf cluster概念介绍
<!-- more -->
Beowulf是一种高性能并行计算集群，其原始的含义是指建造于1994年的一台特殊的计算机，类似于最初的NASA系统的一种计算机集群，起源于NASA。现在Beowulf在全世界范围内部署，主要用来进行科学计算，它们是由廉价的PC组成的高性能并行计算集群。Beowulf的名字来源于古英语诗歌Beowulf里面的主要人物,诗里面描述Beowulf可以用一只手轻而易举的举起30个人。

Beowulf集群通常有统一架构的、商用的计算机组成，这些计算机运行自由开源的软件(FOSS，Free and open source software),类UNIX操作系统，比如BSD,GNU/Linux或者Solaris。它们由TCP/IP网络连接到一起。

并没有一个特殊的软件来定义一个集群是Beowulf集群,通常是使用并行计算规范包括MPI(Message Passing Interface)和PVM(Parallel Virtual Machine),这两个并行计算规范都允许程序开发者在一组网络计算机间分解任务，并且将任务的计算结果再集成起来。MPI的实现包括OpenMPI和MPICH,都为开源软件,还有一些其他的MPI实现。

Beowulf不是一个特殊的软件包，也不是一种新的网络拓扑技术，Beowulf是集成廉价计算机组成并行虚拟超级计算机的一种技术，可以使用标准的GNU/Linux发行版来构建Beowulf集群。