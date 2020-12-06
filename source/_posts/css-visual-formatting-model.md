---
title: CSS视觉格式化模型(Visual Formatting Model)
tags:
  - CSS
id: '5261'
categories:
  - - Internet
date: 2014-03-16 21:54:41
---

CSS视觉格式化模型用于计算如何布置和渲染各种元素,是HTML页面呈现的核心模型。
<!-- more -->
视觉格式化模型是CSS核心的,基础的概念。要完全掌控页面的展示效果,了解视觉格式化模型是有必要的。

视觉格式化模型比较复杂,要完整的描述需要很多笔墨,这里只讲核心的概念,更详细的描述见参考\[1\],\[2\],\[3\]和\[4\]。

**核心概念**

对于CSS的box,有些人翻译为"框",有些人翻译为"盒",无论框还是盒都还是指的那一个box,这一点需要明确一下。

*   **块级元素,块级框,块框,块容器框,匿名块框和块格式化上下文**

**块级(block-level)元素**在页面上表现为一个块,单独占有一行,与**块格式化上下文**(Block Formatting Context)中的其他块按顺序垂直排列。浮动是一种特殊情况。当元素的CSS属性display为 block, list-item 或 table 时,它是块级(block-level)元素。

每个块级元素生成一个主要的**块级框**(Block-level box)来包含其子框和生成的内容，同时任何定位方案都会与这个主要的框有关。某些块级元素还会在主要框之外产生额外的框：例如“list-item”元素。这些额外的框会相对于主要框来放置。

除了table框和替换元素块级框,一个块级框可能也是一个**块容器框**(block container box)。块容器框只包含其他块级框,或者创建一个行内格式化上下文(inline formatting context)从而只包含行内框。

同时是块容器框的块级框称为**块框**(block boxes)。并非所有的块容器框都是块级框：非替换的行内块和非替换的table cell也是块容器但不是块级框。

有时需要添加补充性盒，这些盒称为**匿名块框**(anonymous box), 它们没有名字，不能被 CSS 选择符选中。不能被 CSS 选择符选中意味着不能用样式表添加样式。这意味着所有继承的 CSS 属性值为 inherit ，所有非继承的 CSS 属性值为 initial 。比如下面一段HTML会生成两个匿名块框,在div内部但在p外部的文本会被匿名块框包裹。
\[html\]
<div>Some inline text <p>followed by a paragraph</p> followed by more inline text.</div>
\[/html\]

块格式化上下文BFC包含一组相关的块框,这些块框在同一个BFC内按预定规则进行排列。

*   **行内级元素,行内级框,行内框,行框,匿名行级框和行格式化上下文**

当元素的CSS属性display的计算值为 inline, inline-block 或 inline-table 时，称它为**行内级(inline-level)元素**。行内级元素与其他行内级元素共享行。行内级元素生成**行内级框**(inline-level box),同时参与生成**行内格式化上下文**(inline formatting context)的行内级框称为**行内框**(Inline boxes)，因此，行内框是行内级框的一种。那些不是行内框的行内级框(例如替换的行级元素、行内块元素、行内表格元素)被称为**原子行内级框**(atomic inline-level box),因为它们是以单一不透明框的形式来参与其行格式化上下文,原子行内级框在行内格式化上下文IFC里不能分成多行。

**匿名行内框**(Anonymous inline boxes)类似于块盒，CSS引擎有时自动生成行内框。这些框也是匿名的，因为它们没有对应的选择器名字。它们继承所有可继承的属性，非继承的属性取 initial。 匿名行内框最常见的例子是块框直接包含文本，文本将包含在匿名行内框中。

**行框**(Line boxes)由行内格式化上下文(inline formatting context)产生的框，用于表示一行。在包含块里面，行框从包含快一边排版到另一边。 当有浮动时, 行框从左浮动的最右边排版到右浮动的最左边。行框是行内框的容器,类似于块容器框是块框的容器。

行内格式化上下文IFC包含一组相关的行内框,这些行内框在同一个IFC内按预定规则进行排列。

*   **堆叠上下文**

单纯的z-index并不能最终决定元素在Z轴上的排列顺序,还要关系到**堆叠上下文**(stacking context)。堆叠上下文的优先级要高于z-index。也就是z-index值很大也不一定能排列到Z轴的前面,还要先看所处的堆叠上下文。参考\[4\]对此问题描述的比较详细清楚。

**块格式化上下文(BFC),行格式化上下文(IFC)和堆叠上下文(SC)都有不同的产生条件和时机**,具体请参考其他文档。

\[1\]MDN:[视觉格式化模型](https://developer.mozilla.org/zh-CN/docs/CSS/Visual_formatting_model)
\[2\]w3.org:[视觉格式化模型](http://www.w3.org/html/ig/zh/wiki/CSS2/visuren)
\[3\]MDN:[The stacking context](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Understanding_z_index/The_stacking_context)
\[4\][关于z-index的那些事儿](http://www.html5kit.com/article/777.html)

**\===
\[erq\]**