---
title: vundle安装配置
tags:
  - Vim
id: '6642'
categories:
  - - Vim
date: 2015-09-17 09:46:45
---


<!-- more -->
Vundle接口发生了变化，配置不太一样了

**安装**

```js
$ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

**配置**

~/.vimrc文件添加:

```js
""""""""""""""""""""""""""""""""""""""""""""""""
" vundle
""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible " be iMproved, required
filetype off " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Avoid a name conflict with L9
Plugin 'user/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end() " required
filetype plugin indent on " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList - lists configured plugins
" :PluginInstall - installs plugins; append \`!\` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append \`!\` to refresh local cache
" :PluginClean - confirms removal of unused plugins; append \`!\` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
```

**用法**

```js
:PluginList // 列出.vimrc文件中配置的插件
:PluginInstall // 安装插件
:PluginInstall! // 跟新插件
:PluginUpdate //　更新插件
:PluginSearch foo // 搜索插件,后面附加!号刷新本地缓存
:PluginClean // 清理不使用的插件
```

**命令行安装插件**
```js
$ vim +PluginInstall +qall
```

References:
\[1\][Vundle](https://github.com/VundleVim/Vundle.vim)

**\===
\[erq\]**