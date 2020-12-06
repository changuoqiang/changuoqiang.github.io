---
title: JavaScript执行环境栈(Execute Context Stack)与作用域链(Scope Chain)
tags:
  - Javascript
id: '5499'
categories:
  - - javascript
date: 2014-05-06 09:35:15
---


<!-- more -->
1、函数对象创建时会继承当前执行环境的作用域链。也就是当前执行环境会将其创建的函数对象的\[\[scope\]\]属性设置为当前作用域链的头，也就是指向当前执行环境的活动对象(Active Object),其实就是一个可变对象(Variable Object),不过因为它是当前激活的VO,所以又叫AO。

References:
\[1\][Javascript 闭包](http://www.cn-cuckoo.com/main/wp-content/uploads/2007/08/JavaScriptClosures.html)
\[2\][深入理解javascript之执行上下文(execution context)](http://www.360weboy.com/front/page1/execution-context.html)
\[3\][JavaScript中的 变量、作用域链、执行上下文](http://octsky.com/post/63/)
\[4\][理解js作用域链及闭包](http://www.yeebing.com/webdesign/998.html)

===
\[erq\]