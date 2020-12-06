---
title: Netbeans 7.4 菜单无法使用问题
tags:
  - Java
id: '4582'
categories:
  - - GNU/Linux
date: 2013-12-28 18:38:45
---

为什么Java IDE里到处是坑。Eclipse kepler慢吞吞,崩溃不止,好不容易想换Netbeans试试,菜单竟然无法使用！
<!-- more -->
除了坑还是坑啊！！！

系统环境:
debian testing jessie amd64 + openjdk-7-jdk 7u21-2.3.9-5 + Netbeans 7.4

新安装的Netbeans 7.4,鼠标点击主菜单,菜单显示出来了,一松鼠标,主菜单又没了,这是闹那样啊!!!

这bug据说有年头了,为啥这坑还不填上呢!!!

**解决方法:**

编辑netbeans的桌面加载文件 .local/share/applications/netbeans-7.4.desktop

将Exec那行添加前缀,改成如下形式:
```js
Exec=env DESKTOP_SESSION="gnome-shell" /bin/sh "/path/to/netbeans"
```

问题解决。不过要点击netbeans的桌面图标打开netbeans才行,如果用命令行,要把上面的命令敲全了!

坑啊坑,能不能少一点儿！！！

参考:

[Netbeans menu don't work when maximized or enlarged](https://bugs.launchpad.net/gala/+bug/1074491)

**\===
\[erq\]**