---
title: debian启用巨页内存
tags:
  - Debian
id: '7452'
categories:
  - - GNU/Linux
date: 2016-07-25 15:50:25
---


<!-- more -->
内存是分页管理的,传统上每页内存是4K大小,当系统内存很大时,页表项剧增,查找内存页表增加了系统的负担,因此出现了巨页.当前amd64架构支持2M内存页和1G内存页,默认巨页大小是2M.

**创建巨页内存组**

```js
# groupadd hugetlbfs
# getent group hugetlbfs
hugetlbfs:x:1001:
# adduser postgres hugetlbfs
```

把postgres用户加入巨页内存组,从而使postgresql可以分配巨页内存

**编辑/etc/sysctl.conf**

```js
vm.nr_hugepages = 13824 # 巨页内存池大小,系统保留多少页巨页内存,这里保留了13824*2M=27G
vm.vm.hugetlb_shm_group = 1001 #巨页内存所属组
```

**创建巨页内存挂载点**

```js
# mkdir /hugepages
```

**编辑/etc/fstab自动挂载巨页内存文件系统**

```js
hugetlbfs /hugepages hugetlbfs mode=1770,gid=1001 0 0
```

**配置生效**

```js
# sysctl -p
```

如果内存碎片化太严重而无法为巨页池保留足够的内存,可以重新启动系统,或者先试图释放系统缓存再重试sysctl命令
```js
# sync ; echo 3 > /proc/sys/vm/drop_caches
# sysctl -p
```

查看巨页内存使用情况:
```js
$ grep 'Huge' /proc/meminfo 
AnonHugePages: 0 kB
HugePages_Total: 13824
HugePages_Free: 13710
HugePages_Rsvd: 4096
HugePages_Surp: 0
Hugepagesize: 2048 kB
```

References:
\[1\][Hugepages](https://wiki.debian.org/Hugepages)

**\===
\[erq\]**