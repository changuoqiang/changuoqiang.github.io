---
title: apt安装软件包指定版本
tags:
  - Debian
id: '8130'
categories:
  - - GNU/Linux
date: 2018-12-06 08:59:08
---


<!-- more -->
当配置了多个源，特别是添加backports源之后，一个package可能有多个候选版本
源是有优先级的，apt会默认从优先级高的源安装package

可以通过apt-cache来查看package候选版本信息
```js
$ apt-cache policy tmux
tmux:
 Installed: (none)
 Candidate: 2.3-4
 Version table:
 2.8-1~bpo9+1 100
 100 http://ftp.tw.debian.org/debian stretch-backports/main amd64 Packages
 2.3-4 500
 500 http://ftp.tw.debian.org/debian stretch/main amd64 Packages
```
可以看到backports源优先级比较低，所以默认安装并不会安装最新版本

可以通过指定版本来安装
```js
$ sudo apt install tmux=2.8-1~bpo9+1
```
bpo就是backports的缩写，

或者指定从backports源里安装：
```js
$ sudo apt install tmux -t stretch-backports
```

还可以查看源里多个版本的详细信息：
```js
$ apt-cache show tmux
Package: tmux
Version: 2.8-1~bpo9+1
Installed-Size: 677
...
Package: tmux
Version: 2.3-4
Installed-Size: 620
...
```