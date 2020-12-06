---
title: sshfs
tags:
  - Debian
id: '9307'
categories:
  - - GNU/Linux
date: 2020-06-26 23:23:06
---


<!-- more -->
sshfs可以通过ssh和sftp协议来安全的在本地挂载远程文件系统，比NFS更方便的是无需更改防火墙设置，只要能使用ssh访问远程主机就可以了。

sshfs使用fuse在用户空间挂载远程文件系统，debian系统直接安装sshfs包，为了方便挂载，最好配置使用公私钥对来访问远程ssh主机，特别是fstab文件不支持ssh的密码访问方式。

挂载远程文件系统：
```js
$ sshfs user@host:/mnt/data/reis_dump/ /mnt/hwy06_reisdb_bak/ -o reconnect
```
也支持直接使用ssh别名
```js
$ sshfs hwy-reisdb-3:/mnt/data/reis_dump/ /mnt/hwy06_reisdb_bak/ -o reconnect
```

具体的sshfs选项参见man

注意：
ssh长时间连接会超时，导致出现类似错误提示：
```js
client_loop: send disconnect: Broken pipe
```
可以在ssh服务器/etc/ssh/sshd_config中打开客户端心跳探测:
```js
ClientAliveInterval 30
ClientAliveCountMax 3
```
30秒发送一个心跳探测，超过3次没有回应断开连接。

References:
\[1\][SSHFS: Mounting a remote file system over SSH](https://www.redhat.com/sysadmin/sshfs)
\[2\][SSHFS](https://wiki.archlinux.org/index.php/SSHFS_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))