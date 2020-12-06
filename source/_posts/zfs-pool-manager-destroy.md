---
title: 'ZFS文件系统介绍 - 存储池(2):管理和销毁存储池'
tags:
  - Debian
  - ZFS
id: '2264'
categories:
  - - GNU/Linux
date: 2012-05-14 14:15:03
---

管理和销毁存储池
<!-- more -->
**管理存储池中的设备**

**1、添加删除设备**

通过添加新的顶层虚拟设备vdev,可以向存储池中动态添加、删除磁盘。此磁盘空间立即可供池中的所有数据集使用。使用zpool add命令向池中添加新虚拟设备,使用zpool remove命令从池中删除虚拟设备。zpool remove命令仅支持删除热备件、日志设备和高速缓存设备,非冗余设备和RAID-Z设备无法从池中删除,也就是在没有足够的冗余,无法保证池中数据完整的情况下,无法从池中删除设备。

新添加的普通顶层虚拟设备,即非日志设备,非高速缓存设备,非热备设备,与池中现有顶层虚拟设备进行动态条带。

普通条带池 # zpool create reservoir /dev/vdb /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
          vdc1      ONLINE       0     0     0  
  
errors: No known data errors  
# zpool add reservoir /dev/vdd  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
          vdc1      ONLINE       0     0     0  
          vdd1      ONLINE       0     0     0  
  
errors: No known data errors  
# zpool remove reservoir /dev/vdd  
cannot remove /dev/vdd: only inactive hot spares, cache, top-level, or log devices can be removed 

一个更复杂的例子,当然没人会用这样的池子 # zpool create reservoir /dev/vdb  
# zpool add reservoir mirror /dev/vdc /dev/vdd  
invalid vdev specification  
use '-f' to override the following errors:  
mismatched replication level: pool uses disk and new vdev is mirror  
# zpool add -f reservoir mirror /dev/vdc /dev/vdd  
# zpool add reservoir raidz /dev/vde /dev/vdf  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
          mirror-1  ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
            vdd1    ONLINE       0     0     0  
          raidz1-2  ONLINE       0     0     0  
            vde1    ONLINE       0     0     0  
            vdf1    ONLINE       0     0     0  
  
errors: No known data errors 

添加删除日志设备 # zpool add reservoir log /dev/vdc  
# zpool status  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
        logs  
          vdc1      ONLINE       0     0     0  
  
errors: No known data errors  
# zpool remove reservoir /dev/vdc  
# zpool status  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
  
errors: No known data errors 

添加删除高速缓存设备 # zpool add reservoir cache /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
        cache  
          vdc1      ONLINE       0     0     0  
  
errors: No known data errors  
# zpool remove reservoir /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
  
errors: No known data errors 

添加删除热备件 # zpool add reservoir spare /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
        spares  
          vdc1      AVAIL     
  
errors: No known data errors  
# zpool remove reservoir /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
  
errors: No known data errors 

**2、附加分离设备**

附加分离设备与添加删除设备的根本区别在于,附加分离设备是在虚拟设备内附加或分离磁盘,一般是在顶层虚拟设备内,而添加和删除设备是在池子中添加或删除顶层虚拟设备。

可以通过附加磁盘使普通池成为冗余镜像池 # zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
  
errors: No known data errors  
# zpool attach reservoir /dev/vdb /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: resilvered 84K in 0h0m with 0 errors on Wed May 16 10:30:48 2012  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
  
errors: No known data errors  
# zpool detach reservoir /dev/vdc  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: resilvered 84K in 0h0m with 0 errors on Wed May 16 10:30:48 2012  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          vdb1      ONLINE       0     0     0  
  
errors: No known data errors 

附加磁盘时通过指定其前导磁盘来确定新附加磁盘的位置。此例的实质就是在唯一的顶层虚拟设备内,在原有磁盘设备/dev/vdb之后附加了另外一个磁盘/dev/vdc,二者位于同一个顶层设备内,成为镜像关系。

还可以通过附加磁盘使双路镜像成为多路镜像,或者相反,但不能向现有raidz(1,2,3)配置中附加磁盘。 # zpool status  
  pool: reservoir  
 state: ONLINE  
 scan: none requested  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
  
errors: No known data errors  
# zpool attach reservoir /dev/vdb /dev/vdd  
# zpool status reservoir  
  pool: reservoir  
 state: ONLINE  
 scan: resilvered 84K in 0h0m with 0 errors on Wed May 16 10:43:31 2012  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
            vdd1    ONLINE       0     0     0  
  
errors: No known data errors  
# zpool detach reservoir /dev/vdd  
# zpool status  
  pool: reservoir  
 state: ONLINE  
 scan: resilvered 84K in 0h0m with 0 errors on Wed May 16 10:43:31 2012  
config:  
  
        NAME        STATE     READ WRITE CKSUM  
        reservoir   ONLINE       0     0     0  
          mirror-0  ONLINE       0     0     0  
            vdb1    ONLINE       0     0     0  
            vdc1    ONLINE       0     0     0  
  
errors: No known data errors 

**3、替换设备**

如果冗余池中的设备出现故障,或者对所有池来说只是用更大容量的磁盘替换池中原有的小容量磁盘,可以使用zpool replace命令。
如果替换涉及到的新旧设备位于同一个物理位置,则只需标识出这个位置的物理设备即可,如果新旧磁盘设备位于不同的物理位置则需要分别标识出旧设备和新设备的物理位置。用大容量的磁盘替换非冗余池中的小容量磁盘设备,则新旧设备必须同时在线,同步完成后才可以移除旧设备。

**替换镜像池中的故障设备**

如果冗余池中的故障磁盘并未离线，先用以下命令使其离线
```js
# zpool offline reservoir /dev/vdc
```
然后将故障磁盘抽出,将新的磁盘插入，然后
```js
# zpool replace reservoir /dev/vdc
```
最后使新磁盘在线
```js
# zpool online reservoir /dev/vdc
```
**用大容量磁盘替换小容量磁盘来扩展镜像冗余池**

假设镜像池reservoir由/dev/vdb和/dev/vdc组成,现由更大容量的/dev/vdd和/dev/vde来替换池中的磁盘
```js
# zpool replace reservoir /dev/vdb /dev/vdd
# zpool replace reservoir /dev/vdd /dev/vde
```
最后需要设置autoexpand属性为on池子的容量才可以扩展到新设备的容量
```js
# zpool set autoexpand=on reservoir
```
但当前zfsonlinux的实现好像还是有点儿问题,设置了此属性,容量仍然无法扩展,虽然设备已经替换过了。
注：需要执行zpool onlie命令来扩展空间，每个设备上都要执行：
```js
$ sudo zpool online -e reservoir <设备id>
```
设备id获取:
```js
$ zpool status -vg reservoir
```

**销毁存储池**

销毁存储池很简单,但一定要三思。
```js
# zpool destroy reservoir
```
此命令会销毁池,即使池中包含挂载的数据集也是如此。