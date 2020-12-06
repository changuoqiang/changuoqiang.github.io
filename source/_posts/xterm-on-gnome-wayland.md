---
title: xterm on gnome wayland
tags:
  - Debian
id: '8516'
categories:
  - - GNU/Linux
date: 2019-07-11 14:26:38
---


<!-- more -->
debian buster gnome桌面默认启用wayland，当前仍然可以切换回Xorg
wayland兼容性还是有一些小问题，wayland并不加载profile环境配置文件，
也不理会Xsession，导致.xinitrc,.Xresources等无法加载
系统及用户的Xresources是由/etc/X11/Xsession.d/30x11-common_xresources脚本加载的，在wayland面前失效了，直接后果就是每次重启机器xterm就会被打回原形，只能手工重新加载~/.Xresources
回到gnome on xorg则xterm恢复正常
发现一个跨平台GPU加速的terminale emulator [alacritty](https://github.com/jwilm/alacritty)看起来很不错，可以试用一番。

References:
\[1\][GNOME, Wayland, and environment variables](https://lwn.net/Articles/709769/)