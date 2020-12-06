---
title: python队列
tags:
  - python3
id: '7175'
categories:
  - - GNU/Linux
date: 2016-04-10 20:39:23
---


<!-- more -->
python有两个队列实现，分别是queue.Queue和mulitiprocess.Queue。

queue.Queue是线程安全的，用于线程间数据同步，而mulitiprocess.Queue是用于多进程间数据通讯的。如果在多进程间使用queue.Queue是无法共享数据的，每个进程会有一个单独的队列副本。

因为queue.Queue用于多线程数据同步，而mulitiprocess.Queue用于多进程数据同步。

python3中线程队列的名字为queue,而python2中其名字为Queue。

python中的list和dict不是线程安全的。

**task_done与join**

queue.Queue有一个join方法可以阻塞当前线程，直到队列中所有的item都处理完成了，所以需要每处理一个队列的item,调用一次队列的task_done方法，当队里的所有元素都标记为处理过了，join方法会从等待中返回。

如果不调用join方法，也就无需调用task_done方法了。

mulitiprocess.Queue并没有join特性，如需要此特性，应该使用multiprocessing.JoinableQueue队列

 **===
\[erq\]**