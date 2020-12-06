---
title: while read line无法读取最后一行的问题
tags:
  - Bash
id: '5754'
categories:
  - - GNU/Linux
date: 2014-08-02 17:33:59
---


<!-- more -->
while read line读取文件时，如果文件最后一行之后没有换行符\\n,则read读取最后一行时遇到文件结束符EOF,循环终止,虽然此时$line内存有最后一行,但程序已经没有机会再处理此行,因此可以通过以下代码来解决此问题:

```js
while read line \[\[ -n ${line} \]\]; do
...
done
```
这样当文件没有结束时不会测试-n $line,当遇到文件结束时,仍然可以通过测试$line是否有内容来进行继续处理。

**\===
\[erq\]**