---
title: CSS垂直外边距合并
tags:
  - CSS
id: '5214'
categories:
  - - Internet
date: 2014-03-11 14:32:05
---


<!-- more -->
这几天写CSS的时候发现一个奇怪的现象,子元素的margin-top会影响父元素的margin-top。本来父元素只是一个简单的容器,没有设置样式,第一个子元素设置了margin-top后,父元素也具有了一样的margin-top,原来是边距合并(Margin Collapse)在作怪。

普通文档流中相邻的块框,还有父元素与第一个子元素的上边距,父元素与最后一个子元素的下边距都有可能会发生外边距合并,这其中有些复杂的规则存在,与BFC(Block formatting contexts)密切相关,在同一个BFC(块格式化上下文)中，相邻的块级框之间的垂直外边距会出现折叠。详细的描述见参考文档\[1\]和\[2\],文档\[1\]描述的十分详细,这里就没必要再重复了。

防止父子元素外边据合并的常用方法有:

*   父元素设置overflow:visible之外的其他值
*   父元素设置border
比如设置一个1px透明的border
\[css\]
border: 1px solid transparent;/*透明边框,防止父子元素垂直边距合并*/
\[/css\]
*   父元素或子元素设置float属性
*   父元素设置padding-top(padding-top:1px)
*   设置父元素或者自身display:inline-block
*   父元素或子元素绝对定位(absolute或fix)
*   设置父元素非空，填充一定的内容

**注意：只有普通文档流中块框的垂直外边距才会发生外边距合并。行内框、浮动框或绝对定位之间的外边距不会合并。**

References:
\[1\][深入理解BFC和Margin Collapse](http://www.w3cplus.com/css/understanding-bfc-and-margin-collapse.html)
\[2\][CSS 外边距合并](http://www.w3school.com.cn/css/css_margin_collapsing.asp)
\[3\][由浅入深漫谈margin属性](http://www.planabc.net/2007/03/18/css_attribute_margin/)

**\===
\[erq\]**