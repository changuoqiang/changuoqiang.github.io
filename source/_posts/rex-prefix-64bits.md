---
title: 64位运算中的REX指令前缀
tags: []
id: '221'
categories:
  - - Misc
date: 2009-06-28 12:10:16
---

64bits CPU引入了REX指令前缀。
REX前缀的主要功能有以下几点：

*   指定通用寄存器和SSE寄存器，当然主要是来指定扩展的寄存器，如R8-R15寄存器等
    
*   指定64位操作数
    
*   指定扩展控制寄存器
    

一直以来都不知道这个REX缩写词是由哪个或哪几个单词缩写来的，今天突然想明白了，REX应该就是Register EXtension，因为REX的主要功能就是用来索引扩展寄存器的。

关于REX前缀更详细的介绍，请参考[Intel® 64 and IA-32 Architectures Software Developer’s Manuals](http://www.intel.com/products/processor/manuals/)