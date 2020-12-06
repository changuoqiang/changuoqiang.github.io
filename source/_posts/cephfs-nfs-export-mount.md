---
title: CephFS文件系统NFS导出和挂载
tags:
  - Debian
id: '9014'
categories:
  - - GNU/Linux
date: 2019-11-05 13:53:36
---


<!-- more -->
**一、使用nfs-ganesha**

需要先创建cephfs,参考[使用CephFS文件系统](https://openwares.net/2019/10/31/cephfs-using/)

**安装**
在ceph集群的某个节点上安装nfs-ganesha-ceph
```js
$ sudo apt install nfs-ganesha-ceph
```
如果启动服务时出错:
```js
Failed to restart nfs-ganesha.service: The name org.freedesktop.PolicyKit1 was not provided by any .service files
```
安装policykit-1包
```js
sudo apt install policykit-1
```

**配置**
/etc/ganesha/ganesha.conf
```js
NFS_CORE_PARAM
{
Enable_NLM = false;

Enable_RQUOTA = false;

Protocols = 4;
}

NFSv4
{
Delegations = active;;

Minor_Versions = 1,2;
}

CACHEINODE {
Dir_Chunk = 0;

NParts = 1;
Cache_Size = 1;
}

EXPORT
{
# Unique export ID number for this export
Export_ID=100;

# We're only interested in NFSv4 in this configuration
Protocols = 4;

# NFSv4 does not allow UDP transport
Transports = TCP;

Path = /;
 Pseudo = /cephfs/;

# We want to be able to read and write
Access_Type = RW;

# Time out attribute cache entries immediately
Attr_Expiration_Time = 0;

Delegations = RW;

Squash = no_root_squash;

FSAL {
# FSAL_CEPH export
Name = CEPH;
}
}

# Config block for FSAL_CEPH
CEPH
{
# Path to a ceph.conf file for this cluster.
# Ceph_Conf = /etc/ceph/ceph.conf;

# User file-creation mask. These bits will be masked off from the unix
# permissions on newly-created inodes.
# umask = 0;
}
```
重启nfs-ganesha服务
```js
$ sudo systemctl restart nfs-ganesha
```

**客户端挂载**
```js
$ sudo mount -t nfs4 -o nfsvers=4.2,rw 192.168.3.8:/ /mnt/mycephfs
```
或者
```js
$ sudo mount -t nfs4 -o nfsvers=4.2,rw 192.168.3.8:/cephfs /mnt/mycephfs
```
/etc/fstab挂载项:
```js
192.168.3.8:/ /mnt/mycephfs nfs4 nfsvers=4.2 0 0
```

**二、使用kernel driver/ceph-fuse和nfsd**

Ceph 提供了 kernel driver/ceph-fuse 来挂载和访问 CephFS。在 NFS 服务器上通过 kernel driver/ceph-fuse 挂载 CephFS 后，我们可以通过 nfsd 将其发布出去。


References:
\[1\][NFS](https://docs.ceph.com/docs/mimic/cephfs/nfs/)
\[2\][将 Ceph 文件系统 CephFS 挂载为 NFS](https://amito.me/2019/Mount-CephFS-over-NFS/)
\[3\][nfsidmap](https://github.com/phdeniel/nfs-ganesha/wiki/nfsidmap)
\[4\][Deploying an Active/Active NFS Cluster over CephFS](https://jtlayton.wordpress.com/2018/12/10/deploying-an-active-active-nfs-cluster-over-cephfs/)