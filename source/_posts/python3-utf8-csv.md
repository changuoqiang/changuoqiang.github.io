---
title: python3输出utf-8编码的csv文件
tags: []
id: '7164'
categories:
  - - GNU/Linux
date: 2016-01-29 13:34:26
---


<!-- more -->
如果有中文字符，并且输出的csv文件没有BOM标志，M$ Excel打开会出现乱码。所以输出utf-8编码的csv时，为了兼容性要输出BOM.
很简单，只要在open函数中指定文件编码即可，无需额外的操作：
```js
with open('foobar.csv', 'w', encoding='utf-8-sig') as f:
 ...
```

因为指定的编码为utf-8-sig,sig就是signature,所以不但文件的编码为utf-8格式，同时还会自动输出utf-8的BOM标志0xEFBBBF。这样生成的csv可用用M$ Excel正确打开导入。

或者更简单点儿，指定encoding为'gb18030'。

References:
\[1\][UTF8最好不要带BOM，附许多经典评论](http://www.cnblogs.com/findumars/p/3620078.html)

**\===
\[erq\]**