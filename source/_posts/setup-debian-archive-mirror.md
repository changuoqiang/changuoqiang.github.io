---
title: 搭建debian源镜像服务器
tags:
  - Debian
id: '2810'
categories:
  - - GNU/Linux
date: 2013-01-29 12:46:24
---

内网的linux服务器越来越多,有必要搭建一个内网debian源镜像服务器
<!-- more -->
debian官方提供了建设源镜像的脚本[ftpsync](http://ftp-master.debian.org/ftpsync.tar.gz),而且有[详细的源镜像设置说明](http://www.debian.org/mirror/ftpmirror)

**准备工作**

ftpsync使用rsync程序进行源镜像

# apt-get install rsync

从官方下载ftpsync脚本
# wget http://ftp-master.debian.org/ftpsync.tar.gz

**配置ftpsync**

ftpsync使用环境变量BASEDIR来定位程序文件、配置文件和日志文件等的存放路径，BASEDIR默认取值${HOME},可以将ftpsync放置到用户主目录下

在用户主目录下新建bin,etc,log目录，解压ftpsync,

$ tar zxvf ftpsync.tar.gz
$ cp distrib/bin/ftpsync ~/bin
$ cp distrib/etc/ftpsync.conf.sample ~/etc/ftpsync.conf
$ cp distrib/etc/common ~/etc/common

建立存放镜像文件的单独目录，各种架构需要的[磁盘空间](http://www.debian.org/mirror/size)，当前镜像all,amd64和source总共约需要190G硬盘空间。
可以在任何位置存放镜像，只要运行ftpsync的用户对目录有读写权限即可。此处使用/srv/mirrors/debian存放镜像文件，将目录的所有者和所属组设置为当前用户。

最后打开~/etc/ftpsync.conf,修改以下内容：

TO="/srv/mirrors/debian/" ##镜像源存放位置
RSYNC_HOST="ftp.cn.debian.org" ##镜像自哪个外部源,debian中国官方源镜像是最佳选择，当然ftp.tw.debian.org,ftp.kr.debian.org和ftp.jp.debian.org速度也很快，[中国官方源镜像](http://lug.ustc.edu.cn/blog/2011/05/ftp-cn-debian-org-comes/)由中国科技大学维护
ARCH_EXCLUDE="alpha arm armel armhf hppa hurd-i386 i386 ia64 kfreebsd-amd64 kfreebsd-i386 m68k mipsel mips powerpc s390 s390x sh sparc source" ##排除的架构，此处只保留amd64源，source源也排除，只镜像必要的，尽量节省硬盘空间。

**注**：当前脚本排除source镜像会提示错误：
Unexpected remote arg: ftp.cd.debian.org::debian
rsync error: syntax or usage error (code 1) at main.c(1232) \[sender=3.0.9\]
不要排除source可解决此错误。

**推送模式镜像服务器**

当档案库有变化时，上游源镜像服务器会主动向下游镜像服务器推送同步通知,然后下游源镜像服务器就可以及时的更新自己的档案库，这就是[推模式镜像](http://www.debian.org/mirror/push_mirroring)。debian的主服务器与下游镜像服务器之间即采用此种模式。

此种模式需要下游镜像服务器配置ssh服务，上游镜像服务器使用ssh来通知下游服务器。可以使用一个普通用户来接受通知，将上游镜像服务器的公钥保存在~/.ssh/authorized_keys文件中，并且在此文件中添加如下语句以限制上游镜像服务器的权限

no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty,command="~/bin/ftpsync",from="ip_address"

此处ip_address即上游镜像服务器的IP地址。
而且上游upstream镜像服务器还可以通过用户名/密码来授权谁可以向某些下游镜像服务器进行推送，并且这些用户名/密码是与系统隔离的，并不是使用/etc/passwd,进一步增强安全性。

使用推送模式同步需要将下游downstream服务器地址，ssh端口和使用的用户告知上游源镜像服务器维护者

对于企业内部的源镜像服务器，没有必要使用推模式，只要在空闲时段定时与上游源镜像服务器同步即可。

**让ftpsync自动运行** 

使用cron让ftpsync定时自动运行，/etc/cron.d/目录下添加文件ftpsync,内容如下：

SHELL=/bin/bash
PATH=/home/username/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#minute hour day_of_month month day_of_week user command
01 * **username ftpsync

username为运行ftpsync脚本的用户,每天凌晨1点自动运行ftpsync脚本与上游源镜像服务器同步

**源镜像http配置**

内网其他用户需要通过http或者ftp协议从本地源镜像服务器更新系统，此处使用apache来提供http方式的源镜像服务

# apt-get install apache2

/etc/apache2/sites-available/目录下添加文件debian_mirror,内容如下：

 1 <VirtualHost *:80>  
 2   
 3     DocumentRoot /srv/mirrors/debian  
 4     #<Directory />  
 5     #    Options FollowSymLinks  
 6     #    AllowOverride None  
 7     #</Directory>  
 8     <Directory /srv/mirrors/debian>  
 9         Options Indexes SymlinksIfOwnerMatch FollowSymLinks MultiViews  
10         IndexOptions NameWidth=* SuppressDescription  
11         AllowOverride None  
12         Order allow,deny  
13         allow from all  
14     </Directory>  
15   
16     ErrorLog ${APACHE_LOG_DIR}/debian_mirror_error.log  
17   
18     # Possible values include: debug, info, notice, warn, error, crit,  
19     # alert, emerg.  
20     LogLevel warn  
21   
22     CustomLog ${APACHE_LOG_DIR}/debian_mirror_access.log combined  
23 </VirtualHost> 

然后/etc/apache2/sites-enabled目录下新建符号链接,此处将其设置为默认网站，也可以使用虚拟主机

# rm 000-default
# ln -sf /etc/apache2/sites-available/debian_mirror 000-default
最后

# /etc/init.d/apache2 reload

**使用本地源镜像服务**

编辑/etc/apt/source.list,添加
deb http://mirror_ip wheezy main contrib non-free
deb http://mirror_ip wheezy-updates main contrib non-free
deb http://mirror_ip wheezy-proposed-updates main contrib non-free

mirror_ip即是新建的源镜像服务器的IP地址。

**\===
\[erq\]**