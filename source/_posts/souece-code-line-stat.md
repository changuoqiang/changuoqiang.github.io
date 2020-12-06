---
title: 一条命令统计源代码行数
tags: []
id: '6248'
categories:
  - - GNU/Linux
date: 2015-03-30 09:51:09
---


<!-- more -->
一条命令统计源代码行数
```js$ find . -name "*.java" -or -name "*.js" xargs wc -l sort -g```

只输出总行数:
```js
$ find . -name "*.java" xargs wc -l sort -g grep 'total' awk '{print $1}'
```

去空行版:
```js$ find . -name "*.java" xargs grep -v "^$" wc -l ```

**\===
\[erq\]**