---
title: HTML子元素遮盖父元素
tags: []
id: '6412'
categories:
  - - Misc
date: 2015-05-14 16:47:50
---


<!-- more -->
父元素relative定位,然后子元素absolute定位,指定top,left,bottom,right设置为0

\[html\]
#parent {
 position: relative;
 height: 100px;
 width: 100px;
}

#child {
 position: absolute;
 top:0;
 left: 0;
 right: 0;
 bottom: 0;
}
\[/html\]

无需指定z-index

**\===
\[erq\]**