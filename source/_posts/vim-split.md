---
title: Vim切分窗口(Split Window)
tags:
  - Vim
id: '4509'
categories:
  - - Vim
date: 2013-12-19 10:55:38
---

vim即可以切分窗口,也可以将窗口分页，分页以后仍然可以在页签内继续切分窗口，很强大有木有。
<!-- more -->
**启动时切分窗口**

启动时分割窗口的参数,man里是这样写的：
```js
-o\[N\] Open N windows stacked. When N is omitted, open one window for each file.
-O\[N\] Open N windows side by side. When N is omitted, open one window for each file.
```

参数小写o用于水平分割窗口
```js
$ vim -o\[N\] file1 file2 ... 
```
参数大写O用于垂直分割窗口
```js
$ vim -O\[N\] file1 file2 ... 
```
N指定分割几个窗口,如果不指定参数N,则每一个文件打开一个分割窗口。如果指定参数N，不指定file参数，则显示空白的分割窗口
,参数N不必与要打开的文件个数相同。

vimdiff命令也是以切分窗口的方式来打开文件并高亮展示文件之间的差异，vimdiff同样识别上面说过的小写o和大写O参数,同样也可以指定N,vimdiff默认以垂直切分窗口显示。
```js
$ vimdiff \[-o\[N\] -O\[N\]\] file1 file2 ... 
```

**动态切分窗口**

打开vim编辑窗口之后,仍然可以方便的按需切分窗口。

水平切分
有多个命令可以水平切分窗口,如果提供file参数,可以在新分割的窗口中显示文件内容
```js
:\[N\]sp\[lit\] \[file\]
```
```js
:\[N\]new \[file\]
```
还有一个快捷键组合
```js
\[N\]Ctrl+w s
```

垂直切分
有多个命令可以垂直切分窗口，如果提供file参数,可以在新分割的窗口中显示文件内容
```js
:\[N\]vs\[plit\]
:vert\[ical\] sp\[lit\]
```
```js
:\[N\]vne\[w\]
:vert\[ical\] new
```
还有一个快捷键组合
```js
\[N\]Ctrl+w v
```

可选参数N是一个数字,用于指定新分割窗口的大小，以行数计。

**移动光标**

要在切分窗口间移动光标,只要先按CTRL+w,然后组合vim的光标移动键h,j,k,l等就可以在窗口间移动光标

移动到左侧紧邻窗口
```js
CTRL+w h
```
移动到下面紧邻窗口
```js
CTRL+w j
```
移动到上面紧邻窗口
```js
CTRL+w k
```
移动到右侧紧邻窗口
```js
CTRL+w l
```

在窗口间依次循环切换
```js
CTRL+w w
```

移动到最顶部(top)的窗口
```js
CTRL+w t
```

移动到最底部(bottom)的窗口
```js
CTRL+w b
```

移动到前一个(previous)的窗口
```js
CTRL+w p
```

**移动窗口**

仍然需要先按CTRL+w,不过移动窗口使用大写的vim光标键H,J,K,L等。不过这里稍微有些不同，马上会看到

移动当前窗口到最左侧
```js
CTRL+w H
```
移动当前窗口到最底部
```js
CTRL+w J
```
移动当前窗口到最顶部
```js
CTRL+w K
```
移动当前窗口到最右侧
```js
CTRL+w L
```
当前窗口与下面窗口或右侧窗口进行位置交换(eXchange)。
如果当前窗口在底部，下面已经没有其他窗口，这时命令将当前窗口与上面窗口进行位置交换。
如果当前窗口在最右侧，右侧已经没有其他窗口，这是命令将当前窗口与其左侧的窗口进行位置交换。
```js
ctrl+w x
```
窗口向下进行循环(recycle)移动,这个命令可以前缀一个数字N作为参数，指明向下循环移动所执行的次数。
```js
\[N\]ctrl+w r
```
窗口向上进行循环(Recycle)移动,这个命令可以前缀一个数字N作为参数，指明向上循环移动所执行的次数。
```js
\[N\]ctrl+w R
```

**窗口大小**

调整窗口高度

增加高度,默认每次增加一行,如果指定参数N则增加N行
```js
\[N\]Ctrl+w \[N\]+
```
减少高度,默认每次减少一行,如果指定参数N则减少N行
```js
\[N\]Ctrl+w \[N\]-
```
所有窗口高度一致
```js
Ctrl+w =
```
使当前窗口调整到指定高度,如果指定参数N则调整到指定的N行高度,否则当前窗口的高度尽可能的最大。
```js
\[N\]Ctrl+w _
```

resize命令调整窗口高度。resize不带任何参数,则当前窗口的高度尽可能的最大。如果指定参数N则调整到指定的N行高度,如果指定参数N的同时使用+或者-前缀修饰,则在当前窗口高度的基础上增加或者减少N行高度。
```js
:res\[ize\] \[\[+-\]N\]
```

窗口宽度调整

增加窗口宽度,如果指定N则增加N行宽度
```js
\[N\]Ctrl+w \[N\]>
```

减少窗口宽度,如果指定N则减少N行宽度
```js
\[N\]Ctrl+w \[N\]<
```

**关闭窗口**

可以使用`ZZ`或是`:q`命令或`ctrl+w c`关闭当前窗口。

命令`ctrl+w o`可以使得当前窗口成为屏幕上的唯一(only)窗口，而其他窗口全部关闭。

References:
\[1\][VIM学习笔记 窗口(Window)](http://yyq123.blogspot.com/2009/08/vim-window.html)
\[2\][Vim的分屏功能](http://coolshell.cn/articles/1679.html)

**\===
\[erq\]**