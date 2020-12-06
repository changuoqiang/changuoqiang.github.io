---
title: 更改cassandra数据存储目录
tags:
  - cassandra
id: '6868'
categories:
  - - Database
date: 2015-11-06 23:06:41
---


<!-- more -->
debian使用apache源安装完成的cassandra节点，默认数据存储在/var/lib/cassandra/data目录下。

为了优化性能，可能将data与commitlog分别存储到不同的磁盘上。

比如，更改数据目录到/mnt/data/cassandra目录下，这是挂装的一个不同的磁盘驱动器。

首先停掉cassandra
```js
$ sudo service cassandra stop
```

然后修改/etc/cassandra/cassandra.yaml
```js
data_file_directories:
 - /mnt/data/cassandra
```

将/var/lib/cassandra/data目录下的所有东西全部拷贝或移动到/mnt/data/cassandra目录下

```js
$ sudo -u cassandra cp -r /var/lib/cassandra/data/* /mnt/data/cassandra
```
或
```js
$ sudo -u cassandra mv /var/lib/cassandra/data /mnt/data/cassandra
```

最后重新启动cassandra
```js
$ sudo service cassandra start
```

**\===
\[erq\]**