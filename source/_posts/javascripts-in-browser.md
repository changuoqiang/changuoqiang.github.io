---
title: 浏览器里的javascript运行环境
tags:
  - Javascript
id: '2966'
categories:
  - - javascript
date: 2013-05-22 14:04:27
---

浏览器是javascript脚本语言最主要的宿主环境
<!-- more -->
javasctipt现在已经成为一种通用的脚本语言，除了最常见的在浏览器端运行，javascript还可以在服务器端运行，比如[Node.js](http://nodejs.org/),还有一些独立的第三方应用程序使用了javascript作为他们的脚本语言，比如Adode Acrobat,photoshop等。

browser为javascript的运行准备了一套对象体系，此对象体系的根就是window对象。window对象表达浏览器里的一个窗口或frame,在支持tab的浏览器里，每一个tab页都是一个window对象。window对象有两个引用自身的属性window和self,可以使用这两个属性引用这个全局window对象，当然默认情况下，所有的全局变量都在window对象的作用域范围内，都是window对象的属性。

浏览器为javascript准备了全局对象window，并将其作为全局的执行上下文，所有其他的对象，包括DOM对象，浏览器内置对象(BOM)以及javascript语言内置的对象，都在window对象的上下文内执行。如下图：
![browser object hierachy](/downloads/browser_object.png)

window对象之下的所有其他对象大体分为三组

**DOM对象**
这就是我们最熟悉的DOM对象了，最主要的一个对象就是document,用来表达浏览器窗口里的一个文档

**BOM对象**
这是浏览器相关的对象，比如navigator,location,history,XMLHttpRequest对象，alert,prompt,confirm也属于此类。

**javascript对象**
这是[javascript语言内置的全局对象](https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects)，比如Math,Date等，他们被置于window对象之下。

因此javascript脚本里所有函数和对象作用域之外的变量即所谓的全局变量被自动的置于window对象之下，成为window对象的属性。如果声明变量时不使用var修饰,则该变量自动成为一个全局变量。

**\===
\[erq\]**