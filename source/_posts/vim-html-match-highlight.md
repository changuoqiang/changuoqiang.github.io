---
title: vim插件之html标签匹配与高亮
tags:
  - HTML
  - Vim
id: '3142'
categories:
  - - Vim
date: 2013-06-12 21:49:50
---

vim默认通过%命令可以匹配(),{},等符号
<!-- more -->
但无法对html标签进行匹配，也无法高亮匹配的标签对。当然可以通过插件来实现这些功能，[MatchIt](http://www.vim.org/scripts/script.php?script_id=39)扩展%命令来支持匹配html标签对，[MatchTag](https://github.com/gregsexton/MatchTag)可以高亮匹配的标签对。

**安装MatchIt**

下载后在~/.vim目录下解压，生成两个文件,一个是插件~/.vim/plugin/matchit.vim，另一个是文档~/.vim/doc/matchit.txt

~/.vimrc中添加
:filetype plugin on 

然后在vim中执行命令
:source ～/.vim/plugin/matchit.vim
或者重启vim
就可以使用%命令在标签对之间跳转了。

使用命令
:helptags ~/.vim/doc 
重建本地帮助文件，然后

:help matchit
可以查看matchit的帮助文件

**安装MatchTag**
直接将下载到的html.vim放到~/.vim/ftplugin/目录下即可
这个插件是file type plugin，所以需要放到ftplugin目录下
之后可以自动高亮匹配的标签对，但只限可视范围之内的标签对。