---
title: CSS替换元素(Replaced element)
tags:
  - CSS
id: '5243'
categories:
  - - Internet
date: 2014-03-14 16:14:10
---


<!-- more -->
**替换元素**

其内容不受[CSS视觉格式化模型](https://openwares.net/internet/css_visual_formatting_model.html)控制的元素,比如image,嵌入的文档(iframe之类)或者applet,叫做替换元素。比如,img元素的内容通常会被其src属性指定的图像替换掉。替换元素通常有其固有的尺寸:一个固有的宽度,一个固有的高度和一个固有的比率。比如一幅位图有固有用绝对单位指定的宽度和高度,从而也有固有的宽高比率。另一方面,其他文档也可能没有固有的尺寸,比如一个空白的html文档。

CSS渲染模型不考虑替换元素内容的渲染。这些替换元素的展现独立于CSS。object,video,textarea,input也是替换元素,audio和canvas在某些特定情形下为替换元素。使用CSS的content属性插入的对象是匿名替换元素。

**固有尺寸**

宽度和高度是有元素自身定义的,不受周围元素的影响。CSS没有定义如何去寻找替换元素的固有尺寸。在CSS 2.1中,只有替换元素可以有固有的尺寸。对于没有可靠的解析度信息的光栅图像,必须假定一个图像源像素为一个px单位。

一些CSS属性比如vertical-align可能会用到替换元素的固有尺寸或基线。

**非替换元素**

替换元素之外的所有其他元素都是非替换元素,由CSS的视觉格式化模型负责非替换元素的渲染。

**混乱的术语**

看到有些文章中将这两种元素称作可替换元素和不可替换元素,这种叫法很明显是错误的。
首先，从w3c标准的原始定义中替换元素使用了Replaced而不是Replaceable。
其次,替换元素和非替换元素是已经被替换(CSS不负责其展示渲染,由其固有属性接管渲染)和不会被替换(由CSS负责展示渲染)，而不是可不可以被替换的概念。

References:
\[1\][Replaced element](http://www.w3.org/TR/CSS21/conform.html#w3.org:replaced-element)
\[2\][MDN:Replaced element](https://developer.mozilla.org/en-US/docs/Web/CSS/Replaced_element)

**\===
\[erq\]**