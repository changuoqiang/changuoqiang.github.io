---
title: Xpra入门
tags:
  - Debian
id: '9145'
categories:
  - - GNU/Linux
date: 2020-02-04 18:49:22
---


<!-- more -->
ssh x11 forward太慢了，真的。

Xpra除了很快，还可以后台运行gui应用，被称为screen for X11。还可以远程运行整个桌面。

下面使用macos远程使用debian buster系统上的gui application

**安装**

debian端:
```js
$ wget -q https://xpra.org/gpg.asc -O- sudo apt-key add -
$ sudo add-apt-repository "deb https://xpra.org/ buster main"
$ sudo apt update && sudo apt install xpra -y
```

mac端：
下载[Xpra.pkg](https://xpra.org/dists/osx/x86_64/Xpra.pkg)安装即可。
或者
```js
$ brew cask install xpra
```

**运行**

通过ssh隧道运行

linux/macos平台:

一次性运行gui应用，结束时自动关闭xpra服务
```js
$ xpra start ssh://user@host --start-child=xlogo --exit-with-children=yes --speaker=off --webcam=no
```

启动gui应用,结束时不关闭xpra服务，可以再次附加到gui应用程序
```js
$ xpra start ssh://user@host --start-child=xlogo
```

断开后可以重新附加到已经运行的gui应用
```js
$ xpra attach ssh://user@host
```

windows平台：
```js
cmd> xpra_cmd start ssh://user@host --ssh="C:\\\\Program Files\\\\putty\\\\Plink.exe -ssh -noagent -i c:\\\\***.ppk -P 22" --start-child=xlogo --exit-with-children=yes --speaker=off --webcam=no
```

**其他命令**

列出所有会话
```js
$ xpra list
```

终止所有会话
```js
$ xpra stop
```

**输入法**
服务器上安装ibus
```js
$ sudo apt install ibus-pinyin
```

配置ibus
```js
$ xpra start ssh://user@host --exit-with-children=yes --speaker=off --webcam=no --input-method=IBus --start-child="ibus-setup"
```
运行firefox，同时启动ibus输入法
```js
$ xpra start ssh://user@host --start-child=firefox --exit-with-children=yes --speaker=off --webcam=no --input-method=IBus --start-child="ibus-daemon -x -d -r"
```

其他请参考`xpra --help`

References:
\[1\][manual](https://xpra.org/trac/browser/xpra/trunk/src/man/xpra.1)
\[2\][FAQ](https://xpra.org/trac/wiki/FAQ)
\[3\][GUIDE: Work remotely on a Linux server from local Mac](https://medium.com/@summitkwan/guide-work-remotely-on-a-linux-server-from-local-mac-windows-f05cdc6db0e0)