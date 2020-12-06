---
title: rman远程备份
tags:
  - Debian
  - Oracle
id: '2103'
categories:
  - - Database
date: 2012-04-17 09:18:28
---

rman自身是不支持远程备份的,它只支持备份到目标服务器可以直接存取的路径上。
<!-- more -->
**rman备份环境**

恢复目录系统环境为debian wheezy amd64 + oracle 10g 10.2.0.4 64bits,目标数据库系统环境为windows 2003 r2 sp2 x64 + oracle 10g 10.2.0.4 64bits。恢复目录所在服务器mount了一个共享大容量光纤SAS盘阵。目标数据库的备份数据要远程备份到盘阵,一个安全性,一个是容量问题。

**有这么几种方式可以实现此目标。**

NFS

首先想到NFS,NFS在unix/linux世界是使用十分广泛的共享文件系统,安装设置也很简单。windows平台有个SFU(Services for Unix)提供NFS客户端和服务器功能,可以通过安装此包设置为客户端来存取远端NFS服务器。但经测试表明32bits windows可以正常存取远端NFS服务器,但64bits windows无法安装SFU。而且SFU可能是已经被放弃的软件包。所以只好放弃此种方式。

FTP

linux提供FTP服务,windows端通过某些软件将FTP路径虚拟为一个本地磁盘供RMAN存取。虽然可行,但这方面软件成熟和让人放心的尚未找到,没有经过太多的实践检验。

SAMBA/CIFS

最后才考虑samba,因为这玩意儿虽然成熟,但安全问题也是多多。不过没办法,最终选择此方案。

**debian安装配置samba服务**

#apt-get install samba

配置文件/etc/samba/smb.conf内容

\[global\]
workgroup = WORKGROUP
guest account = nobody
security = share

\[rman\]
comment = rman backup destination
path = /mnt/data/rman_bak
guest ok = yes
writable = yes
share modes = yes
hosts allow = 127.0.0.1 192.168.0.0/24

将printer相关参数全部注释掉,其他参数默认即可。
guest账户映射到nobody用户,为rman远程备份设置共享名rman,只允许部分网段访问此共享,也可以限制到具体的哪台主机,比如127.0.0.1。

修改共享目录的属主和权限
#chown nobody:nogroup /mnt/data/rman_bak
#chmod 777 /mnt/data/rman_bak

然后rman备份时直接将备份片路径设置为\\\\ip\\rman就可以了。在windows中做网络驱动器映射时,rman会提示无法创建备份片文件,不知为何？
 **===
\[erq\]**