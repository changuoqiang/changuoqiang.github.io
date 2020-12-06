---
title: git恢复删除的文件
tags:
  - Git
id: '4605'
categories:
  - - GNU/Linux
date: 2013-12-31 15:22:21
---


<!-- more -->
如果在当前工作区删除了文件,又想恢复回来,可以这样:
```js
$ git checkout -- filename
```
如果删除了一批文件想恢复回来,可以这样:
```js
$ git ls-files --deleted xargs git checkout --
```
其中git ls-files --deleted是列出所有被删除的文件。