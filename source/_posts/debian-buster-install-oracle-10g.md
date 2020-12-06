---
title: debian buster安装oracle 10g
tags:
  - Oracle
id: '9204'
categories:
  - - Database
date: 2020-04-28 22:12:33
---


<!-- more -->
oracle 10g已经太老了，直接在debian buster上安装是不可以的。但可以迂回一下，先在debian squeeze上安装，然后将安装好的oracle文件打包拷贝到debian buster相同的目录结构下，并且使用相同的用户和组权限。

**一、安装**

1、安装squeeze及支持组件

下载squeeze最后的版本[6.0.10](https://cdimage.debian.org/mirror/cdimage/archive/6.0.10/amd64/iso-cd/debian-6.0.10-amd64-netinst.iso)，脱机安装完毕后，编辑/etc/apt/sources.list使用以下源：
```js
deb http://archive.debian.org/debian squeeze main contrib non-free
```
其他镜像源都已不可用，只有此归档源可以。

安装支持组件
```js
$ sudo apt-get install build-essential ia32-libs ia32-libs-dev libc6 libc6-i386 libc6-dev libc6-dev-i386 rpm libstdc++5 libaio1 gcc-multilib xauth unzip
```

创建符号链接
```js
# ln -sf /usr/bin/awk /bin/awk
# ln -sf /usr/bin/rpm /bin/rpm
# ln -sf /usr/bin/basename /bin/basename
```

2、创建用户和组
```js
# groupadd oinstall
# groupadd dba
# adduser oracle
# usermod -g oinstall -G dba oracle
//# useradd -g oinstall -G dba oracle
//# passwd oracle
# groupadd nobody
# id oracle
uid=1001(oracle) gid=1001(oinstall) groups=1001(oinstall),1002(dba)
```

3、修改内核参数
添加文件/etc/sysctl.d/oracle.conf:
```js
fs.file-max = 65536
fs.aio-max-nr = 1048576
# semaphores: semmsl, semmns, semopm, semmni
kernel.sem = 250 32000 100 128
# (Oracle recommends total machine Ram -1 byte)
kernel.shmmax = 2147483648
kernel.shmall = 4194304
kernel.shmmni = 4096
net.ipv4.ip_local_port_range = 1024 65000
# dba group
vm.hugetlb_shm_group = 1002
vm.nr_hugepages = 64
```

4、修改资源限制
添加文件/etc/security/limits.d/oracle.conf:
```js
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft memlock 204800
oracle hard memlock 204800
```

5、准备目录结构
```js
#mkdir -p /u01/app/oracle
#chown -R oracle:oinstall /u01

#chmod -R 775 /u01/app/oracle

#usermod -d /u01/app/oracle oracle
#usermod -s /bin/bash oracle
```
从其他用户主目录拷贝.profile，.bashrc，.bash_logout文件到oracle用户主目录

6、安装10.2.0.1
通过X11 forward远程安装，安装路径设定为/u01/app/oracle/product/10.2.0/db_1
只安装软件，不创建数据库，忽略ins_emdb.mk错误继续安装
```js
$ ssh -XC oracle@host
$ gunzip 10201_database_linux_x86_64.cpio.gz
$ cpio -idmv < 10201_database_linux_x86_64.cpio
$ database/runInstaller -ignoreSysPrereqs
```

7、升级10.2.0.4
```js
$ unzip p6810189_10204_Linux-x86-64.zip
$ Disk1/runInstaller -ignoreSysPrereqs
```
升级时选择同一个实例，即OraDb10g_home1

**二、移植**

1、在squeeze上打包
```js
$ tar zcvf /tmp/oracle.tar.gz /u01
$ tar zcvf /tmp/oracle_conf.tar.gz /etc/oratab /etc/oraInst.loc /usr/local/bin/ /etc/sysctl.d/oracle.conf /etc/security/limits.d/oracle.conf
```

2、buster上创建用户组
```js
#groupadd oinstall
#groupadd dba
# adduser oracle
# usermod -g oinstall -G dba oracle
//# useradd -g oinstall -G dba oracle
//# passwd oracle
#groupadd nobody
```

3、准备目录结构
```js
#mkdir -p /u01/app/oracle
#chown -R oracle:oinstall /u01
#chown -R oracle:oinstall /u01/app
#chown -R oracle:oinstall /u01/app/oracle
#chmod -R 775 /u01/app/oracle

#usermod -d /u01/app/oracle oracle
#usermod -s /bin/bash oracle
```

4、buster上还原oracle
将oracle.tar.gz和oracle_conf.tar.gz拷贝到/tmp目录，以oracle用户执行
```js
$ tar zxvf /tmp/oracle.tar.gz -C /
```
以root用户执行:
```js
# tar zxvf /tmp/oracle_conf.tar.gz -C /
```

5、oracle用户配置
.bashrc添加如下环境变量
```js
export ORACLE_SID=orcl
export ORACLE_UNQNAME=orcl
export ORACLE_OWNER=oracle
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/10.2.0/db_1
export PATH=$ORACLE_HOME/bin:$PATH
export TNS_ADMIN=$ORACLE_HOME/network/admin
export SQLPATH=$ORACLE_HOME/scripts
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:$LD_LIBRARY_PATH
```

安装完成，经测试可以正常创建数据库，正常使用。

References:
\[1\][OracleDB](https://wiki.debian.org/OracleDB)