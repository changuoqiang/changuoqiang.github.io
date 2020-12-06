---
title: mac系统中文件的@权限
tags:
  - mac
id: '5405'
categories:
  - - Misc
date: 2014-04-19 22:31:28
---


<!-- more -->
如果文件或目录有扩展属性,则使用-l选项执行ls命令时，会在权限许可字段后面附加一个字符@。
如果文件或目录有扩展安全信息，则使用-l选项执行ls命令时，会在权限许可字段后面附件一个字符+。

> If the file or directory has extended
> attributes, the permissions field printed by the -l option is followed by
> a '@' character. Otherwise, if the file or directory has extended secu-
> rity information, the permissions field printed by the -l option is fol-
> lowed by a '+' character.

详见man ls(1) on Max OS X

**\===
\[erq\]**