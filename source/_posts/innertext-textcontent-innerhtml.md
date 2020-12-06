---
title: 'innerText,textContent和innerHTML'
tags:
  - HTML
id: '5769'
categories:
  - - javascript
date: 2014-08-08 00:04:50
---


<!-- more -->
**textContent**

innertText和textContent都是用于获取节点及其后代节点的文本内容。innerText是M$的专有API,不过除firefox外基本上其他浏览器都支持此属性。textContent则是W3C的标准API。

innerText和textContent的主要区别如下:

*   textContent可以获取所有元素的内容，包括<script>和<style>，但innerText不能获取这两个标签的内容。
*   innertText可以感知样式，不会返回隐藏元素的文本内容，但是textContent可以返回
*   因为innerText感知样式，因此会触发重排(reflow),而textContent不会

新web application应该避免使用innerText等M$专有的API,IE9及以上也支持textContent。

**innerHTML**

就像名字的含义一样，textContent返回元素及其后代的文本内容,而innerHTML则返回HTML,如果仅仅需要文本就不应该使用innerHTML,textContent不只是更有效率，而且可以避免XSS(Cross-site scripting)攻击。

References:
\[1\][Node.textContent](https://developer.mozilla.org/en-US/docs/Web/API/Node.textContent)

**\===
\[erq\]**