---
title: linux下cups打印奇偶页
tags:
  - Debian
id: '6095'
categories:
  - - GNU/Linux
date: 2014-12-24 15:33:14
---


<!-- more -->
debian系统提供的打印对话框，竟然没有打印奇偶页的选项,一下命令可以满足要求：

```js
$ lp -o page-set=odd filename //只打印奇数页
$ lp -o page-set=even filename //只打印偶数页
```


References:
\[1\] [Linux下通用打印系统CUPS使用教程](http://www.xgezhang.com/linux_cups.html)