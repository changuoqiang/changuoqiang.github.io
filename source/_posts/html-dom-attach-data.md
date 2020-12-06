---
title: HTML页面中储存自定义信息的几种方式
tags:
  - HTML
id: '5891'
categories:
  - - Internet
date: 2014-09-24 12:26:16
---


<!-- more -->
HTML页面中储存自定义信息的方式能想到的大概有以下几种:

*   重用HTML元素的标准属性,比如 id、class、rel 和 title等,这些属性的值根据自己的需要进行解释。DWZ框架使用了这种方式。
*   上面的方式毕竟违反了标准的语意，容易造成一些问题。HTML5通过标准化的data-数据属性来支持在DOM元素上附加自定义数据
*   使用span或div元素包含自定义信息，通过样式(display: none;)使其不可见。
*   使用javascript代码自定义页面DOM元素与Javascript数据结构的关联
*   使用JQuery的缓存系统,.data方法向DOM元素附加自定义数据,.removeData移除DOM元素关联的自定义数据。如果dom元素从页面中remove,则JQuery会将其关联的自定义数据一并移除,无需显式调用.removeData。但是如果只是detach元素,则不会清除关联数据。这种方式是JQuery对上一种方式的标准化,其缓存系统十分完善。

以上几种方法如无特殊要求，建议使用JQuery的缓存系统。

**\===
\[erq\]**