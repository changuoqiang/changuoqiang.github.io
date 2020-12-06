---
title: Mac OS X更新bash
tags:
  - mac
id: '5859'
categories:
  - - GNU/Linux
date: 2014-09-20 15:01:40
---


<!-- more -->
最新版本的Mac OS X内置的bash仍然是3.x, 下面使用brew更新bash到4.x

安装bash
```js$ brew install bash```

/etc/shells文件最后附加一下行:
```js/usr/local/bin/bash```

更改当前用户的shell
```js$ chsh -s /usr/local/bin/bash```

即便如此,Terminal仍然使用系统内置的bash,也就是/bin/bash,这可以通过Terminal Preferences来修改。修改Shell open with为Default login shell或者为 command(complete path)，空白处填/usr/local/bin/bash即可。

或者更暴力更直接一点:

```js
# cp /bin/bash /bin/bash-3.bak
# ln -sf /usr/local/bin/bash /bin/bash 
```

最后看一下bash版本:

```js
$ echo $BASH_VERSION
4.3.24(1)-release

$ bash --version
GNU bash, version 4.3.24(1)-release (x86_64-apple-darwin13.3.0)
Copyright (C) 2013 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>

This is free software; you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
```

**\===
\[erq\]**