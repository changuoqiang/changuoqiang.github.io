---
title: 关于KWinUI的一些说明
tags:
  - KWinUI
id: '160'
categories:
  - - KWinUI
date: 2009-06-06 23:24:06
---

在KWinUI发布的文章中有些事情没有说清楚，现在补充一下。

首先是KWinUI的开发和测试环境。在开发KWinUI的最初是用的Visual C++ 2005 Express和windows platform sdk,sdk的版本记不清楚了。对于开发工具，我是有新的不用旧的。后来换到了Visual C++ 2008 Express,sdk更新到了windows sdk 6.0。为什么要用Express版本，自然是因为它是免费的，而且相当的好用，运行速度飞快。VC的编辑器我是不用的，我还是习惯用vim，所以其实主要用到的还是它的Debugger，编译、链接的话用命令行也是一样的方便。KWinUI还特别考虑到了C++ Builder系列的兼容性，因为我早年用过一段时间C++ Builder，相当不错的工具。不过我只在Turbo C++ Explore下面做过测试，除了它生成的程序体积比VC大一些以外，其他都还正常。甚至KWinUI可以与VCL混合编程，我试过。所以使用VC 2005/2008 Express加上最新的windows sdk或者Turbo C++ Explore以上版本的C++ Builder,来使用KWinUI应该都是没有问题的。

其次是关于界面设计。KWinUI是没有可视化界面设计器的，不过对于Dialog Based应用来说，这也不是很大的问题，我习惯用[ResEdit](http://www.resedit.net/)来设计界面，也是很方便的，ResEdit是一个很不错的资源编辑器，现在完全支持UNICODE，使用很简单。后面会放出几个这样的samples。后面的samples会尽量带上截图，可以更直观的看到用KWinUI做出来的程序长啥样子:)，其实不过就是标准的windows程序界面。KWinUI的程序支持系统的视觉样式也是很简单的，增加个manifest资源就可以了，关于这个网上介绍的不少。我也基于KWinUI做了一个支持程序换肤的库，不过还不太成熟，有机会可以展示一下。