---
title: button与input type=\"button\"
tags: []
id: '5629'
categories:
  - - GNU/Linux
date: 2014-06-25 14:32:15
---


<!-- more -->
button元素有更强的表现力,在button元素内部可以放置样式化的其他元素,这是比input(type="button")强大的地方。如果button元素放在form内部,点击button会导致form的提交,虽然这个button并没有显式的指定其为submit类型。这是因为"Internet Explorer 的默认类型是 "button"，而其他浏览器中（包括 W3C 规范）的默认值是 "submit"",所以应该始终为button指定明确的类型，button或者submit。
 
对于二者更详细的区别见参考\[1\]

Rreferences:
\[1\][button和input type="button" 的区别](http://www.cnblogs.com/purediy/archive/2012/06/10/2544184.html)

**\===
\[erq\]**