---
title: cassandra跨数据中心、多网络接口部署
tags:
  - cassandra
  - Debian
id: '9286'
categories:
  - - GNU/Linux
date: 2020-06-14 12:36:06
---


<!-- more -->
cassandra集群以前运行于本地机房，现在需要扩展到云端，云主机添加为集群的新数据中心。因为并不是公有云，所有没有启动SSL认证和加密。

本地机房与云机房通过专线连接，并且本地只有两个互联ip地址可用。本地机房原集群内节点只使用私有网络地址，无法被云端访问。云端主机使用私有地址，云平台将私有地址映射到专线可以访问的“公有地址”，这里并不是真正的“公有地址”，仍然是一个大的私有网络，不过本地机房和云机房通过这些地址可以互访，所有这里也叫做“公有地址”

因此集群的本地机房节点通过NAT映射，将私有地址的7000和9042端口映射到公有地址，从而可以被云主机访问，同时做了端口回流，保证本地机房其他机器也可以通过公有地址访问节点。
如果不做或不能做端口回流，应该也可以使用iptables/nftables在集群内节点以及需要访问集群的客户机器上添加nat转换规则,从公有ip转换到对应的私有ip，这个没试。

这样本地机房和云机房的节点都有私有地址和映射后的公有地址，cassandra集群节点需要使用公有地址进行互访，但cassandra都无法直接监听公有地址。这需要配置cassandra.yaml,设置listen_address和rpc_address为私有地址，设置broadcast_address和broadcast_rpc_address为公有ip地址，但是listen_on_broadcast_address设置为false，因为各个节点并不能在公有ip上监听。这样当跨数据中心时使用公有ip通讯，但在本地网络内部可以使用私有网络。

cassandra-rackdc.properties配置文件可以打开prefer_local选项，这样可以优先使用本地网络，降低网络延迟。

配置实例：
```js
listen_address: 192.168.136.250
broadcast_address: 59.206.31.152
rpc_address: 192.168.136.250
broadcast_rpc_address: 59.206.31.152

seed_provider:
 # Addresses of hosts that are deemed contact points. 
 # Cassandra nodes use this list of hosts to find each other and learn
 # the topology of the ring. You must change this if you are running
 # multiple nodes!
 - class_name: org.apache.cassandra.locator.SimpleSeedProvider
 parameters:
 # seeds is actually a comma-delimited list of addresses.
 # Ex: "<ip1>,<ip2>,<ip3>"
 - seeds: "59.206.31.152,10.160.4.196,10.160.4.197"
```

这样本地数据中心和云数据中心就可以通过公有ip相互通讯了。
**备注：**rpc并不是必须的，只使用cql是可行的。


References:
\[1\][Using multiple network interfaces](https://docs.datastax.com/en/cassandra-oss/3.0/cassandra/configuration/configMultiNetworks.html)