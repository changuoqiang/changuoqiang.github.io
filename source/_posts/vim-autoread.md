---
title: vim自动重新加载文件内容变化
tags:
  - Vim
id: '7638'
categories:
  - - Vim
date: 2016-10-16 22:46:53
---


<!-- more -->
vim有一个选项autoread，可以自动重新读取当前正在缓冲区但其内容变化了的文件，一般来讲是因为外部程序修改了vim当前正在编辑的文件。
但是这个选项并不会自动加载变化之后的内容，只有特定的事件被触发时才会重新加载，比如执行外部命令，或者简单的执行vim内部命令:e

这一切都不是自动和实时的，所以有了这样一个插件auto_autoread.vim
下载auto_autoread.vim文件丢到~/.vim/plugin/目录下，打开一个文件，然后输入：
```js
:Autoread 1
```
这样插件会后台周期性监视文件变化，这里设定的周期是1秒，当文件内容发生变化后会自动重新读取进来。

输入：
```js
:AutoreadStop
```
停止监视文件变化。

这个功能应该由vim内部实现，vim主配置文件配置一下监视周期就好了。


References:
\[1\][auto_autoread.vim : Automatically read files when they've changed. Does what 'autoread' promises.](http://www.vim.org/scripts/script.php?script_id=5206) 
\[2\][auto_autoread.vim](https://github.com/vim-scripts/auto_autoread.vim)

**\===
\[erq\]**