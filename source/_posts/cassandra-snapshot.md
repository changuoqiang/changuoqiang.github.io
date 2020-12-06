---
title: Cassandra快照
tags:
  - cassandra
id: '7094'
categories:
  - - Database
date: 2015-12-23 15:48:53
---


<!-- more -->
**概念**

cassandra通过为数据目录下所有的SSTable磁盘文件制作快照来备份数据。当系统在线时，可以为所有的keyspace、单独的keyspace或者单独的表制作快照。如果使用并行ssh工具，比如pssh,可以为整个集群制作快照。

虽然制作快照时并不能保证节点与其复制节点保持一致，但当快照恢复后，依靠cassandra的一致性机制，最终还是会达到一致状态。

快照支持增量备份机制。

Cassandra通过硬链接(需要JNA,当前版本默认打开JNA)来制作快照，因此成本还是比较低的。

**查看快照**

```js
$ nodetool listsnapshots

Snapshot Details: 
Snapshot name Keyspace name Column family name True size Size on disk 
1541832995400 reis image_increment 0 bytes 13 bytes 
1541832995400 reis image 1.23 GB 1.73 TB 

Total TrueDiskSpaceUsed: 1.23 GB
```

**制作快照**

制作快照时会先将内存数据刷写到硬盘，然后硬链接SSTable文件到备份目录。快照会创建到data_directory_location/keyspace_name/table_name-UUID/
snapshots/snapshot_name/目录下,里面有许多的.db文件记录了快照制作时的数据。
快照制作完成后，一般应将其拷贝到另外的存储空间单独存放。

使用以下命令来制作快照:
```js
$ nodetool snapshot foo
Requested creating snapshot(s) for \[foo\] with snapshot name \[1450876735125\]
Snapshot directory: 1450876735125
```

foo这里是keyspace的名字，如果不指定keyspace则默认制作所有keyspaces的快照。

应为只是创建硬链接，因此快照速度飞快，无论节点有多大的容量，但是拷贝快照到另外的机器另当别论。

可以看到table_name-UUID/snapshots目录下多了一个以快照名命名的目录1450876735125，其内容即为方才制作的快照。

之后将快照归档，然后删除掉快照目录即可。

**删除快照**

快照会阻止删除已经无用的数据文件，因此保留快照会占用额外的存储空间。

删除所有的快照：
```js
$ nodetool clearsnapshot
Requested clearing snapshot(s) for \[all keyspaces\]
```
或者单独删除某个keyspace的所有快照:
```js
$ nodetool clearsnapshot foo
Requested clearing snapshot(s) for \[foo\]
```

**增量备份**

Cassandra支持增量备份，但默认配置没有打开。需要在cassanda.yaml文件中将incremental_backups设置为true以打开增量备份。
打开增量备份后，Cassandra会将每一个写入磁盘的SSTable制作一个硬链接写入data_directory_location/keyspace_name/table_name-UUID/backups目录下。

这样快照加上增量备份就可以提供一个可靠活的备份机制。

但是有一点儿需要注意，增量备份目录/backups下的文件Cassandra并不会自动删除，移除这些硬链接是用户的责任。因此应该在制作快照之前删除掉backups目录下的所有文件。

**其实,增量备份并不依赖于快照。**

**快照恢复**

恢复快照，需要表的所有快照文件以及可能有的增量备份文件。
在恢复快照之前应该先truncate表。如果在删除某些数据前制作快照，然后在删除后没有truncate表的情况下恢复数据，那些删除的数据并不会恢复回来。因为cassandra删除数据时并不会真正删除原始的数据，而是生成一个带有墓碑标志的一样的行来标记删除了某行，原始行和标记删除行存在于不同的SSTable中。因此恢复原始的数据，并不能去掉数据的删除标记，从来数据看起来仍然是被删除掉的。

快照恢复时需要表的schema已经存在，因此快照恢复之前需要重建表的schema。

快照恢复有多种方法：

*   使用sstableloader
*   拷贝所有的快照文件及增量备份文件到data_directory_location/keyspace/table_name-UUID目录下，然后通过JConsole调用column family MBean 中的JMX方法loadNewSSTables()，或者调用nodetool refresh命令。
*   重启节点的方式
如果恢复一个节点，需要关闭该节点，如果要恢复整个集群，则需要关闭集群内所有的节点。

1.  关闭节点
2.  删除commitlog目录下的所有文件
debian包安装方式，commitlog所在目录为
```js
/var/lib/cassandra/commitlog
```
3.  删除*.db文件
删除data_directory_location/keyspace_name/table_name-UUID目录下的所有*.db文件
4.  拷贝最新快照及增量备份文件
将需要恢复的快照文件拷贝到data_directory/keyspace_name/table_name-UUID目录
5.  拷贝增量备份文件
如果有增量备份文件，同样拷贝到data_directory/keyspace_name/table_name-UUID目录
6.  重启节点
7.  运行nodetool repair

**快照恢复到新集群**

假设需要从三个节点的集群(256 tokens)拷贝SSTable快照数据文件，然后将其恢复到一个新创建的三节点集群(256 tokens)上，新集群节点的token范围必须手动指定以与原始集群相匹配。

恢复过程：

1.  获取节点tokens
从原始集群中的每个节点上执行如下命令，获取其负责的tokens
```js
$ nodetool ring grep ip_address_of_node awk '{print $NF ","}' xargs
```
2.  配置新集群节点
新集群每个节点的cassandra.ymal文件中，initial_token参数分别设置为上一步获取的tokens。新集群节点要使用与旧集群节点相同的num_tokens参数，同时新旧集群节点的其他参数也要相匹配。
3.  清除新集群节点的system数据
新集群每个节点执行:
```js
$ sudo rm -rf /var/lib/cassandra/data/system/*
```
4.  拷贝节点数据
将旧集群节点的快照数据拷贝到新集群节点的相同的数据目录下,三个节点分别一一对应进行。
5.  启动新集群
依次分别启动新集群的节点。

References:
\[1\][cassandra 2.2 document](https://docs.datastax.com/en/archived/cassandra/2.2/cassandra/tools/toolsSnapShot.html)
\[2\][Restoring a snapshot into a new cluster](https://docs.datastax.com/en/ddac/doc/datastax_enterprise/operations/opsSnapshotRestoreNewCluster.html)

 **===
\[erq\]**