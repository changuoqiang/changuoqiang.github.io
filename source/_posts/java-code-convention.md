---
title: Java语言编码规范
tags:
  - Java
id: '3501'
categories:
  - - java
date: 2013-10-22 15:48:13
---

没有规矩，不成方圆。
<!-- more -->
使用Java有不少好处，官方连编码规范都制定出来了，不用费心制定规范了，遵循[官方编码规范](http://www.oracle.com/technetwork/java/codeconvtoc-136057.html)文档即可。这里有一篇[译文](http://morningspace.51.net/resource/javacodeconv.html)，翻译的挺流畅。

其实编码规范这种东西是见仁见智的事情，并无必须之章法。无非是要做到易于理解代码，易于后期维护而已。

编码规范的流派也不少，比如驼峰命名法([CamelCase](http://en.wikipedia.org/wiki/CamelCase)),蛇行命名法([snake_case](http://en.wikipedia.org/wiki/Snake_case)),匈牙利命名法([Hungarian notation](http://en.wikipedia.org/wiki/Hungarian_notation)),Pascal命名法([Pascal Case](http://c2.com/cgi/wiki?PascalCase))。

Java基本上遵循CamelCase命名法，linux内核开发则重度使用snake_case命名惯例，匈牙利命名法则主要用于windows平台的开发。这些命名惯用法并无实质性的优劣之分。

项目中最重要的是要使用统一的编码规范，对于JAVA开发，则官方编码规范足以。

注意一点，boolean类型不要以is前缀命名，不然工具生成getter/setter方法时可能会有意想不到的后果。