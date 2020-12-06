---
title: vim多文件查找
tags:
  - Vim
id: '6076'
categories:
  - - Vim
date: 2014-12-08 14:43:13
---


<!-- more -->
在linux平台上,有很多优秀的shell命令组合来做多文件查找/替换,比如这些命令:find,sed,grep,awk,perl。但其他平台比如windows上就没那么方便了,这时候vim内置的多文件查找命令就有用武之地了，虽然比起外部命令来稍微慢了一点点儿。

这个vim内置命令就是vimgrep,有两种基本的使用方式：

```js
:vim\[grep\]\[!\] /{pattern}/\[g\]\[j\] {file} ...
:vim\[grep\]\[!\] {pattern} {file} ...
```

file部分支持通配符,*代表当前目录,**代表当前目录及其子目录(递归)，比如*/*.c代表当前目录下的c源程序文件,**/*.c代表当前目录及其递归子目录下的所有源程序文件。file部分可以指定多次。

g(global)是全局标志，没有g,每行只会匹配一次，如果有g,则匹配行内所有符合的pattern，也就是行可以会多次被添加到quickfix列表。
j(jump)是跳转标志，没有j，vim会跳转到第一个匹配，如果有j，则只更新

以下命令查看匹配结果：

```js
:cn\[ext\] 下一个结果
:cp\[revious\] 上一个结果
:cw\[indow\] quickfix窗口,结果文件列表
```

更详细的用法参见:help vimgrep 和下面的refs。

References:
\[1\][使用vimgrep查找文件](http://mywcd.sinaapp.com/blog/425)
\[2\][vi/vim使用进阶: 剑不离手 – quickfix](http://easwy.com/blog/archives/advanced-vim-skills-quickfix-mode/)

**\===
\[erq\]**