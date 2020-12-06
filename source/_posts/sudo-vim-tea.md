---
title: 忘记sudo打开vim时写当前用户没有权限更新的文件
tags:
  - Vim
id: '5978'
categories:
  - - GNU/Linux
date: 2014-10-23 21:47:16
---


<!-- more -->
有时候打开文件编辑完了才发现没有权限写当前文件,退出重新编辑？不用！vim里面调用外部命令写时使用sudo就可以了。

:w 命令如果不提供参数,则将当前缓冲区写到当前编辑的文件内，但是如果提供参数，比如
:w new_file 则将当前缓冲区内容写到新文件new_file中，其实:w命令有很多种形式
更进一步
```js
:\[range\]w\[rite\] \[++opt\] !{cmd}
Execute {cmd} with \[range\] lines as standard input
```
上面的命令形式，将range范围内的缓冲区作为标准输入调用cmd命令。

而tee命令读取标准输入，然后将其写到文件和标准输出中,在vim中%代表当前编辑缓冲区的文件名，从而有了下面的命令：
```js
:w !sudo tee %
```
但tee命令还会向standard output输出内容,可以将其重定向到/dev/null
```js
:w !sudo tee % > /dev/null
```

还可以利用cat命令来达到同样的目的：
```js
:w !sudo sh -c "cat > %"
```

 **===
\[erq\]**