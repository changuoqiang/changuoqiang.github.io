---
title: FlexBox布局模型
tags:
  - CSS
id: '5144'
categories:
  - - Lang
date: 2014-03-03 22:27:32
---


<!-- more -->
一直以来我们都是使用float,position还有早期的table来做页面布局。现在几乎没有人会用table布局了,但float和position仍然是布局的中坚力量。

虽然table,float,position可以用来布局, 但它们都不是布局元素,只是用它们来做布局比较方便罢了。这都是trick。

float的本意是图文混排时的环绕,而position则用于针对单个元素的定位,table则用于展示表格。不过运用一些巧妙的手段(所以叫做trick)可以做到页面布局而已。
但无疑这种布局方式是繁琐的,要经过复杂的计算,填各种浏览器的各种坑,最后得到的布局极有可能自适应性也是很差的。

那么什么叫布局(layout)呢?布局关心的不是单个的元素,布局着眼于如何从整体上划分页面,让划分后页面的各个部分自然的相互联系在一起。如果布局容器的尺寸发生变化,其子页面通过重排会自动的适应这种变化,无需任何额外的计算。设计布局时只要指定好布局的各项属性就可以了。

其实布局管理器的概念在桌面开发中已经出现了好多年了,比如java,gtk等都有各种可用的布局管理器。这二者的概念是比较相近的。

那么为什么要用table,float和position等来做布局呢？因为在以往没有其他更好的选择。但是现在不一样了,最新的CSS标准提供了几个真正的布局模块。其中当前已经可用的而且十分好用的是flex伸缩布局(Flexible Box Layout)。

flex伸缩布局已于09/18/2012进入CR(Candidate Recommendation)状态,当前各大浏览器对flex布局的支持已经基本上十分完善。IE10使用旧版的flex语法,
firefox要到版本28才支持flex多行布局,也就是支持flex-wrap属性的wrap和wrap-reverse。safari还在使用浏览器前缀-webkit-,opera则完整的支持最新的语法。firefox 28差不多两周就可以发布了。如果不考虑那些老旧的、到处是坑的IE浏览器,现在已经可以正式的使用flex布局了。拥抱标准,大胆的抛弃那些“上古神兵”吧！

**flex伸缩布局**

**基础概念**

*   布局轴线
传统上，行内布局采用水平轴,而块布局使用垂直轴。flex伸缩布局使用了完全不同的概念。flex采用主轴(main axis)和侧轴(cross axis)来管理布局,而且主轴和侧轴的方向并不是固定的。看下面的两张图:
![flex axis](http://www.w3.org/html/ig/zh/wiki/images/b/bf/Flex-direction-terms-new.zh-hans.png)
![flex axis](https://developer.mozilla.org/files/3739/flex_terms.png)
主轴有可能是水平的也有可能是垂直的,而侧轴一定时垂直于主轴的。主轴的水平/垂直方向由flex-direction决定,取值row和row-reverse时,主轴是水平的。此时水平的主轴还有从左到右和从右到左之分,这依赖于writing-mode的取值。一般来讲,常见的文字都是left to right方向的,此时主轴的方向是从左到右的。第一张图就是最常见的情形,主轴水平从左到右,所有的flex子元素沿主轴排列布局。
*   flex布局容器(container)
flex布局需要一个布局容器,容器内的子元素按既定规则在容器内排列。flex支持多层嵌套布局,也就是flex容器内的子元素也可以成为其子元素的布局容器。声明一个flex布局容器十分简单:
\[css\]
display: flex;
display: -webkit-flex
\[/css\]
*   flex子元素(items)
在flex容器内部的子元素按指定的规则进行排列。直接包含在flex容器内的文本自动的被一个匿名flex item包裹,如果匿名的flex子元素只包含空白,那么这个匿名子元素是不显示的,被指定属性display:none。
相邻flex子元素的margin不会被折叠(collapse)

**flex布局容器属性**

*   flex-direction
指定flex容器主轴的方向,取值:

*   row
主轴为水平的,其水平上的方向依赖于writing-mode指定的值,默认为left to right,子元素按水平上的方向依次排列。
*   row-reverse
主轴为水平的,其水平上的方向与writing-mode指定的值刚好相反。比如writing-mode指定为left to right,则其主轴水平方向为从右到左。子元素则从右到左依次排列。
*   column
主轴为垂直的,其垂直上的方向与writting-mode指定的方向相同。
*   column-reverse
主轴为垂直的,其垂直上的方向与writting-mode指定的方向相反。

*   flex-wrap
指定flex容器是否可以换行,取值:

*   nowrap
不能换行,如果flex items过宽则溢出容器。
*   wrap
flex items可以在容器内换行,新行的方向与writtng-mode指定的方向相同。firefox从版本28开始才支持。
*   wrap-reverse
flex items可以在容器内换行,新行的方向与writting-mode指定的方向相反。firefox从版本28开始才支持。

*   justify-content
主轴方向上对齐flex items,取值:

*   flex-start
flex items沿主轴起始方向按指定顺序排列
*   flex-end
flex items靠主轴结束方向按指定顺序排列
*   center
flex items在主轴方向上靠容器中间按指定顺序排列
*   space-between
容器内剩余的空间在flex items之间平均分配,第一个flex item和最后一个flex item与容器边缘之间没有空隙。
*   space-around
容器内剩余的空间在flex items以及flex item与容器边缘之间平均分配。也就是所有flex items之间,flex item与容器边缘之间都有相同的空隙。

*   align-items
侧轴方向上对齐flex items,取值:

*   flex-start
flex items沿侧轴起始方向排列。
*   flex-end
flex items沿侧轴结束方向排列。
*   center
flex items沿侧轴居中排列。
*   baseline
flex items沿侧轴方向依照其基线排列。
*   stretch
flex items沿侧轴拉伸排列。

*   align-content
当在侧轴上有空间时,如何对齐flex容器内的多行flex items,如果flex容器内只有单行子元素,则此属性无效。取值:

*   flex-start
容器内的多行靠测轴起始方向并排排列。
*   flex-end
容器内的多行靠侧轴结束方向并排排列。
*   center
容器内的多行沿测轴居中并排排列。
*   space-between
侧轴方向的空白平均分配到容器内的多行之间,第一行与容器边缘以及最后一行与容器边缘之间没有空隙。
*   space-around
侧轴方向的空白平均分配到各行以及行与容器边缘之间,子元素行与行之间,已经行与容器边缘之间有相同的空隙。
*   stretch
容器内的行沿侧轴方向拉伸,自由空间平均分配到各行。

*   flex-flow
flex-flow为flex-direction和flex-wrap的组合缩写属性,其格式为:
\[css\]
flex-flow: flex-direction flex-wrap;
\[/css\]

**flex布局子元素属性**

*   order
指定flex item在容器内的显示顺序。无需修改html源代码即可为flex item指定新的显示次序,但是语音与导航仍然使用源代码中的顺序,因此这个属性有可能会破坏文档的可访问性(accessibility)。
*   flex
指定子元素的扩展因子,收缩因子和伸缩基准值。其格式为:
\[css\]
flex: flex-grow flex-shrink flex-basis
\[/css\]
flex-grow为正向伸展比例因子,主轴方向上的剩余空间会按比例分配到各个flex itme。初始值为0,指定负数无效。
flex-shrink为负向收缩比例因子,当flex items在主轴方向上将会溢出容器时,每个item会按指定的收缩比例因子进行收缩,从而防止items溢出容器。初始值为1,指定负数无效。
flex-basis指定子元素的伸缩基准值。在伸缩基准值的基础上,剩余空间或空间不足时按伸展比例因子或收缩比例因子进行按比例伸缩。
flex属性是这三个属性的组合缩写,也可以单独指定这些属性。
*   align-self
子元素覆盖容器的align-items属性,如果子元素在侧轴方向的margin设置为auto,则此属性被忽略。
*   margin
margin指定为auto会合并剩余的空间,可以使item水平和垂直都居中。也可以通过在容器上使用align-items:center;justify-content:center;来使item水平垂直居中。

**不影响flex布局的公共属性**
float,clear,vertical-align属性对flex items没有影响。对item指定float属性只是使其display值计算为block。

References:
\[1\][Using CSS flexible boxes](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Flexible_boxes)
\[2\][一览CSS布局标准](http://hikejun.com/blog/2013/05/03/%E4%B8%80%E8%A7%88css%E5%B8%83%E5%B1%80%E6%A0%87%E5%87%86/)
\[3\][Internet Explorer 10 中弹性框（“Flexbox”）布局](http://msdn.microsoft.com/zh-cn/library/ie/hh673531(v=vs.85).aspx)
\[4\][弹性框（“Flexbox”）布局更新](http://msdn.microsoft.com/zh-cn/library/ie/dn265027(v=vs.85).aspx)
\[5\][学习CSS布局](http://zh.learnlayout.com/)
\[6\][使用Flexbox：新旧语法混用实现最佳浏览器兼容](http://www.w3cplus.com/css3/using-flexbox.html)
\[7\][flexbox 布局使用体会](http://www.cnblogs.com/yansi/p/3335916.html)
\[8\][跨浏览器弹性布局进阶教程](http://dev.oupeng.com/articles/advanced-cross-browser-flexbox)
\[9\][Hold住CSS布局新属性](http://www.w3cplus.com/css/master-new-css-layout-properties.html)
\[10\][Flexy Boxes](http://the-echoplex.net/flexyboxes/)
\[11\][响应式设计的未来——Flexbox](http://www.w3cplus.com/css3/responsive-design-of-the-future-with-flexbox.html)
\[12\][伸缩布局 — 打开布局天堂之门？](http://dev.oupeng.com/articles/flexbox-basics)

===
**\[erq\]**