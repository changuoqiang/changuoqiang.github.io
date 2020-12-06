---
title: flatpak简单介绍
tags:
  - Debian
id: '8076'
categories:
  - - GNU/Linux
date: 2018-11-28 14:11:49
---


<!-- more -->
GIMP改用flatpak打包，flatpak以前叫xdg-app，现在flatpak是指flat package吗?

flatpak是一种致力于减少依赖的通用应用打包格式，与之竞争的还有snap和AppImage

**安装**

flatpak已经进入debian当前的testing buster源和sid源， debian stretch可以从官方的backports源`deb http://ftp.tw.debian.org/debian stretch-backports main contrib non-free`安装

```js
$ apt install flatpak
```

添加flatpak官方源
```js
$ sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

因为flatpak本身就是一种app打包格式，官方应该提供一个自举安装的shell脚本才显得更专业:)

**安装gimp**
```js
$ flatpak install https://flathub.org/repo/appstream/org.gimp.GIMP.flatpakref
```

可以使用桌面图标运行，或者使用以下命令：
```js
$ flatpak run org.gimp.GIMP//stable
```

**flatpak文件系统布局**

flatpak支持系统范围安装和用户安装，系统安装在/var/lib/flatpak, 
安装的app系统配置在/var/lib/flatpak/app，其他子目录为flatpak本身系统范围的配置
安装的app的当前用户配置在$HOME/.var/app，flatpak本身的当前用户配置在$HOME/.local/share/flatpak


References:
\[1\][Flatpak](https://flatpak.org/)
\[2\][Flatpak filesystem layout](https://github.com/flatpak/flatpak/wiki/Filesystem)