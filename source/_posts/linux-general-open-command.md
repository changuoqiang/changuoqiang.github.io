---
title: linux通用open命令
tags:
  - Debian
id: '6634'
categories:
  - - GNU/Linux
date: 2015-09-08 10:26:19
---


<!-- more -->
我们知道，mac os x 终端下有一个命令open,可以打开任意类型的文件，当然是以系统内对应文件类型默认关联的应用程序来打开文件，如果系统本身没有该类型文件的处理程序，那么open命令一样无能为力。open命令还可以打开目录，默认用finder打开。

比如用finder打开当前目录
```js
$ open .
```

其实linux平台上也有类似的命令，与mac open命令最接近的应该是xdg-open。xdg-open是桌面环境无关的默认应用程序处理器，在不同的桌面环境下，会调用桌面环境自己的默认程序处理器，比如gnome环境下会调用gnome-open。gnome-open以与nautilus相同的规则来打开各种类型的文件以及目录。

当没有桌面环境，或者桌面环境不支持默认程序处理时, xdg-open会使用自己的配置文件，自己来处理各种类型文件的默认应用程序。

比如,gnome环境下，执行以下命令，会用nautilus打开当前目录:
```js
$ xdg-open .
```

XDG是X Desktop Group的缩写,freedesktop.org以前就叫这个名字，所以freedesktop所做的工作，很多冠以xdg开头。

Debian系统内也有一个open命令，这个命令是openvt的符号链接，用于在一个新的虚拟终端中运行应用程序。

可以在bashrc文件中用别名覆盖掉默认的open，这样:
```js
alias open='xdg-open 2>/dev/null' 
```

这样终端下就可以直接open各种文档了。

References:
\[1\][xdg-open](https://wiki.archlinux.org/index.php/Xdg-open)
\[2\][Linux下的通用打开命令](http://www.worldhello.net/2011/04/12/2437.html)
\[3\][Debian alternatives system](http://wiki.devl.cz/Default%20programs)
**\===
\[erq\]**