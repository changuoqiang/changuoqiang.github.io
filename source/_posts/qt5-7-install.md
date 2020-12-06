---
title: QT5.7安装
tags:
  - Debian
  - Qt
id: '7543'
categories:
  - - Lang
date: 2016-09-13 11:15:25
---


<!-- more -->
之前一直比较抵触Qt,当然就是因为它的授权问题。随着Qt对开源社区越来越友好，授权方式也做了很大的调整，现在授权已不是障碍。
Qt感觉上比GTK/GTK+还是要完善不少，整个的生态也更成熟。
最新版的Qt 5.7全面拥抱C++11标准，对于C++拥趸来讲当然是好事一桩。
虽然linus并不喜欢C++,但不妨碍C++成为一门伟大的语言。
开始学一下Qt,下一步要基于QCAD二次开发一个测绘类应用程序，还有很长的路要走。

**下载安装**

debian源里的Qt版本略低，从[官方下载](https://www.qt.io/download/)最新的Qt5.7安装文件qt-opensource-linux-x64-5.7.0.run
添加执行权限，然后将Qt安装到/opt目录

```js
$ chmod +x qt-opensource-linux-x64-5.7.0.run
# ./qt-opensource-linux-x64-5.7.0.run
```

如果没有Qt账号，可以提前注册一个，也可以即时注册，安装目录选择/opt/Qt

**配置变量**

修改bashrc文件，添加：
```js
# qt5.7
export QT_HOME=/opt/Qt/5.7/gcc_64
export PATH=$QT_HOME/bin:$PATH
export CPATH=$QT_HOME/include:$PATH
export LIBRARY_PATH=$QT_HOME/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$QT_HOME/lib:$LD_LIBRARY_PATH
```

然后source以下就可以了
```js
$ . .bashrc
```

**\===
\[erq\]**