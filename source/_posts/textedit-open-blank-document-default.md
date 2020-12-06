---
title: TextEdit默认打开空白文档
tags: []
id: '8035'
categories:
  - - Misc
date: 2018-11-25 10:05:09
---


<!-- more -->
打开TextEdit时提示选择或者新建文件对话框，挺烦人的，用下面的命令可以关闭这一特性，让TextEdit直接打开新文档

```js
$ defaults write -g NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false
```

还原命令：

```js
$ defaults delete -g NSShowAppCentricOpenPanelInsteadOfUntitledFile
```