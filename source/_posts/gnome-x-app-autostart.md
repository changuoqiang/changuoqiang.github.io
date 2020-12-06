---
title: GNOME环境X应用程序自启动
tags:
  - Debian
id: '6932'
categories:
  - - GNU/Linux
date: 2015-11-22 10:16:28
---


<!-- more -->
GNOME环境下的GUI应用程序可以配置在GNOME初始化后自动运行。

配置自启动的位置在：
```js
$HOME/.config/autostart/
```

简单的将/usr/share/applications目录下的.desktop文件拷贝到此目录下即可：
```js
$ cp /usr/share/applications/foo.desktop ~/.config/autostart/
```

或者使用GNOME Tweak Tool -> Startup Applications选择一下就可以了。

References:
\[1\][Autostarting](https://wiki.archlinux.org/index.php/Autostarting)

**\===
\[erq\]**