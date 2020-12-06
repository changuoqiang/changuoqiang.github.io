---
title: kvm客户机共享主机目录
tags:
  - KVM
id: '7207'
categories:
  - - GNU/Linux
date: 2016-04-25 10:28:06
---


<!-- more -->
主机通过virtio上的9p文件系统以及文件系统设备，可以将主机上的文件系统导出给客户机来挂载使用

v9fs是plan 9 9p远程文件系统协议的实现

**主机配置**

在客户机启动命令上新添加fsdev和device选项
```js
-fsdev local,security_model=passthrough,id=fsdev0,path=/mnt/share 
-device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare
```
这样导出了主机的/mnt/share目录供客户机来存取

**客户机配置**

客户机需要在内核中开启9P文件系统相关选项，可以这样查看:
```js
$ cat /boot/config-$(uname -r) grep 9P
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y
CONFIG_9P_FS_SECURITY=y
```

可以看到9P配置成了内核模块的形式，然后就可以挂载主机的目录来使用了：
```js
# mount -t 9p -o trans=virtio\[,version=9p2000.L\] hostshare /mnt/point
```

hostshare就是主机导出的挂载点的名称，此处将其挂载到客户机的/mnt/point。
version选项是可选的。


References:
\[1\][Example Sharing Host files with the Guest](http://www.linux-kvm.org/page/9p_virtio)
\[2\][Documentation/9psetup](http://wiki.qemu.org/Documentation/9psetup)
\[3\][v9fs: Plan 9 Resource Sharing for Linux](https://www.kernel.org/doc/Documentation/filesystems/9p.txt)

**\===
\[erq\]**