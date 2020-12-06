---
title: 动态设置xterm标题
tags:
  - Debian
id: '6546'
categories:
  - - GNU/Linux
date: 2015-07-28 13:31:25
---


<!-- more -->
xterm终端窗口默认标题都是一样的。经常开很多终端窗口，虽然已经设置了命令行提示符，但如果标题栏也能反应出xterm的当前状态就更好了。

**更改标题栏**

可以使用xterm的转义序列更改窗口的title

*   ESC\]0;stringBEL — Set icon name and window title to string
设置图标化名字(窗口最小化时)和窗口标题
*   ESC\]1;stringBEL — Set icon name to string
设置图标化名字
*   ESC\]2;stringBEL — Set window title to string
设置窗口标题

where ESC is the escape character (\\033), and BEL is the bell character (\\007)
此处，ESC是转义字符`\033`,BEL是bell字符`\007`

因此在.bashrc中添加如下行，让xterm标题栏显示当前的主机名和用户名以及当前路径信息:

```js
PROMPT_COMMAND='echo -ne "\\033\]0;${USER}@${HOSTNAME}\[\`basename ${PWD}\`\]\\007"'
```

**ssh登录时更改标题栏**

ssh登录时，xterm窗口应该显示当前所在的远程主机和在远程主机上的当前用户以及路径信息，只要在远程主机的bashrc文件中包含同样的行就可以了。

**终端vim标题栏**

在终端下使用vim时，默认会修改xterm的标题栏，但是没有主机和用户信息，在~/.vimrc中添加如下：
```js
let &titlestring=$USER."@".hostname().": %t%M(%F)"
set title
```

更多符号的含义请
```js
:help titlestring
:help statusline
```


References:
\[1\][Automatically set screen title](http://vim.wikia.com/wiki/Automatically_set_screen_title)

**\===
\[erq\]**