---
title: Vim TaskList插件
tags:
  - Vim
id: '5710'
categories:
  - - Vim
date: 2014-07-31 16:36:12
---


<!-- more -->
Eclipse神马的都支持任务列表,vim也可以。有一个插件叫[TaskList](http://www.vim.org/scripts/script.php?script_id=2607)就是做这个事的,它使用与eclipse一样的语法，写FIXME,TODO或者XXX就可以了。

安装很简单，下载插件扔到plugin目录就可以了，比如 ~/.vim/plugin目录。

输入命令`:TaskList`调用任务列表窗口,按q退出窗口

.vimrc文件为TaskList映射快捷键:
```js
map t :TaskList<CR>
```

然后按t进入任务列表，按q退出就可以了。

**\===
\[erq\]**