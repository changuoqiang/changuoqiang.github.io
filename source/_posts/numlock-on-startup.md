---
title: debian启动时激活numlock
tags:
  - Debian
id: '5241'
categories:
  - - GNU/Linux
date: 2014-03-14 09:47:30
---

debian启动时默认关闭numlock有一阵子了。
<!-- more -->
一直懒的弄它,这几天实在受不鸟了。

numlock状态在console和X环境下是分别单独控制的。X终端模拟器继承X下的设置。

**console**

配置文件/etc/kbd/config中添加LEDS选项
```js
# Turn on numlock by default
LEDS=+num
```

或者在~/.bash_profile添加setleds命令打开numlock
```js
setleds -D +num
```

**X**

X环境下需要使用numlockx命令来打开numlock,所以需要先安装numlockx
```js
#apt-get install numlockx
```
因为使用gdm,所以在gdm配置文件/etc/gdm3/Init/Default中添加如下行:
```js
if \[ -x /usr/bin/numlockx \]; then
/usr/bin/numlockx;
fi
```

记得要在最后一行exit 0之前添加。

References:
\[1\][Activating Numlock on Bootup](https://wiki.archlinux.org/index.php/Activating_Numlock_on_Bootup)

===
\[erq\]