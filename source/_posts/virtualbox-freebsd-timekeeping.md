---
title: 'VirtualBox:客户机FreeBSD 7.2时间严重漂移、跑慢问题'
tags:
  - FreeBSD
  - Virtualbox
id: '209'
categories:
  - - FreeBSD
date: 2009-06-23 19:54:54
---


<!-- more -->
一直琢磨着抽空再玩玩FreeBSD,第一次接触FreeBSD是6.0-Release,距现在时间不短了。

前几天有点儿时间，在windows 2003 R2 x86服务器上的VirualBox 2.2.4里面开始安装最新的FreeBSD 7.2 AMD64 Release。安装也还算顺利，毕竟原来接触过，熟悉了他的分区规则概念slice和partition就没啥大的障碍了。这次装FreeBSD要好好的研究一下，以后在FreeBSD里面host个网站，FreeBSD毕竟是TCP/IP的发源地，其稳定性也是有目共睹的。

因为有在VirtualBox里面安装Debian的经验，特别关注了一下客户机的时间，果然客户机的时间走的特别慢，没多久就与Host差了几分钟，而且可以看到时间差在明显的拉大。系统时间的准确性对于服务器来讲还是比较重要的，cron守护程序，网络日志等都严重依赖于系统时间。因为在客户机Debian使用的ntpd来校对系统时间，运行很正常，也在这里如法炮制吧，在运行ntpd之前也用ntpdate同步了几次时间。但是，为什么又是"但是"。
ntpd看样子很正常，但是Guest系统时间依旧比Host慢一拍,差距眼看着在拉大。当时实在是搞不清怎么回事了，google了一下也没找到满意答案，就暂时放下了。

今天连上FreeBSD一看，晕，时间都慢了一天多了，看来不解决时间是不行了。去google英文站搜，经过几轮筛选总算发现了一个有价值的信息：在FreeBSD的/boot/loader.conf文件里面增加一句kern.hz=100。赶快试验了一下，还真是这样,记得要重启一下guest。不用开ntpd时间也跑的很准确了。当然如果你要求很高可以继续开着ntpd。kern=100这几话怎么讲呢，[官方](http://cnsnap.cn.freebsd.org/doc/zh_CN.GB2312/books/handbook/virtualization-guest.html)说是降低客户化FreeBSD的CPU使用率，难道是因为CPU使用率高导致部分时钟中断丢失造成时间跑慢吗？我还没想明白，谁明白这个原理给我留言解释一下吧，谢谢。

**\===
\[erq\]**