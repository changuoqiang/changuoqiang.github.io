---
title: linux挂载windows共享目录/磁盘
tags:
  - Debian
id: '2800'
categories:
  - - GNU/Linux
date: 2013-01-28 15:08:59
---

linux系统可以mount挂载windows系统共享出来的文件夹或磁盘
<!-- more -->
windows使用SMB(Server Message Block)/CIFS(Common Internet File System)协议来共享资源,CIFS是SMB的后继升级版本。linux系统对SMB/CIFS提供完整的支持,包括文件共享和打印共享。

smbclient命令行可以访问windows文件共享,但mount挂载SMB/CIFS共享文件资源使用起来更方便。当前linux内核已经移除了smbfs模块,仅使用cifs内核模块来访问SMB/CIFS共享。

安装mount.cifs
```js
# apt-get install cifs-utils
```
挂载windows共享目录
```js
#mount -t cifs -o guest,file_mode=0777,dir_mode=0777 //windows_server/sharename /mnt/winshare
```
或者
```js
# mount.cifs -o guest,file_mode=0777,dir_mode=0777 //windows_server/sharename /mnt/weinshare
```

使用guest选项则使用guest用户访问共享并且不会提示输入密码，也可以在选项中指定访问共享使用的用户名username和密码password,比如
```js
#mount -t cifs -o username=<username>,password=<password>,file_mode=0777,dir_mode=0777 
　　　　//windows_server/sharename /mnt/winshare
```
其他选项详见man mount.cifs

也可以写入/etc/fstab开机自动挂载SMB/CIFS共享
```js
//windows_server/sharename /mnt/winshare cifs guest,file_mode=0777,dir_mode=0777 0 0
```

**Update(11/15/2016):**

某天开始，-o guest选项挂载时，提示错误：
```js
mount error(13): Permission denied
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
```

选项更改为-o user=guest,password=null问题解决。
或者
```js
# mount -t cifs -o password,file_mode=0777,dir_mode=0777 //windows_server/sharename /mnt/weinshare
```

**Update(10/04/2019):**
当前稳定版debian buster挂载windows 2003 R2的共享文件系统时又出现错误了：
```js
No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
CIFS VFS: cifs_mount failed w/return code = -512
```
是说，cifs挂装文件系统时，默认开始使用更安全的SMB2.1或者更新的协议版本，如果要挂装比较旧的、不支持新协议的服务器上的cifs文件系统，需要指定协议版本vers=1.0，因此新的命令行：
```js
$ sudo mount.cifs -o user=guest,password=null,file_mode=0777,dir_mode=0777,vers=1.0 //windows_server/sharename /mnt/winshare/
```
新的/etc/fstab
```js
//windows_server/sharename /mnt/winshare cifs user=guest,password=null,file_mode=0777,dir_mode=0777,vers=1.0 0 0
```