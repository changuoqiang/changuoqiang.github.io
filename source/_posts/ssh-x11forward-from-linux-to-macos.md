---
title: ssh x11forward from linux to macos
tags:
  - Debian
id: '8815'
categories:
  - - GNU/Linux
date: 2019-10-10 15:35:44
---


<!-- more -->
MacOS Catalina上使用ssh -Xv 登录远程debian linux进行X11转发时提示：
```js
debug1: No xauth program.
Warning: untrusted X11 forwarding setup failed: xauth key data not generated
```
这是因为MacOS上的xauth路径与linux上不同，MacOS上使用XQuartZ其xauth路径为/opt/X11/bin/xauth，而debian上为/usr/bin/xauth，所以ssh客户端没有找到xauth，无法生成认证数据。
在~/.ssh/config文件中为单个主机，或者在/etc/ssh/ssh_config中为所有主机设置：
```js
XAuthLocation /opt/X11/bin/xauth
```

在远程debian上执行glxinfo有错误提示：
```js
$ glxinfo
name of display: localhost:10.0
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
X Error of failed request: GLXBadContext
 Major opcode of failed request: 149 (GLX)
 Minor opcode of failed request: 6 (X_GLXIsDirect)
 Serial number of failed request: 26
 Current serial number in output stream: 25
```
在MacOS端执行
```js
$ defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
```
重启XQuartz 2.7.11，然后就可以了，但是前两行错误继续存在。
iglx就是IndirectGLX的缩写，也就是关闭直接渲染。
远程debian上开启libgl debug
```js
$ export LIBGL_DEBUG=verbose
$ glxgear
libGL: OpenDriver: trying /usr/lib/x86_64-linux-gnu/dri/tls/swrast_dri.so
libGL: OpenDriver: trying /usr/lib/x86_64-linux-gnu/dri/swrast_dri.so
libGL: Can't open configuration file /etc/drirc: No such file or directory.
libGL: Can't open configuration file /home/john/.drirc: No such file or directory.
libGL: Can't open configuration file /etc/drirc: No such file or directory.
libGL: Can't open configuration file /home/john/.drirc: No such file or directory.
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
```
设置环境变量export LIBGL_ALWAYS_INDIRECT=1可以关闭这个错误提示，但是仍然是间接渲染。

这个问题需要XQuartz来解决，这货已经好久好久没有升级了...