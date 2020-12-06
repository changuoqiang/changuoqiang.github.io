---
title: bash按行读取文本文件
tags:
  - Bash
id: '3999'
categories:
  - - GNU/Linux
date: 2013-11-08 19:54:56
---

bash有多种方式读取文本文件
<!-- more -->
列举几个常见的方式：

*   使用cat等外部命令
```js
OLDIFS=$IFS
IFS=''
# for in 按IFS设置分割单词，而IFS默认为为空白(空格,tab,和新行),
for line in \`cat ${file}\`
do
 echo $line
done

IFS=$OLDIFS
```
Bash使用内部域分隔符IFS(Internal Field Separator)来识别域或单词边界，$IFS 默认为空白(空格,tab,和新行),所以如果行内有空格，则会被断开单独读取。但可以修改$IFS,比如在分析逗号分隔的数据文件时
*   使用内建命令read方式一
```js
while read line
do
 echo $line
done < ${file}
```
这种方式不会生成subshell
*   使用内建命令read方式二
```js
cat ${file} while read line
do
 echo $line
done
```
这种方式会生成新的subshell,do循环是在subshell中执行的,因为要注意变量的作用域范围。subshell中对变量的操作不会影响到parent shell。

===
\[erq\]