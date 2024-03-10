---
title: increase lxd storage pool
date: 2024-03-10 22:12:28
tags:
---

lxd 存储池扩容
<!-- more -->

lxd 5.13版本之后，添加了存储池扩容支持
```js
lxc storage set <pool_name> size=<new_size>
```
比如为default存储器扩容
```js
lxc storage set default size=400GB
```

这只适用于lxd管理的loop-back存储池，而且只能增大存储池，而不能缩小它。（This will only work for loop-backed storage pools that are managed by LXD. You can only grow the pool (increase its size), not shrink it.）

5.13以前的版本可以这样扩容：
```js
sudo truncate -c -s +100G /var/snap/lxd/common/lxd/disks/default.img
sudo btrfs filesystem resize max /var/snap/lxd/common/mntns/var/snap/lxd/common/lxd/storage-pools/default
Resize '/var/snap/lxd/common/mntns/var/snap/lxd/common/lxd/storage-pools/default' of 'max'
```

References:

[1][Resize a storage pool](https://documentation.ubuntu.com/lxd/en/latest/howto/storage_pools/)

[2][Resize underlying btrfs storage](https://discuss.linuxcontainers.org/t/resize-underlying-btrfs-storage/3023/1)

[3][Increase the LXD/LXC Btrfs loop file storage pool size](https://superuser.com/questions/1483551/increase-the-lxd-lxc-btrfs-loop-file-storage-pool-size)