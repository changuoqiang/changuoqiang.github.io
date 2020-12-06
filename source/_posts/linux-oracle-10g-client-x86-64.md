---
title: Debian Squeeze AMD64安装Oracle 10g x86_64客户端
tags:
  - Debian
id: '1896'
categories:
  - - GNU/Linux
date: 2012-01-17 14:03:01
---

操作系统为Debian Squeeze AMD64,没有安装X,通过ssh远程访问。客户端为debian testing,安装有gnome桌面环境。
<!-- more -->
安装过程如下：

**1、下载oracle 10g客户端**

下载回来的文件为10201_client_linux_x86_64.cpio.gz
$gunzip 10201_client_linux_x86_64.cpio.gz
$cpio -idmv < 10201_client_linux_x86_64.cpio

解压缩后所有的安装文件位于client目录下。

**2、检查硬件是否达到要求**

物理RAM必须大于512M,现在的机器内存都没问题。超过726MB RAM时,swap应该在物理RAM的0.75倍以上。Administrator安装类型使用的硬盘空间最多,不过也才850M而已。
通过以下命令检查,如果不满足需要做相应的调整

$grep MemTotal /proc/meminfo //检查物理内存大小
$grep SwapTotal /proc/meminfo //检查swap大小
$df -h //检查可用硬件空间大小

**3、安装需要的软件包**

$sudo apt-get install build-essential ia32-libs ia32-libs-dev libc6 libc6-i386 libc6-dev libc6-dev-i386

如果不安装ia32-libs,安装时会提示

/.../client/runInstaller: 63: /.../client/install/.oui: not found

**4、创建oracle需要的组和用户**

oracle安装使用的组
#groupadd oinstall

系统管理使用的组
#groupadd dba

创建用户oracle
#useradd -g oinstall -G dba oracle

为用户oracle设置密码
#passwd oracle
 **5、创建oracle基准目录**

oracle安装目录的设置最好遵循oracle [OFA](http://docs.oracle.com/cd/B19306_01/install.102/b15660/app_ofa.htm)(Optimal Flexible Architecture)规范的建议。

用以下命令来设置ORACLE BASE目录/u01/app/oracle
#mkdir -p /u01/app/oracle
#chown -R oracle:oinstall /u01/app/oracle
#chmod -R 775 /u01/app/oracle

**6、设置oracle用户的环境**

设置oracle的用户的主目录home为/u01/app/oracle
#usermod -d /u01/app/oracle oracle

从其他用户主目录下拷贝.profile,.bashrc,.bash_logout文件到oracle用户的主目录,在.bashrc文件增加下面的行
umask 022
然后
$source .bashrc

最后设置oracle用户[远程ssh登录时启用X11 Forward](https://openwares.net/linux/x11_forward_over_ssh.html)

也可以不使用X远程静默安装oracle

**7、安装oracle 10g x86_64客户端**

登录到远程系统
$ssh -XY oracle@remotehost

执行oracle安装程序
$/path/to/client/runInstaller -ignoreSysPrereqs

因为oracle 10g认证的linux系统只有redhat-3, SuSE-9, redhat-4, UnitedLinux-1.0, asianux-1 和 asianux-2这几个,所以在其他linux发行版上安装时需要指定命令行参数-ignoreSysPrereqs,否则会提示:
 Checking operating system version: must be redhat-3, SuSE-9, redhat-4, UnitedLinux-1.0, asianux-1 or asianux-2
 Failed <<<<
然后退出安装

之后在本地机器可以看到OUI(Oracle Universal Installer)界面,后面的安装根据提示来就可以了。因为只安装客户端,所以oracle home的名字修改为OraClient10g_home1,客户端的安装目录修改为/u01/app/oracle/product/10.2.0/client_1

安装完成后,在oracle用户的.bashrc文件中添加以下ORACLE环境变量
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/client_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
#export SQLPATH=$ORACLE_HOME/scripts

安装完成