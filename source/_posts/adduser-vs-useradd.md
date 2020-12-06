---
title: adduser和useradd的区别
tags: []
id: '6610'
categories:
  - - GNU/Linux
date: 2015-08-29 14:56:53
---


<!-- more -->
man useradd里有一句话:

useradd is a low level utility for adding users. On Debian, administrators should usually use adduser(8) instead

也就是说useradd是一个低层次的用户添加工具，适合高阶用户使用，而在简单的场合适合使用adduser来添加用户，adduser添加用户时系统有step by step的用户提示来交互时的添加用户，使用比较简单，无需指定复杂的命令行选项。

那么说，**useradd适用于非交互式场景**，比如在脚本中创建用户，而**adduser更适用于交互式场景**。

**\===
\[erq\]**