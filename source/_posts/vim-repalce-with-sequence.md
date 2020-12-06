---
title: 'vim技巧两则:使用数字序列替换匹配的pattern和插入数字序列'
tags: []
id: '8016'
categories:
  - - uncategorized
date: 2018-11-22 15:13:57
---


<!-- more -->
**使用数字序列替换**

vim查找替换时，可以使用一个数字序列来替换匹配的内容
```js
:let i=1 \[range\]g/PATTERN/s//\\=i/g let i=i+1
```

**插入数字序列**

```js
:put =range(11,15)
```
可以在文件当前行后插入５行:
```js
11
12
13
14
15
```

**函数式替换**

在替换命令 s/// 中可以使用函数表达式来书写替换内容，格式为

```js
:s/替换字符串/\\=函数式
```

在函数式中可以使用 submatch(1)、submatch(2) 等来引用 \\1、\\2 等的内容，而submatch(0)可以引用匹配的整个内容。

举个栗子，将文件从第一行开始的行首替换为如下样式：
```js
mem\[0\]=
mem\[1\]=
mem\[2\]=
...
```

可以执行如下替换：

```js
:%s/^/\\='mem\['.(line(".")-1).'\]='
```

References:
\[1\][Making a list of numbers](http://vim.wikia.com/wiki/Making_a_list_of_numbers)
\[2\][vi/vim的巧妙使用-数值加减,递增,序列等](https://blog.csdn.net/hylaking/article/details/80270763)