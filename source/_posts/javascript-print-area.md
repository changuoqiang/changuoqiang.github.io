---
title: javascript 局部打印(print area)
tags:
  - Javascript
id: '6716'
categories:
  - - javascript
date: 2015-10-09 11:16:53
---


<!-- more -->
非标准、非通用的二进制插件打印方式此处不叙。

**打印命令**

*   标准的打印方法为调用window.print(),所有的现代浏览器都支持该方法。
*   还可以使用Print命令调用Document.execCommand(),也就是:
    ```js
    document.execCommand('Print')
    ```
    虽然所有的桌面浏览器都支持，但这个方法是非标准的。
    
    execCommand的接口规格:
    ```js
    bool = document.execCommand(aCommandName, aShowDefaultUI, aValueArgument)
    ```
    

**局部打印方法**

Javascript局部打印大约有一下这几种方法：

*   print css方式

html支持print css,这是专用于打印设备的，而通常的css用于显示设备
```js
<link rel="stylesheet" href="print.css" media="print" />
```
可以使用print css将无需打印的区域隐藏掉,而需要打印的区域重新设置适合打印的样式，打印时直接调用window.print()即可。

这种打印方式页面不会看到变化，但是样式的调整可能会比较繁琐。

*   screen css方式

使用通常的CSS,在打印之前将无需打印的部分从页面上隐藏，需要打印的区域冲洗设置适合打印的样式。打印完成后再恢复样式。打印时会看到页面的变化。
*   body replace方式

打印之前将页面的body内容替换为需要打印的区域，打印完毕后再恢复body的内容。打印时会看到页面的变化。
这种方式与上种方法虽然做法不同，但其实质是相同的，即讲当前页面显示的内容设置要打印的内容，打印完毕后再恢复页面。
*   iframe方式

打印时生成一个iframe嵌入到主页面中,iframe的内容即为需要打印的内容，然后调用iframe的print()方法就可以了。iframe其实就是一个window。
用iframe的好处是不用弹出新窗口。

但是需要**注意**:
chrome从45.0开始，默认阻止iframe的print方法,除非iframe的沙箱属性有allow-modal值，并且设置了modal标志。

Starting with Chrome 45.0 print method is blocked inside an iframe unless its sandbox attribute has the value allow-modal and the modal flag is enabled.

*   popup new window方式

new window方式其实与iframe方式基本一样，唯一的区别是需要弹出新窗口。很多浏览器对于弹出新窗口都有严格的管制策略，因此新窗口方式用户体验不佳。

总的来说,iframe的方式比较简单，用户体验也较佳。

**\===
\[erq\]**