---
title: CSS print 样式
tags:
  - CSS
id: '5224'
categories:
  - - Internet
date: 2014-03-13 15:20:58
---


<!-- more -->
显示器(screen)和打印机(printer)是两种差别很大的设备,所以从浏览器里看到的页面,打印出来也许和你看到的样子有很大的差距。screen一般使用逻辑单位比如px,而打印机则应该使用物理单位比如cm或in。我们常见的A4纸张大小在不同DPI的显示器上显示的大小是不同的。因此如果要精确的控制打印效果就应该使用print css，这是跨平台兼容的标准。不推荐使用浏览器插件方式实现打印。

web打印还有一种解决方式是生成pdf格式文件,客户端下载来打印,这也是不错的一种打印方式,因为pdf本身就是一种打印标准,可以做到精确控制。可以使用[jsPDF](http://parall.ax/products/jspdf)在客户端动态生成pdf,也可以在服务器端使用一些组件生成pdf后传送给客户端。当然首选还是使用print css来实现打印。

**引入print css**

*   使用link标签
就像通常在html页面中引入样式表一样,不过附加一个额外的media属性,如下面这样:
\[html\]
<link rel="stylesheet" href="print.css" media="print" />
\[/html\]
表明print.css样式表是用于打印的
*   使用@media规则
可以在通用的样式表中,使用@media规则指定样式用于打印,比如这样:
\[html\]
@media print selector {
...
}
\[/html\]
或者
\[html\]
@media print {
 selector {
 ...
 }
}
\[/html\]
*   使用@import规则
使用@import规则在通用的样式表中导入打印样式表,有两种形式,其本质是一样的。
css文件中:
\[html\]
@import url(print-style.css) print;
\[/html\]

html文件中:
\[html\]
<style type="text/css">
@import url(print-style.css) print;
</style>
\[/html\]

使用link标签要比使用@import规则性能更好。

**度量单位**

显示时一般使用px,em或pt等逻辑单位,但在打印时要使用物理单位,比如cm或in(英寸)。对于常见的DPI(Dot Per Inch)为96的screen,px与cm的换算关系如下：

1 inch = 2.54 cm
1cm = 96/2.54 ≈ 37.80 px
1px = 2.54/96 ≈ 0.0265 cm
100px = 2.65 cm

A4纸的标准尺寸为:
21.0cm * 29.7 cm

在96DPI分辨率下,其对应的像素尺寸大约为:
794px * 1123px

因为不同的DPI下,其对应的像素尺寸是不同的,所以才要使用print css,使用物理单位来描述要打印的页面,这样打印效果就会一致了。

**@page规则(at-rule)**

@page 规则用于指定打印页面的一些属性,包括纸张尺寸,方向,页边距,分页等特性。其语法如下:

\[html\]
@page :pseudo-class {
 size: A4 landscape;
 margin:2cm;
}
\[/html\]
其中伪类可以指定:

*   :first
指定第一页
*   :left
指定左侧页面
*   :right
指定右侧页面

**分页(paginate)**

有几个用于控制打印分页的属性可以用于常规的标签元素:

*   page-break-before
用于设置元素前面的分页行为,可取值:

*   auto
默认值。如果必要则在元素前插入分页符。
*   always
在元素前插入分页符。
*   avoid
避免在元素前插入分页符。
*   left
在元素之前足够的分页符，一直到一张空白的左页为止。
*   right
在元素之前足够的分页符，一直到一张空白的右页为止。
*   inherit
规定应该从父元素继承 page-break-before 属性的设置。

*   page-break-after
设置元素后的分页行为。取值与page-break-before一样。
*   page-break-inside
设置元素内部的分页行为。取值如下:

*   auto
默认。如果必要则在元素内部插入分页符。
*   avoid
避免在元素内部插入分页符。
*   inherit
规定应该从父元素继承 page-break-inside 属性的设置。

比如:
\[html\]
@media print {
 section {page-break-before: always;}
 h1 {page-break-after: always;}
 p {page-break-inside: avoid;}
}
\[/html\]
*   orphans
设置当元素内部发生分页时必须在页面底部保留的最少行数。
*   widows
设置当元素内部发生分页时必须在页面顶部保留的最少行数。比如:
\[html\]
@media print {
 p {orphans:3; widows:2;}
}
\[/html\]

**其他**
对于页面上有显示而不想打印的内容,可以将其display设置为none来避免打印。需要打印的内容尽量避免float,有些浏览器不会正确的打印浮动的内容。

可以调用window.print()函数来打印当前页面。

References:
\[1\][CSS for print tutorial](http://edutechwiki.unige.ch/en/CSS_for_print_tutorial)
\[2\][@page](https://developer.mozilla.org/en-US/docs/Web/CSS/@page)
\[3\][CSS 打印属性（Print）](http://www.w3school.com.cn/cssref/#print)

**\===
\[erq\]**