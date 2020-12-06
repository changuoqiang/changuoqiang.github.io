---
title: 开启xterm终端256色和终端下vim 256色
tags:
  - Xterm
id: '3306'
categories:
  - - GNU/Linux
date: 2013-10-10 22:50:27
---

相同的colorschema,vim和gvim的颜色差距还是很大的，因为gvim使用X的颜色，而vim只能使用终端提供的颜色，所以造成了二者的显示差异。
<!-- more -->
**xterm开启256色**

现在的终端模拟器早就支持256色了，不过默认可能还是8色的。

开启xterm终端，查看xterm终端支持的颜色
```js
$ tput colors
8
```
xterm终端默认还是8色的

查看终端类型
```js
$ echo $TERM
xterm
```
只要将终端类型更改为xterm-256color即可，有两种方式可以来修改

1、修改.bashrc文件

~/.bashrc文件添加
```js
if \[ "$TERM" == "xterm" \]; then
 export TERM=xterm-256color
fi
```
2、修改.Xresourcesw文件

~/.Xresources文件添加
```js
xterm*termName: xterm-256color
```
只要其中一种方式修改即可，修改生效后，重新查看
```js
$ tput colors
256
$ echo $TERM
xterm-256color
```
如果系统默认没有xterm-256color类型，可安装ncurses-term包，里面有许多附加的终端类型定义，里面还有一个终端类型xterm+256color,也可以开启256色支持，不知道与xterm-256color有什么区别。

**vim开启256色支持**

编辑~/.vimrc文件，添加
```js
set t_Co=256
```
t_Co即terminal Color之意

开启256颜色之后，colorschema在vim里好看了许多，而且与gvim显示的差别不大。

参考：
[256 colors setup for console Vim](http://vim.wikia.com/wiki/256_colors_setup_for_console_Vim)
[256-Color XTerms in Ubuntu](http://push.cx/2008/256-color-xterms-in-ubuntu)

**\===
\[erq\]**