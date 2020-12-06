---
title: 软件开发文档管理
tags: []
id: '4447'
categories:
  - - Misc
date: 2013-12-10 10:49:36
---

软件开发文档是软件质量保证的重要一环，所有软件开发文档都应该纳入版本管理之中。
<!-- more -->
这里分为两类文档来讨论，一种是与源代码一起书写的文档，另一种是单独撰写的文档。

**代码中的注释和API(接口)文档**

这种类型的文档一般语言层面上都有专门的文档生成工具，比如java有javadoc,javascript有jsdoc,python也有自己的文档注释标准和文档生成工具。只要按照语言的注释文档规范书写文档即可。

数据库设计文档也应该从sql建库脚本中自动生成,只要自定义一些注释标签，然后使用工具自动生成即可。已经在使用自定义的标签书写sql建库脚本，下一步会开发sqldoc工具来自动生成数据库设计文档。

还有大名鼎鼎的文档生成工具[Doxygen](http://www.doxygen.org/)，可以处理绝大多数语言的注释文档。

注释文档的好处是比较容易同步，修改代码时可以比较方便的同步修改文档。而且文档与代码一起纳入版本库管理。

**单独撰写的文档**

单独撰写的文档也有很多，比如用户需求规格说明书，系统概要设计，系统详细设计，用户使用手册，测试文档等。这些也应该纳入版本库统一管理。

这些文档最好不要使用专有的文档格式撰写，而且要采用文本格式，而不是二进制格式，方便进行版本管理。

LaTeX是很专业的排版软件，可以用于撰写软件开发文档，但显然有些过于重量级了，比较复杂，有学习曲线，而且有大材小用之嫌。而Markdown则语法简单，功能不弱，适合开发文档的撰写，而且很容易纳入git版本库进行管理。

Mac下有一个很不错的Markdown编辑软件叫做[Mou](http://mouapp.com/)。
vim也可以找到很多的Markdown语法高亮和[实时预览](http://howiefh.github.io/2013/05/16/vim-markdown-preview/)插件。
还有一个好玩的基于git仓库的使用Markdown语法的wiki系统[gitit](http://gitit.net/)。

使用Markdown撰写的文档，后期可以通过[pandoc](http://johnmacfarlane.net/pandoc/)输出到其他多种交换格式，比如html5,LaTex，PDF(via LaTeX)等。
Markdown语法十分简单，五分钟入门够了。语法可以看[献给写作者的 Markdown 新手指南](http://jianshu.io/p/q81RER)，[Markdown](http://zh.wikipedia.org/wiki/Markdown),[Markdown语法说明](http://markdown.tw/)和[Markdown 语法说明 (简体中文版)](http://wowubuntu.com/markdown/) 。
这里还有两篇Markdown和LaTeX结合的文章，[用markdown来写LaTeX](http://blog.yesmryang.net/markdown-latex/)和[Markdown写作浅谈](http://jianshu.io/p/PpDNMG)

Markdown的[老家](http://daringfireball.net/projects/markdown/)。

**详细设计文档与注释(API/接口)文档**

详细设计文档撰写应该早于编码进行，是编码的指导性文件。

详细设计文档提供模块设计上的考虑、核心决策，包括模块与概要(总体)设计的关系、重要操作的处理流程、重要的业务规则设计、采用的核心算法等等信息，提供了对模块设计的概述性信息。详细设计宜使用一些图表来更直观的表达设计意图。

详细设计文档也不要过细，一些十分细节的设计问题应该放到代码文档注释中。详细设计文档的粒度应该介于概要(总体)设计和文档注释之间。