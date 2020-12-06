---
title: git查看每行代码的作者
tags:
  - Git
id: '6093'
categories:
  - - GNU/Linux
date: 2014-12-24 08:40:42
---


<!-- more -->
git blame 命令用于Show what revision and author last modified each line of a file
直接
```js
$ git blame filename
```

或者用git log命令
```js
$ git log -p filename
```
然后搜索一下吧

 **===
\[erq\]**