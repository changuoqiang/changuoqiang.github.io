---
title: alacritty无法使用输入法问题
tags:
  - misc
id: '9105'
categories:
  - - GNU/Linux
date: 2020-01-14 14:29:03
---


<!-- more -->
alacritty在使用wayland的系统上无法切换出中文输入法，将alacritty菜单项执行的命令更改为：
```js
env WINIT_UNIX_BACKEND=x11 alacritty
```
这样将渲染后端更改为x11

比如~/.local/share/applications/alacritty.desktop
```js
\[Desktop Entry\]
Type=Application
TryExec=alacritty
Exec=env WINIT_UNIX_BACKEND=x11 alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;

Name=Alacritty
GenericName=Terminal
Comment=A cross-platform, GPU enhanced terminal emulator
StartupWMClass=Alacritty
Actions=New;

\[Desktop Action New\]
Name=New Terminal
Exec=alacritty
```