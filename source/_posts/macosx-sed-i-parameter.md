---
title: macosx sed的-i参数
tags:
  - mac
id: '8511'
categories:
  - - Misc
date: 2019-07-09 21:20:24
---


<!-- more -->
macosx上自带的很多命令行工具都是bsd版本的，包括sed

sed的参数-i与gnu版本稍有不同,其-i参数后面的备份文件扩展名不可省略，即使是空字符串，也就是不要备份，而gnu版本不要备份的话是可以忽略掉的。
bsd版本：
```js
$ sed -i '' 's/123/456/' test
```

gnu版本：
```js
$ sed -i 's/123/456/' test
```