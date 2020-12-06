---
title: gnome alacarte崩溃
tags: []
id: '8187'
categories:
  - - uncategorized
date: 2018-12-22 16:44:55
---

编辑菜单项时，alacarte突然崩溃，应该是因为wine生成的菜单有乱码导致的。
<!-- more -->
执行alacarte有如下错误提示：
```js
(alacarte:1985): Gtk-CRITICAL **: gtk_accel_label_set_accel_closure: assertion 'gtk_accel_group_from_accel_closure (accel_closure) != NULL' failed

(alacarte:1985): Gtk-CRITICAL **: gtk_accel_label_set_accel_closure: assertion 'gtk_accel_group_from_accel_closure (accel_closure) != NULL' failed
Traceback (most recent call last):
File "/usr/bin/alacarte", line 26, in &lt;module&gt;
main()
File "/usr/share/alacarte/Alacarte/MainWindow.py", line 464, in main
app.setMenuBasename(basename)
File "/usr/share/alacarte/Alacarte/MainWindow.py", line 62, in setMenuBasename
self.editor = MenuEditor(menu_basename)
File "/usr/share/alacarte/Alacarte/MenuEditor.py", line 36, in __init__
self.load()
File "/usr/share/alacarte/Alacarte/MenuEditor.py", line 49, in load
if not self.tree.load_sync():
GLib.Error: g-markup-error-quark: Error on line 1 char 1: Document was empty or contained only whitespace (1)
```

是因为~/.config/menus/gnome-applications.menu内容为空导致的，不知道怎么就突然生成了这么一个空白文档，将其删除问题解决。