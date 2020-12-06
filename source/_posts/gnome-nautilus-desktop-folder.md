---
title: gnome移动Desktop目录到其他位置
tags:
  - Debian
id: '1983'
categories:
  - - GNU/Linux
date: 2012-03-18 09:00:16
---

默认情况下,gnome的“桌面"文件夹位于用户主目录下,根据locale不同,名字也不同
<!-- more -->
en_US.utf8环境下,桌面文件夹为~/Desktop,这家伙在这里,不利于用户文件的管理,所以移动到其他位置会比较好

编辑~/.config/user-dirs.dirs文件,如果没有新建一个,增加以下内容

XDG_DESKTOP_DIR="$HOME/.desktop"

保存退出,然后

$mv Desktop .desktop

桌面文件夹就不会再碍眼了。