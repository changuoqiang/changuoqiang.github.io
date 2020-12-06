---
title: 'TeX,LaTeX,TexLive与LyX'
tags: []
id: '4436'
categories:
  - - Misc
date: 2013-12-02 21:40:17
---

简单记叙这几者的关系
<!-- more -->
TeX是高爷爷(Donald.E.Knuth)为了他的巨著The Art of Computer Programming写的排版软件，在学术界十分流行，主要用于写学术论文和书籍。TeX发音类似"泰赫"。

LaTex基于Tex,LaTeX使用TᴇX作为它的格式化引擎，当前的版本是LaTeX2e。LaTex发音类似于"雷泰赫"。

> 其实世界上只有一个TeX程序，它就叫做 "tex", 它是由 D. E. Knuth 设计并且实现的。TeX 不仅是一个排版程序，而且是一种程序语言。LaTeX 就是用这种语言写成的一个“TeX 宏包”，它扩展了 TeX 的功能，使我们很方便的逻辑的进行创作而不是专心于字体，缩进这些烦人的东西。TeX 还有其它的大型宏包，它们和 LaTeX 一起 都被叫做 "format"，现在还有一种常用的format叫做 ConTeXt, 用 它能方便的作出漂亮的幻灯片，动态屏幕文档…… 我们通常用 TeX 都是在用 LaTeX, ConTeXt, 因为 TeX 的底层需要更多的知识才 能了解，一般人不需要自己设计自己的格式。

TeXLive是一个跨平台LaTeX分发版，是一个LaTeX安装编译包。就像Debian之于Linux。

LyX是一个所见即所得的LaTex可视化编辑器。在Debian系统上,LyX正依赖于LaTex的分发版TeXLive。

参考：
[TeX — Beauty and Fun](http://docs.huihoo.com/homepage/shredderyin/tex_frame.html)