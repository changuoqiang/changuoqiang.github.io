---
title: innerHTML动态加载javascript脚本
tags:
  - Javascript
id: '3039'
categories:
  - - javascript
date: 2013-06-03 10:46:37
---

元素对象的属性innerHTML可以用来获取或设置元素的后代节点,但是设置这个属性时，如果包含javascript脚本则有些问题
<!-- more -->
**脚本加载方式对innerHTML的影响**
HTML文档加载javascript脚本有三种方式，外部引用方式、内部引用方式和内联引用方式。

外部引用方式
\[javascript\]
<script type="text/javascript" src="/path/to/external.js"></script>
\[/javascript\]

内部引用方式
\[javascript\]
<script type="text/javascript">
//some javascript code
</script>
\[/javascript\]

内联引用方式
\[javascript\]
<input type="button" onclick="someJavascriptCode"> //可以是直接运行的代码，也可以调用其他地方定义的函数
\[/javascript\]

根据 W3C 规范中的描述，SCRIPT 标签内的 "脚本" 只会在"页面加载"时执行一次，或者通过绑定事件实现在页面加载后脚本能够重复地执行。
因此使用innetHTML动态加载包含javascript脚本的内容时,外部引用方式和内部引用方式使用的脚本是无法运行的。内联引用方式只有内联javascript是完全自包含的，也就是不调用任何外部的函数时，这些脚本在后来的事件触发调用中是可以正常执行的。

**解决方案**

一、使用浏览器的特性或者bug

**IE浏览器**

defer 属性是 SCRIPT 元素的特有属性，这是一个布尔型属性，它通知用户端这段脚本中不会动态生产文档内容（如 "documnet.write" ），所以不必现在立即执行，一般的拥有 defer 属性的 SCRIPT 元素中的脚本会较晚的被执行。在 IE6 IE7 IE8 中，当使用 innerHTML 方法插入脚本时，SCRIPT 元素必须设置 defer 属性才能生效。

因为script是作用域外元素，包含着在页面中看不到该元素的意思，就像看不到style元素或注释一样。在通过innerHTML插入的字符串中，如果一开始就是作用域外元素，IE会把所有作用域外元素都剥离掉。所以通常为了使 innerHTML 插入的脚本能够在 IE 中正常执行，经常会在欲插入的 HTML 代码字符串的最开始增加一个不可见的元素。如：
\[javascript\]
<span style="display:none;">span</span><script type="text/javascript" defer>someJavascriptCode</script>
\[/javascript\]

**firefox浏览器**
在 Firefox 中，先将被插入 HTML 代码的元素从其父元素中移除，然后使用 innerHTML 插入包含 SCRIPT 元素的代码，最后将这个元素恢复至原父元素中，则经过此操作后 SCRIPT 中的脚本可以被执行。

二、通用解决方案

上面提到的方法是不可靠而且不通用的，更一般的方法是解析将要赋予对象innerHTML属性的文本，将其中的javascript做特殊的处理，然后再将其插入对象。大体的方法如下：

对于外部引用javascript脚本，再一次请求src指向的脚本文件，新建script元素，设置其type为text/javascript,将获取的外部脚本的内容插入script元素，然后将script元素插入到head元素下。

对于内部引用脚本，新建script元素，设置其type为text/javascript,将内部引用脚本的内容插入到script元素，然后将script元素插入到head元素下。

javascript脚本中，除函数定义以外，还有一些是函数的调用，应该将这些脚本提取出来，使用eval执行这些脚本。

除脚本以外的html内容，直接用innerHTML插入节点即可。

JQuery的load方法即可以满足这些要求，用innerHTML向元素插入内容时，各种脚本都可以正确的执行。
**\===
\[erq\]**