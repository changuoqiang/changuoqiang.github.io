---
title: vim折叠
tags:
  - Vim
id: '4218'
categories:
  - - Vim
date: 2013-11-19 16:49:21
---

vim支持文本折叠,将多行文本折叠到一行显示，并提供折叠起来的多行文本的预览。通过折叠，可以更容易明白整个文档的结构。
一个折叠就相当于文档中的一个小节。
<!-- more -->
**vim支持6种折叠方式：**

*   manual
手工定义折叠
*   indent
根据缩进定义折叠，更多的缩进代表更高的折叠级别
*   expr
通过一个表达式定义折叠
*   syntax
通过语法高亮定义折叠
*   diff
折叠未改变的文本，在使用vimdiff或diffsplit等时，就自动采用这种折叠方式
*   marker
通过文本中的标记定义折叠

**设置折叠方式**

通过命令
:set foldmethod=manual
或配置文件中
set foldmethod=manual
来设置折叠方式，默认为手工折叠方式。当比较文本时默认采用diff折叠模式。

**手工折叠命令**

所有的折叠命令都以z开头，官方文档说，"从一边看，z就像一张折叠起来的纸",这样方便记忆，还有可以将z理解为zip,也有压缩之意。

*   zf
创建折叠
记忆法: zf stands for "F-old creation"

命令格式为：
zf{motion} 或者 {Visual}zf

{motion}是指移动光标位置的命令，{Visual}指可视模式,比如:
zf10j 折叠当前光标开始向后的10行，因为10j是光标向后移动10行
zf9G或zf9gg 折叠当前光标和第9行之间的行，因为9G或9gg移动光标到第9行
8zf 将当前行及之后的8行折叠起来，因为8是光标向后移动8行

zfa命令(可以这样记忆，zf at *)

将光标放置到(,{,\[,<等字符上，然后执行
zfa(,zfa{,zfa\[,zfa<
等命令，就可以将(),{},\[\],包围的文本折叠起来

zfap将光标所在的段落(paragraph)折叠起来,一般前后有空行的一段文本称为段落。 zfap可以这样记忆，zf at paragraph
*   :{range}fo\[ld\]
在行范围内创建折叠。比如
:10,20fo 在第10行到20行之间创建折叠
*   zo
打开折叠
zp stands for "O-pen a fold"
*   zc
关闭折叠
zc standsfor "C-lose a fold"
*   za
在当前折叠上循环打开、关闭折叠(toggle)
当在一个关闭的折叠上，打开这个折叠；
当在一个打开的折叠上，关闭这个折叠，并设置'foldenable'属性
*   zA
在当前嵌套的折叠上循环打开、关闭折叠(toggle)
当在一个关闭的折叠上，打开所有嵌套的折叠
挡在一个打开的折叠上，关闭所有嵌套的折叠，并设置'foldenable'属性
*   zr
打开所有折叠
zr stands for "R-educe the folding"
*   zm
关闭所有折叠
zm stands for "folds M-ore"
*   zR
一次全部打开嵌套的折叠
zR stands for "R-educes folds until there are none left"
*   zM
关闭所有折叠和嵌套的折叠
zM stands for "folds M-ore and M-ore"
*   :{range}foldo\[pen\]\[!\]
打开指定行范围内的折叠，如果没有指定\[!\]只打开一层折叠
*   :{range}foldc\[lose\]\[!\]
关闭指定行范围内的折叠，如果没有指定\[!\]只关闭一层折叠
*   zn
禁止折叠
zn stands for "no foldenable"
*   zN
启用折叠
zN stands for "NO NO foldenable"
*   zi
在zn和zN之间循环
zi stands for "Invert foldenable"
*   zd
删除当前光标下的一个折叠
zd stands for "delete fold"
*   zD
删除光标下的所有嵌套的折叠
zD stands for "Delete more folds"
*   zE
删除当前窗口的所有折叠
zE stands for "Eliminate all folds in the window"
*   \[z
移动到当前打开折叠的最开始处
*   \]z
移动到当前打开折叠的最后
*   zj
移动到一下个折叠的开始处
*   zk
移动到上一个折叠的结束处
*   :\[range\]foldd\[oopen\] {cmd}
在所有非关闭折叠的行或行范围\[range\]内执行命令{cmd}
*   :\[range\]folddoc\[losed\] {cmd}
在关闭折叠的所有行或行范围\[range\]内执行命令{cmd}

**保存折叠**
Vim不自动记忆手工折叠。使用以下命令，来保存当前的折叠状态：

:mkview

下次打开文档时，使用下面的命令，来载入记忆的折叠信息：

:loadview

**其他折叠方式及相关命令见vim doc**