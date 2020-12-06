---
title: gnome main menu alacarte crash
tags:
  - Debian
id: '9356'
categories:
  - - Misc
date: 2020-09-24 17:02:33
---


<!-- more -->
使用alacarte删除了几个菜单项后，再也打不开gnome main menu了，终端下运行alacarte出现错误:
```js
$ alacarte
usr/share/alacarte/Alacarte/MainWindow.py:22: PyGIWarning: GMenu was imported without specifying a version first. Use gi.require_version('GMenu', '3.0') before import to ensure that the right version gets loaded.
 from gi.repository import Gtk, GdkPixbuf, Gdk, GMenu

(alacarte:1718): Gtk-CRITICAL **: 16:54:24.699: gtk_accel_label_set_accel_closure: assertion 'gtk_accel_group_from_accel_closure (accel_closure) != NULL' failed

(alacarte:1718): Gtk-CRITICAL **: 16:54:24.699: gtk_accel_label_set_accel_closure: assertion 'gtk_accel_group_from_accel_closure (accel_closure) != NULL' failed
Traceback (most recent call last):
 File "/usr/bin/alacarte", line 26, in <module>
 main()
 File "/usr/share/alacarte/Alacarte/MainWindow.py", line 464, in main
 app.setMenuBasename(basename)
 File "/usr/share/alacarte/Alacarte/MainWindow.py", line 62, in setMenuBasename
 self.editor = MenuEditor(menu_basename)
 File "/usr/share/alacarte/Alacarte/MenuEditor.py", line 36, in __init__
 self.load()
 File "/usr/share/alacarte/Alacarte/MenuEditor.py", line 49, in load
 if not self.tree.load_sync():
gi.repository.GLib.Error: g-markup-error-quark: Error on line 1 char 1: Document was empty or contained only whitespace (1)
```

发现~/.config/menus目录下多了一个空白文件gnome-applications.menu，将其删除问题解决。