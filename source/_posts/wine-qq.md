---
title: wine QQ
tags:
  - Debian
id: '7157'
categories:
  - - GNU/Linux
date: 2016-01-27 20:01:43
---


<!-- more -->
这次又试了一下wine安装QQ,发现wine已今非昔比，已堪大用。

**添加i386架构**

因为debian早已是mutiarch架构，所以添加intel子架构i386是很简单的:
```js
$ sudo dpkg --add-architecture i386
```

**安装wine**

```js
$ sudo apt-get install wine wine64 wine32
```

**安装cabextract**

因为下面的安装会下载cab格式文件并解压缩安装，所以需要安装cabextract包
```js
$ sudo apt-get install cabextract
```

**安装winetricks-zh**
这是大名顶顶的winetricks的修改版，支持常见的一些中文windows应用。

```js
$ cd ~
$ git clone https://github.com/hillwoodroc/winetricks-zh.git
$ cd winetricks-zh
$ sudo cp winetricks-zh /usr/local/bin
$ cd verb
```

**安装QQ轻聊版(QQLight)**

确认位于下载的winetricks-zh的子目录verb中,执行:
```js
$ winetricks-zh qqlight
```
会下载很多东西，耐心等待安装完成

**菜单项小问题**
默认生成的桌面菜单项是~/.local/share/applications/wine/Programs/腾讯软件/QQ轻聊版/QQ轻聊版.desktop，打开此文件可以发现Exec项的可执行文件路径有问题，修正为如下:
```js
Exec=env WINEPREFIX=/home/guoqiang/.local/share/wineprefixes/qqlight wine "C:\\Program Files (x86)\\Tencent\\QQLite\\Bin\\QQScLauncher.exe"
```
可正常执行QQ轻聊版。

经简单试用发现十分稳定。wine进步真的很大。

**注:**如果QQ文本输入框内输入的中文显示为方块，将显示模式从“气泡模式”更改为“文本模式”则可以正常显示中文。

References:
\[1\][winetricks-zh](https://github.com/hillwoodroc/winetricks-zh)
\[2\][Wine的中文显示与字体设置](http://linux-wiki.cn/wiki/zh-hans/Wine%E7%9A%84%E4%B8%AD%E6%96%87%E6%98%BE%E7%A4%BA%E4%B8%8E%E5%AD%97%E4%BD%93%E8%AE%BE%E7%BD%AE)

**\===
\[erq\]**