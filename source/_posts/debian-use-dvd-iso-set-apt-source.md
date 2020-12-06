---
title: debian使用dvd iso镜像配置本地源
tags:
  - Debian
id: '9229'
categories:
  - - GNU/Linux
date: 2020-05-19 21:06:10
---


<!-- more -->
因为某云在某个网络内没有debian安装源，所以只能使用本地源。
debian支持的软件包很多，amd64架构的dvd iso竟然有16张之多，bd格式iso则只有4张，这里使用dvd格式的iso。

首先，下载debian 10.1.0 amd64架构的dvd iso，[http方式只能下载前三个iso](https://cdimage.debian.org/cdimage/archive/10.1.0/amd64/iso-dvd/),下载其他iso需要使用jigdo方式即时下载在线制作iso文件。

debian系统安装jigdo-file使用jigdo-lite命令，输入iso的jigdo文件url即可下载制作iso镜像。debian 10.1.0 dvd iso的[jigdo下载地址在此](https://cdimage.debian.org/cdimage/archive/10.1.0/amd64/jigdo-dvd/)。
因为需要安装的包postgresql-11-postgis-2.5不在前三张dvd，所以使用jigdo下载了第四张dvd镜像。

然后，将四张dvd iso分别挂载到/media目录的挂载点:
```js
# mount /path/to/debian-10.1.0-amd64-DVD-1.iso /media/cdrom1/
# mount /path/to/debian-10.1.0-amd64-DVD-2.iso /media/cdrom2/
# mount /path/to/debian-10.1.0-amd64-DVD-3.iso /media/cdrom3/
# mount /path/to/debian-10.1.0-amd64-DVD-4.iso /media/cdrom4/
```
也可以添加到/etc/fstab:
```js
/srv/debsrcs/debian-10.1.0-amd64-DVD-1.iso/media/cdrom1udf,iso9660 loop 0 0
/srv/debsrcs/debian-10.1.0-amd64-DVD-2.iso/media/cdrom2udf,iso9660 loop 0 0
/srv/debsrcs/debian-10.1.0-amd64-DVD-3.iso/media/cdrom3udf,iso9660 loop 0 0
/srv/debsrcs/debian-10.1.0-amd64-DVD-4.iso/media/cdrom4udf,iso9660 loop 0 0
```
然后
```js
# mount -a
```
编辑/etc/apt/sources.list文件，添加如下行：
```js
deb \[ trusted=yes \] file:/media/cdrom1/ buster main contrib 
deb \[ trusted=yes \] file:/media/cdrom2/ buster main contrib 
deb \[ trusted=yes \] file:/media/cdrom3/ buster main contrib 
deb \[ trusted=yes \] file:/media/cdrom4/ buster main contrib 
```

最后，apt update后正常安装软件即可，如果要安装的软件还是找不到，可能需要下载更多的dvd iso镜像。