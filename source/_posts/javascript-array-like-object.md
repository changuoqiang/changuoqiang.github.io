---
title: Javascript \"类\"数组对象
tags:
  - Javascript
id: '5764'
categories:
  - - javascript
date: 2014-08-07 20:33:25
---


<!-- more -->
"类"数组对象,这名字实在太让人迷惑了,不过看看其英文的含义就一目了然了,array like objects。嚓！原来如此！

类数组对象中的“类”不是class的意思，而是like，类似的意思。JavaScript中有一些看起来像却又不是数组的对象，叫作"类"数组对象。

类数组对象拥有数组索引下标以及length属性,但不具有数组所拥有的其他方法。比如每个函数都具有的arguments对象就是一个类数组对象。

Javascript是如此的灵活，类数组对象可以借用Array对象所拥有的方法,只要调用数组函数的call方法将类数组对象绑定为this即可。比如可以将arguments类数组对象转换为真正的数组:
```js
var args = Array.prototype.slice.call(arguments);
```

**\===
\[erq\]**