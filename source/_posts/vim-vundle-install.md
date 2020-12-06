---
title: 安装vim插件管理器vundle
tags:
  - Vim
id: '2976'
categories:
  - - Vim
date: 2013-05-27 14:36:31
---

[vundle](https://github.com/gmarik/vundle)可以自动管理vim插件，从自动下载安装到更新
<!-- more -->
**安装**
$ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

Cloning into '/home/${username}/.vim/bundle/vundle'...
remote: Counting objects: 2456, done.
remote: Compressing objects: 100% (1587/1587), done.
remote: Total 2456 (delta 831), reused 2385 (delta 776)
Receiving objects: 100% (2456/2456), 296.68 KiB 49 KiB/s, done.
Resolving deltas: 100% (831/831), done.

**配置**
编辑~/.vimrc
```js
set nocompatible " be iMproved
filetype off " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
"使用vundle插件管理器管理自身
Bundle 'gmarik/vundle'

"vundel管理的插件，有三种类型
" My Bundles here:
"
"第一种为github上的插件
" original repos on github
"Bundle 'tpope/vim-fugitive'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
"Bundle 'tpope/vim-rails.git'

"这是我要安装的html5语法高亮,自动缩进和自动完成插件
Bundle 'othree/html5.vim'

"第二种为普通的脚本插件
" vim-scripts repos
"Bundle 'L9'
"Bundle 'FuzzyFinder'

"第三种为非github上的git 仓库
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...

filetype plugin indent on " required!

"使用说明
" Brief help
" :BundleList - list configured bundles
" :BundleInstall(!) - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!) - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
```
**安装插件**
打开vim,输入:BundleInstall即自动安装配置的插件，插件全部安装到~/.vim/bundle目录下