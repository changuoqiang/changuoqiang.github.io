---
title: setuid与setgid
tags:
  - Debian
id: '6314'
categories:
  - - GNU/Linux
date: 2015-04-07 16:16:39
---


<!-- more -->
setuid与setgid使可执行二进制文件(不包括脚本)无论用哪个用户执行都具有文件属主或属组的权限。
比如一个文件的属主为root,如果设置了setuid位,则一个非特权用户执行此程序时就可以以root的身份运行此程序，可以访问到非特权用户访问不到的用户资源。setgid与此同。

setuid
```js
# chmod u+s binary 
```

setgid
```js
# chmod g+s binary
```

**\===
\[erq\]**