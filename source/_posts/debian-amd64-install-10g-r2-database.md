---
title: Debian Squeeze AMD64安装Oracle 10g x86_64 10.2.0.4数据库
tags:
  - Oracle
id: '1919'
categories:
  - - Database
date: 2012-01-19 15:18:39
---

服务器操作系统为Debian Squeeze AMD64,没有安装X,通过ssh远程访问。客户端为debian testing,安装有gnome桌面环境。
<!-- more -->
先安装10.2.0.1,然后安装升级包10.2.0.4,比安装10g r2客户端多了一些操作,具体安装过程如下：

**一、安装10.2.0.1**

**1、下载oracle 10g r2**

下载回来的文件为10201_database_linux_x86_64.cpio.gz
```js
$gunzip 10201_database_linux_x86_64.cpio.gz
$cpio -idmv < 10201_database_linux_x86_64.cpio
```
解压缩后所有的安装文件位于database目录下。

**2、检查硬件是否达到要求**

物理RAM必须大于512M,现在的机器内存都没问题。超过8GB RAM时,swap应该在物理RAM的0.75倍以上。Enterprise Edition安装类型大约使用2G硬盘空间。
通过以下命令检查,如果不满足需要做相应的调整
```js
$grep MemTotal /proc/meminfo //检查物理内存大小
$grep SwapTotal /proc/meminfo //检查swap大小
$df -h //检查可用硬件空间大小
```
**3、安装需要的软件包,创建需要的符号链接**

安装依赖包
```js
$sudo apt-get install build-essential ia32-libs ia32-libs-dev libc6 libc6-i386 libc6-dev libc6-dev-i386 rpm libstdc++5 libaio1
```
如果不安装ia32-libs,安装时会提示
```js
/.../client/runInstaller: 63: /.../client/install/.oui: not found
```

创建符号链接
```js
#ln -sf /usr/bin/awk /bin/awk
#ln -sf /usr/bin/rpm /bin/rpm
#ln -sf /usr/bin/basename /bin/basename
```
**4、创建oracle需要的组和用户**

oracle安装使用的组
```js
#groupadd oinstall
```
系统管理使用的组
```js
#groupadd dba
```
创建用户oracle
```js
#useradd -g oinstall -G dba oracle
```
为用户oracle设置密码
```js
#passwd oracle
```
创建nobody用户和nobody组
```js
#groupadd nobody
```
debian默认已经创建了nobody用户,其属于nogroup组,但$ORACLE_HOME/root.sh为$ORACLE_HOME/bin/extjob设置的组为nobody,所以这里也要创建nobody组,否则root.sh会抱怨
```js
/bin/chgrp: invalid group: \`nobody'
```
**5、配置内核参数和oracle用户资源限制值**

**内核参数**

oracle 10g要求的内核参数值如下
```js
semmsl 250
semmns 32000
semopm 100
semmni 128

shmmni 4096 
file-max 65536 
ip_local_port_range 最小:1024 最大:65000
rmem_default 262144 
rmem_max 262144 
wmem_default 262144 
wmem_max 262144 
```
shmall是全部允许使用的共享内存大小，shmmax是单个段允许使用的大小。可以直接将这两个参数设置为物理内存的大小或者是SGA值的大小。

shmall是按页计数的所有共享内存的数量,计算方法如下：
获取页面大小
```js
$getconf PAGE_SIZE
4096
```
也就是说页面大小为4K,如果物理内存或SGA总数为16G,则shmall的值为16*1024*1024/4=4194304

如果oracle出现以下错误提示
```js
ORA-27102: out of memory
Linux-x86_64 Error: 28: No space left on device
```
则需要适当增加内核参数shmall的值

如果系统默认的内核参数值高于oracle 10g需要的值,则保持默认参数不变,否则用oracle 10g要求的值来修改内核参数。修改参数时在/etc/sysctl.d目录下新建oracle.conf,将新的参数值写入此文件
```js
kernel.sem = 250 32000 100 128
kernel.shmmax = 8589934592
net.ipv4.ip_local_port_range = 1024 65000
net.core.rmem_default = 262144
net.core.rmem_max = 262144
net.core.wmem_default = 262144
net.core.wmem_max = 262144
```
kernel.sem参数值按semmsl semmns semopm semmni这个顺序指定,中间以空格隔开

为oracle用户所在组赋予分配大内存页的权限
```js
#id oracle
uid=1001(oracle) gid=1001(oinstall) groups=1001(oinstall),1002(dba)
#echo "1002" > /proc/sys/vm/hugetlb_shm_group
```
这样oracle才有权限分配大内存页,否则建库时会有错误提示:
ORA-27125:unable to create shared memory segment

不过这样设置重启后参数就丢失了,可以在/etc/sysctl.conf或/etc/sysctl.d/oracle.conf文件里面添加该参数

vm.hugetlb_shm_group=1002
之后运行命令

#sysctl -p
或
#sysctl -p /etc/sysctl.d/oracle.conf

可使该参数在内核内存中立即生效

**oracle用户资源限制值**

在/etc/security/limits.d目录下新建文件oracle.conf,文件名随意,但扩展名一定要是conf,输入一下内容
# 
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536

在/etc/profile.d目录下新建文件oracle.sh,文件名随意,但扩展名一定要是sh,输入以下内容

```js
#for oracle 10g r2
if \[ $USER = "oracle" \]; then
 if \[ $SHELL = "/bin/ksh" \]; then
 ulimit -p 16384
 ulimit -n 65536
 else
 ulimit -u 16384 -n 65536
 fi
fi
```

**6、创建oracle基准目录**

oracle安装目录的设置最好遵循oracle [OFA](http://docs.oracle.com/cd/B19306_01/install.102/b15660/app_ofa.htm)(Optimal Flexible Architecture)规范的建议。

用以下命令来设置ORACLE BASE目录/u01/app/oracle
```js
#mkdir -p /u01/app/oracle
#chown -R oracle:oinstall /u01
#chmod -R 775 /u01/app/oracle
```
**7、设置oracle用户的环境**

设置oracle的用户的主目录home为/u01/app/oracle
```js
#usermod -d /u01/app/oracle oracle
```
修改oracle用户的shell为/bin/bash
```js
#usermod -s /bin/bash oracle
```
从其他用户主目录下拷贝.profile,.bashrc,.bash_logout文件到oracle用户的主目录,在.bashrc文件增加下面的行
umask 022
然后
```js
$source .bashrc
```
最后设置oracle用户[远程ssh登录时启用X11 Forward](https://openwares.net/linux/x11_forward_over_ssh.html)

也可以不使用X远程静默安装oracle

**8、安装oracle 10g x86_64数据库**

登录到远程系统
```js
$ssh -XY oracle@remotehost
```
执行oracle安装程序
```js
$/path/to/client/runInstaller -ignoreSysPrereqs
```
因为oracle 10g认证的linux系统只有redhat-3, SuSE-9, redhat-4, UnitedLinux-1.0, asianux-1 和 asianux-2这几个,所以在其他linux发行版上安装时需要指定命令行参数-ignoreSysPrereqs,否则会提示:
 Checking operating system version: must be redhat-3, SuSE-9, redhat-4, UnitedLinux-1.0, asianux-1 or asianux-2
 Failed <<<<
然后退出安装

之后在本地机器可以看到OUI(Oracle Universal Installer)界面,后面的安装根据提示来就可以了。安装目录修改为/u01/app/oracle/product/10.2.0/db_1

安装进度大约到65%时会有错误提示：
Error in invoking target 'collector' of makefile '/u01/app/oracle/product/10.2.0/db_1/sysman/lib/ins_emdb.mk'.
这是oracle安装程序的一个bug,可以忽略此错误继续安装,对系统没什么影响。同时oraInventory/logs/目录下的安装日志文件里面会有如下类似错误提示：

INFO: /usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/snmccolm.o' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/libnmccol.a(nmccole.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/libnmcbuf.a(nmcbuft.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/ap
INFO: p/oracle/product/10.2.0/db_1/sysman/lib/libnmcbuf.a(nmcbufw.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/libnmcbuf.a(nmcbufu.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/libnmcbuf.a(snmcbufm.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib/
INFO: libnmcbuf.a(nmcbuff.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib//libnmadbg.a(nmadbg.o)' is incompatible with i386:x86-64 output
/usr/bin/ld: i386 architecture of input file \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib//libnmadbg.a(snmadbg.o)' is incompatible with i386:x86-64 output
collect2: ld returned 1 exit status

INFO: make\[1\]: Leaving directory \`/u01/app/oracle/product/10.2.0/db_1/sysman/lib'

INFO: make\[1\]: *** \[/u01/app/oracle/product/10.2.0/db_1/sysman/lib/nmccollector\] Error 1
make: *** \[nmccollector\] Error 2

这是因为oracle 10.2.0.1安装包为这几个i386目标文件提供了错误版本的x86_64链接库,之后安装patchset 10.2.0.4时relink nmccollector会成功。
关于此错误更详细的信息请参考Metalink NOTE 957982.1和Bug 8993720。

**9、安装后配置**

安装完成后,在oracle用户的.bashrc文件中添加以下ORACLE环境变量
```js
export ORACLE_OWNER=oracle
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
#export SQLPATH=$ORACLE_HOME/scripts
```
**二、升级到patchset 10.2.0.4**

**1、升级软件**

首先停止所有oracle服务,实际上如果安装完成10.2.0.1后立即进行升级的话,oracle的所有服务并没有运行,也就不必去停止它们
```js
#/etc/init.d/oracle stop
```
oracle数据库的启动和关闭控制见[Debian配置Oracle 10g自启动](https://openwares.net/2012/01/25/debian_oracle_10g_init/)

然后运行升级包升级软件
```js
$/path/to/patchset_directory/Disk1/runInstaller -ignoreSysPrereqs
```
按提示升级即可

**2、升级数据库**

如果此前并没有创建数据库,那么升级到10.2.0.4到此就结束了,然后可以去创建新的数据库。
如果此前已经创建了数据库,那么按以下步骤升级数据库到10.2.0.4版本

启动监听器
```js
$lsnrctl start
```

以sysdba身份登陆数据库并运行升级脚本
```js
$sqlplus / as sysdba;
SQL> STARTUP UPGRADE
SQL> SPOOL patch.log
SQL> @?/rdbms/admin/catupgrd.sql
SQL> SPOOL OFF
```
关闭并重启数据库
```js
SQL> SHUTDOWN IMMEDIATE
SQL> STARTUP 
```
编译无效PL/SQL包
```js
SQL> @?/rdbms/admin/utlrp.sql
```
检查升级是否成功
```js
SQL> SELECT COMP_NAME, VERSION, STATUS FROM SYS.DBA_REGISTRY;
```
如果所有组件的status都是valid表示升级成功

检查是否有升级错误
```js
SQL> select * from utl_recomp_errors;
```
如果使用Oracle Recovery Manager catalog, 需要对catalog进行升级，如下:
```js
$rman catalog username/password@alias
RMAN> UPGRADE CATALOG; 
```
修改系统兼容性参数
```js
SQL> alter system set compatible='10.2.0.4.0' scope=spfile;
SQL> SHUTDOWN
SQL> STARTUP
```
安装完成

**UPDATE:**

在Debian 当前的tesing分支Wheezy上安装oracle 10g时,需要增加以下两个符号链接：
```js
#ln -sf /usr/lib/x86_64-linux-gnu/ /usr/lib64
#ln -sf /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib64/libgcc_s.so.1
```
这是因为Wheezy开始支持[multiarch](https://openwares.net/linux/multiarch_and_lib_dir.html),库路径做了比较大的调整。

References:
\[1\][OracleDB](https://wiki.debian.org/OracleDB)