---
title: 使用apt-mirror搭建debian源镜像
tags:
  - Debian
id: '7084'
categories:
  - - GNU/Linux
date: 2015-12-23 13:55:50
---


<!-- more -->
debian官方提供了脚本[ftpsync来搭建源镜像](https://openwares.net/linux/setup_debian_archive_mirror.html)，而apt-mirror是一个更简单便捷的源镜像搭建工具。

**安装**

```js
$ sudo apt-get install apt-mirror
```

**配置**
配置文件/etc/apt/mirror.list只要修改很少的地方，大部分使用默认值即可。

这里使用中科大镜像ftp.cn.debian.org作为上游镜像,只镜像debian jessie amd64架构,不需要镜像源代码。

```js
############# config ##################
#
# set base_path /var/spool/apt-mirror
#
# set mirror_path $base_path/mirror
# set skel_path $base_path/skel
# set var_path $base_path/var
# set cleanscript $var_path/clean.sh
# set defaultarch <running host architecture>　# 默认架构与镜像主机的架构一致,这里是amd64
# set postmirror_script $var_path/postmirror.sh
# set run_postmirror 0
set nthreads 20
set _tilde 0
#
############# end config ##############

deb http://ftp.cn.debian.org/debian jessie main contrib non-free
deb http://ftp.cn.debian.org/debian/ jessie-backports main contrib non-free
deb http://ftp.cn.debian.org/debian/ jessie-proposed-updates main contrib non-free
deb http://ftp.cn.debian.org/debian/ jessie-updates main contrib non-free
deb http://ftp.cn.debian.org/debian-security/ jessie/updates main contrib non-free
#deb-src http://ftp.us.debian.org/debian unstable main contrib non-free

# mirror additional architectures
#deb-alpha http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-amd64 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-armel http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-hppa http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-i386 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-ia64 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-m68k http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-mips http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-mipsel http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-powerpc http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-s390 http://ftp.us.debian.org/debian unstable main contrib non-free
#deb-sparc http://ftp.us.debian.org/debian unstable main contrib non-free

clean http://ftp.cn.debian.org/debian
```

**自动同步**

只需root权限cron自动运行apt-mirror命令即可。

```js
# crontab -e
```
最后输入
```js
# m h dom mon dow command
0 0 * * * apt-mirror
```
即可

**发布**

使用nginx发布源镜像

将apt-mirror的镜像目录链接到/var/www/mirror
```js
# ln -sf /var/spool/apt-mirror/mirror/ftp.cn.debian.org/ mirror
```

然后将nginx默认主机default(或者单独虚拟主机)的根目录设置为/var/www/mirror,并开启目录列表

```js
root /var/www/mirror
location / {
 autoindex on;
}
```

其他机器就可以正常使用新建的源镜像了。

References:
\[1\][apt-mirror](http://apt-mirror.github.io/)

===
\[erq\]