---
title: window.open与弹出窗口阻止
tags:
  - Javascript
id: '6399'
categories:
  - - javascript
date: 2015-05-08 22:31:51
---


<!-- more -->
由于恶意的自动弹出各种小广告窗口实在过于泛滥，因此各浏览器平台默认都是阻止自动弹出新窗口的。but,如果用户主动点击打开新窗口，那么再进行阻止就有些不合情理了。so,用户主动触发的弹出新窗口不会被阻止,如果是代码自动触发则不会如此幸运了。

各大浏览器的默认阻止策略见参考\[1\]，因此如果不想弹出的新窗口被浏览器阻止，可以这样来:

当然最简单就是直接写在元素的onclick事件里，当用户点击时就可以弹出了。

再进一步，可以搞一个隐藏按钮,其click事件为弹出新窗口,然后在另一个用户动作事件中，处理完其他事务后，用javascript调用隐藏窗口的click事件，这样也是可以的。但是就算这样，用setTimeout自动触发也是不行的，也就是必须要在一个用户触发的上下文里弹出窗口才不会被阻止。

用户触发上下文中，调用ajax请求，在ajax的回调函数中打开新窗口时，各个浏览器的反应各有不同，chrome是允许的，而firefox则进行了拦截。这是可以在ajax请求前先弹出空白窗口，ajax请求之后再设置window.location为想要的URL。

References:
\[1\][window.open() 与浏览器阻止弹出窗口](http://lingyi.red/window-open-and-the-browser-to-block-pop-up-window)

**\===
\[erq\]**