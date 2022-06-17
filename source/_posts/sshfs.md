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
$ sshfs user@host:/mnt/data/reis_dump/ /mnt/hwy06_reisdb_bak/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
```
也支持直接使用ssh别名
```js
$ sshfs hwy-reisdb-3:/mnt/data/reis_dump/ /mnt/hwy06_reisdb_bak/ -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3
```
支持断线重连和心跳保持
具体的sshfs选项参见man

还有一个fuse文件系统挂载选项allow_other影响挂载的sshfs文件系统访问权限，如果允许除挂载用户之外的其他用户访问文件系统，需要指定此选项，并且需要修改fuse配置文件/etc/fuse.conf，打开user_allow_other选项
```ini
# Allow non-root users to specify the allow_other or allow_root mount options.
user_allow_other
```

还可以写入fstab，开机可以自动挂载sshfs
/etc/fstab
```
user@host:/var/www/ /var/www/ fuse.sshfs defaults,_netdev,allow_other,follow_symlinks,identityfile=/home/user/.ssh/id_rsa,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 0 0
```
在这里，_netdev挂载选项指定挂载sshfs需要有网络支持，follow_symlinks是sshfs的选项，支持符号链接，identityfile选项是ssh的选项，指定登录凭证，也可以通过.ssh/config配置别名来指定登录选项。

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