---
title: Mac系统ls命令目录优先
tags:
  - mac
id: '5478'
categories:
  - - GNU/Linux
date: 2014-05-03 09:25:04
---


<!-- more -->
linux系统上可以指定ls选项`--group-directories-first`,但是mac系统上的ls命令没有此选项。

有两个方法：

*   使用grep过滤
定义别名:
```js 
alias ll='ls -lh grep ^total && ls -lh grep ^d && ls -lh grep -v ^d grep -v ^total'
```
*   使用gnu ls
安装gnu版本的命令:
```js
$ brew install coreutils
```
定义别名:
```js
alias ls="gls -p --color=auto --group-directories-first"
```