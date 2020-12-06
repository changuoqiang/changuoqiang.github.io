---
title: 用vim来解决wordpress的代码高亮和缩进
tags:
  - Vim
id: '110'
categories:
  - - Vim
date: 2009-06-05 22:40:11
---

因为要经常在post中贴一些代码出来，为了美观，安装了WP-Syntax插件来高亮代码，但是wordpress的visual编辑器实在是太逊了，经常把整齐的代码搞的一团糟，虽然有语法高亮，但是仍然惨不忍睹。

终于再无法忍受，寻觅其他解决的办法。平时编辑代码都是用vim的，突然想到vim有一个功能可以把编辑的文本转换为HTML格式，这不正是我想要的吗！vim的语法高亮能力可不是一般的强悍，用vim编辑代码那可是相当的舒适。

终于可以抛弃wordpress的visual编辑器了。在vim里面执行:TOhtml就可以把当前编辑的文本转换为HTML页面，转换结果相当的好，也可以用：m,nTOhtml把一个范围内的文本转换为html。

因为我的vim用的自己修改的desert256配色方案，背景是黑色的，所以转换出来的html在白色背景下略显刺眼。

**UPDATE:**
最新版的vim默认使用CSS来生成html代码,这样嵌入wordpress会有问题,可以在~/.vimrc文件里面设置变量关闭CSS来解决问题

:let g:html_use_css=0