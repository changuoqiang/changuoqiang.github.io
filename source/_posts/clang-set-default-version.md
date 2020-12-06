---
title: 多clang环境设置默认clang版本
tags: []
id: '8044'
categories:
  - - uncategorized
date: 2018-11-26 12:38:55
---


<!-- more -->
debian当前源内的clang版本为3.8，backport源里的版本为6.0

设置默认版本为6.0:

```js
$ sudo update-alternatives --install \\
/usr/bin/clang++ clang++ /usr/lib/llvm-6.0/bin/clang++ 100
$ sudo update-alternatives --install \\
 /usr/bin/clang clang /usr/lib/llvm-6.0/bin/clang 100
```