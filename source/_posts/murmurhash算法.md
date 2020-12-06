---
title: MurmurHash算法
tags: []
id: '6803'
categories:
  - - Misc
date: 2015-10-30 11:33:21
---


<!-- more -->
MurmurHash是一种非加密的哈希算法，目前主要用于数据分区。

其名字来自于MUltiply and Rotate,因为要经过多次MUltiply and Rotate，所以叫Murmur.

当前版本为MurmurHash3，cassandra使用了这个哈希算法来对数据进行分区，因此对应分区器的名字为Murmur3Partitioner,此分区器是cassandra当前默认的分区器。

推荐使用Murmur3Partitioner分区器。

References:
\[1\][MurmurHash](https://en.wikipedia.org/wiki/MurmurHash)
\[2\][陌生但默默一统江湖的MurmurHash](http://calvin1978.blogcn.com/articles/murmur.html)

**\===
\[erq\]**