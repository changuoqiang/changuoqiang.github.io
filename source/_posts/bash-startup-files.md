---
title: Bash启动文件(startup files)
tags:
  - Bash
id: '593'
categories:
  - - GNU/Linux
date: 2009-11-07 10:44:03
---

如果任何一个启动文件存在，但不能读取，Bash会报告一个错误。
<!-- more -->
*   **做为一个交互式登录shell被调用，或者带有`--login`选项**
当Bash做为一个交互式登录shell被调用，或者做为一个非交互式登录shell被调用但带有- -login选项，如果/etc/profile文件存在，Bash首先读取这个文件来执行命令。读完这个文件后，Bash按顺序查找~/.bash_profile,~/.bash_login和~/.profile文件，并从第一个存在且可读的文件读取执行命令。当shell启动时可以使用参数- -noprofile来禁止这种行为。
当一个登录Shell退出,如果文件~/.bash_logout存在，Bash读取并执行其中的命令。
*   **做为一个交互式非登录shell被调用**
如果~/.bashrc文件存在，Bash读取该文件并执行其中的命令。通过使用`--norc`选项可以禁止读取该文件。
- -rcfile选项则可以强制Bash读取指定的文件而不是~/.bashrc。
因此，典型地，你的~/.bash_profile在任何登录相关的初始化之前或之后会包含下面的行
```js
if \[ -f ~/.bashrc \]; then 
 . ~/.bashrc; 
fi
```

*   **做为非交互式shell被调用**
当Bash做为一个非交互式shell被调用，比如执行一个shell脚本,它查找环境变量BASH_ENV,如果该变量存在，Bash使用变量扩展后的值做为文件名来读取并执行其中的命令。Bash的行为类似于执行以下命令
```js
if \[ -n "$BASH_ENV" \]; then 
 . "$BASH_ENV";
fi
```
但是Bash并不使用环境变量PATH的值来搜索这个文件。
*   **做为sh被调用**
如果Bash以sh的名字被调用，在遵循POSIX标准的同时，它尝试尽可能接近的模仿sh历史版本的启动行为。
当做为交互式登录shell或带`--login`选项的非交互式登录shell被调用时，它首先尝试按顺序读取/etc/profile和~/.profile文件并执行命令。
`--noprofile`选项可以用来禁止这种行为。当Bash以sh的名字做为交互式登录shell被调用时，Bash查找ENV环境变量，如果变量被定义，就扩展变量，并以扩展后的值做为文件名来读取执行命令。因为以名字sh调用的shell不再尝试任何其他的启动文件，因此`--rcfile`是无效的。以名字sh调用的非交互式登录shell不再读取其他任何启动文件。
当做为sh被调用时，启动文件读取完毕后,Bash进入POSIX模式。
*   **以POSIX模式被调用**
当Bash带有`--posix`命令行选项，以posix模式启动时，Bash遵循POSIX启动文件标准。在这种模式下，交互式shell扩展ENV环境变量，并以扩展后的变量值为文件名做为启动文件读取并执行命令。不再读取其他文件。
*   **被远程shell守护程序调用**
Bash尝试去侦测当被调用时它的标准输入是否绑定到一个网络连接，比如通过远程shell守护进程(remote shell daemon)rshd，或者安全shell守护进程(secure shell daemon)sshd。如果正是通过这种方式被调用，那么Bash从~/.bashrc读取并执行命令，只要~/.bashrc文件是存在并且是可读的。如果被当作sh调用则不会这样做。`--norc`选项参数可以用来禁止这种行为，`--rcfile`选项可以强制使用另一个启动文件，但是rshd不支持这两个选项。
*   **在有效uid/gid不等于实际uid/gid的情况下被调用**

如果Bash在有效uid(gid)不等于实际uid(gid)的情形下启动，并且没有指定-p选项，那么Bash不会读取启动文件，不从环境继承shell功能，忽略SHELLOPTS环境变量,有效uid设置为实际uid。如果调用时指定了-p选项，启动行为是相同的，除了不会重设有效uid。

**\===
\[erq\]**