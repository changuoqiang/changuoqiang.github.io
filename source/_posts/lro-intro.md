---
title: LRO(Large receive offload)介绍
tags:
  - Debian
id: '2077'
categories:
  - - Internet
date: 2012-04-02 21:51:46
---

Large receive offload是提高网络inbound吞吐量的一种技术
<!-- more -->
LRO(Large Receive Offload)通过将接收到的多个TCP数据包聚合到一个大的缓冲区，然后再传递给上层的网络协议栈处理，以减少上层协议栈开销，改善系统接收TCP数据包的能力。即使该技术完全使用软件实现，也会极大的改善网络处理性能。现在大部分网卡都从硬件上支持此项特性。

可以使用ethtool关闭此项特性

#ethtool -K ethX lro off

查看网络接口的其他offload特性

#ethtool -k- -show-offload ethX

Offload parameters for eth0:
rx-checksumming: on
tx-checksumming: on
scatter-gather: on
tcp-segmentation-offload: on
udp-fragmentation-offload: off
generic-segmentation-offload: on
generic-receive-offload: off
large-receive-offload: off
ntuple-filters: off
receive-hashing: off