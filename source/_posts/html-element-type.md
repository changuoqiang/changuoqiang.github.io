---
title: 判断HTML元素类型
tags: []
id: '6410'
categories:
  - - Misc
date: 2015-05-14 16:44:16
---


<!-- more -->
不用jquery
```js
if(el.tagName == 'SELECT'){
 //
}
```

使用jquery

```js
$el.is('select')
$el.is('SELECT')
$el.get(0).tagName == 'SELECT'
```

使用元素原生属性tagName测试时,类型名要用大写。也就是tagName属性输出的是大写的标签类型名。

**\===
\[erq\]**