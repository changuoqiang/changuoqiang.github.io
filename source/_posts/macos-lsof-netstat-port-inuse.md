---
title: macos显示占用端口的应用程序
tags: []
id: '9111'
categories:
  - - GNU/Linux
date: 2020-01-26 16:49:38
---


<!-- more -->
macos版本的netstat并不支持-p选项以显示打开端口的应用程序，可以使用lsof(list open files)来达到同样的目的

```js
$ sudo lsof -nP -iTCP -sTCP:LISTEN
```

References:
\[1\][使用 lsof 代替 Mac OS X 中的 netstat 查看占用端口的程序](https://tonydeng.github.io/2016/07/07/use-lsof-to-replace-netstat/)