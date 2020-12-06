---
title: 小内存VPS之MySQL配置优化
tags: []
id: '1571'
categories:
  - - GNU/Linux
date: 2011-07-02 11:12:05
---

MySQL是优秀的小型开源数据库,然而默认配置的MySQL对于小内存VPS来说仍然资源占用过多,因此优化配置,减少资源占用是有必要的。
<!-- more -->
debian squeeze系统上mysql的主配置文件为/etc/mysql/my.cnf,优化之后,资源占用有明显的下降

**参数优化说明**

skip-innodb #不使用InnoDB数据库引擎,虽然InnoDB很强大,但对于小内存VPS就没啥必要使用了,关闭InnoDB引擎后,内存占用有明显的下降

skip-external-locking #不使用外部锁，也就是操作系统提供的锁，这个选项现在默认是打开的

key_buffer #与key_buffer_size是同一个参数,不过后者已经不推荐使用了,此参数指定索引缓冲区的大小，对于小内存VPS,16M的默认值有些大了,1M就差不多了

query_cache_limit #不缓存大于此值的结果,设置为256K

query_cache_size #用于缓存查询结果的内存大小,必须是1024的倍数,设置为query_cache_limit的16倍，即4M

sort_buffer_size #排序缓存
read_buffer_size #读缓存
read_rnd_buffer_size #缓存通过关键字排序的行
#这三个参数可以采用默认值，也可以参考/usr/share/doc/mysql-server-5.1/examples/my-small.cnf来设置