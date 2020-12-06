---
title: debian NFS服务配置
tags:
  - Debian
id: '7533'
categories:
  - - GNU/Linux
date: 2016-08-31 16:45:30
---


<!-- more -->
**服务器安装配置**

```js
# apt install nfs-kernel-server
```

编辑/etc/exports文件，添加：
```js
/srv/homes 10.100.0.0/24(rw) 192.168.0.0/24(rw)
```

**客户端安装配置**

```js
# apt install nfs-common
```

客户端查看服务器资源：
```js
# showmount -e 10.100.0.30
Export list for 10.100.0.30:
/srv/homes 10.100.0.0/24
```

如果出现错误提示：
```js
rpc mount export: RPC: Authentication error; why = Failed (unspecified error)
```
可以查看nfs服务器/etc/hosts.allow和/etc/hosts.deny的配置，是否允许客户机访问nfs资源，可以简单粗暴的允许所有主机访问，在/etc/hosts.allow最末尾添加ALL:ALL

客户端挂载服务器共享资源：
```js
# mount 10.100.0.30:/srv/homes /mnt/share
```

自动挂载编辑/etc/fstab：
```js
# nfs
10.100.0.30:/svr/homes /mnt/share nfs defaults 0 0
```

**\===
\[erq\]**