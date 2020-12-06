---
title: GCC编译链接时移除未使用的代码
tags: []
id: '8102'
categories:
  - - GNU/Linux
date: 2018-11-30 10:45:50
---


<!-- more -->
编译时把数据和函数放到单独的section中，然后链接的时候抛弃掉未使用的section就可以了。

也就是组合使用CFLAGS: `-ffunction-sections -fdata-sections` 和 LDFLAGS: `-Wl,--gc-sections`
```js
$ cc foo.c -o foo -Os -fdata-sections -ffunction-sections -Wl,--gc-sections -s
```

-s 选项剥离掉调试信息，可以进一步减小目标文件的尺寸。

References:
\[1\][Removing Unused Functions/Dead Codes with GCC/GNU-ld](https://embeddedfreak.wordpress.com/2009/02/10/removing-unused-functionsdead-codes-with-gccgnu-ld/)
\[2\][Re: Removing unused functions/dead code](http://gcc.gnu.org/ml/gcc-help/2003-08/msg00128.html)