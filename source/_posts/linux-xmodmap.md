---
title: linux 修改按键映射
tags: []
id: '7996'
categories:
  - - uncategorized
date: 2018-11-16 09:19:08
---


<!-- more -->
xmodmap(X modify key map)可以修改X下的键位映射
比如０现在用的键盘没有右边的CTRL，很难用，右侧的INSERT键刚好在空格右侧不远的地方，可以把它修改为右CTRL

可以使用xev程序来查看当前的keymap，可以看到右侧的INSERT键位映射为：
```js
KeyPress event, serial 33, synthetic NO, window 0x2a00001,
 root 0xdc, subw 0x0, time 102519, (936,455), root:(986,569),
 state 0x10, keycode 118 (keysym 0xff63, Insert), same_screen YES,
 XLookupString gives 0 bytes: 
 XmbLookupString gives 0 bytes: 
 XFilterEvent returns: False
```

**导出原映射**

```js
$ xmodmap -pke > ~/.Xmodmap
```

**修改映射**

控制键要先clear，最后再add
编辑.Xmodmap文件，文件开头处添加
```js
clear Control
```

将keycode 118修改为

```js
keycode 118 = Control_R NoSymbol Control_R
```

然后文件尾部添加
```js
add Control = Control_L Control_R
```

**测试配置**

修改好映射文件后
```js
$ xmodmap ~/.Xmodmap
```

GDM,XDM和LightDM在开启xsession时会自动读取$HOME/.Xmodmap，但不稳定，时好时坏:(

使用startx时激活你自己的映射表，请添加下面的文件和内容：

```js
~/.xinitrc
if \[ -f $HOME/.Xmodmap \]; then
 /usr/bin/xmodmap $HOME/.Xmodmap
fi
```

References:
\[1\][Xmodmap](https://wiki.archlinux.org/index.php/Xmodmap_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
\[2\][linux下修改键位映射](http://blog.kankanan.com/article/linux-4e0b4fee6539952e4f4d66205c04.html)