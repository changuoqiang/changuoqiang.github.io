---
title: DOM对象属性(property)与HTML标签特性(attribute)
tags:
  - HTML
  - Javascript
id: '5541'
categories:
  - - GNU/Linux
date: 2014-05-20 21:10:07
---


<!-- more -->
HTML中property与attribute是极易混淆的两个概念。大多数时候这两个单词都翻译为“属性”,为了区分二者，一般将property翻译为"属性"，attribute翻译为"特性"。

每一个HTML标签(tag)都对应一个DOM接口HTMLXxxElement,比如Span标签对应的是HTMLSpanElement。这些标签的DOM接口都继承自HTMLElement接口，而HTMLElement又继承自Element。我们知道所有的标签都是一个元素结点,因此Element接口又继承自Node接口。其实HTML文档树中的所有东西都是结点,只不过有不同的结点类型而已。

property就是DOM对象的属性,就像普通的javascript对象的属性一样一样的,因为DOM对象就是一个地道的javascript对象，也有自己的原型链。
而attribute则是HTML标签的特性,比如
```js
<div id="div1" title="title1">test<div>
```
这里id和title是HTML标签div的特性,虽然对应的DOM对象HTMLDivElement也有这两个属性，但它们却是完全不一样的东西。有些特性与属性是同步的。

HTML标签的attribute以[类数组](https://openwares.net/js/javascript_array_like_object.html)的形式存储在对应DOM对象的属性attributes中,attributes属性的类型为NamedNodeMap对象。
DOM对象提供了方法setAttribute，getAttribute和removeAttribute来操纵HTML标签的特性。
```js
DOMString getAttribute(in DOMString name);
void setAttribute(in DOMString name, in DOMString value) raises(DOMException);
```

HTML标签attribute的名字和值都必须为字符串类型，而DOM对象的property没有此限制，可以是任何类型。

有些HTML标签的attribute有对应的DOM对象property,但它们的取值却不一定是相同的。一般来说相对应的attribute与property其名字是一样的，但是class特性有所不同，因为class在javascript中为关键字，所以其所对应的property名字为className。

有些简单的特性,比如id,两者的取值是一样的。
```js
var id1=elem.id;
var id2=elem.getAttribute('id');
```
但对于input的value,使用getAttribute获取的永远是写HTML标签时指定的那个值,而value属性则获取到的是input当前输入的值。
而另一些特性比如checked,只要checked特性存在，无论其值是什么，DOM对象的checked属性的值都是true。这里checked属性已经不是字符串而是布尔类型了。

还有一些特性比如style和onclick,其对应的DOM属性完全是返回一个对象了,比如elem.style属性就返回一个CSSStyleDeclaration对象。

HTML自定义attribute没有对应的DOM对象property。

References:
\[1\][attribute和property的区别](http://stylechen.com/attribute-property.html)
\[2\][JavaScript中的property和attribute的区别](http://www.liyao.name/2013/09/differences-between-property-and-attribute-in-javascript.html)
\[3\][SD9006: IE 混淆了 DOM 对象属性（property）及 HTML 标签属性（attribute），造成了对 setAttribute、getAttribute 的不正确实现](http://www.w3help.org/zh-cn/causes/SD9006)
\[4\][The HTML DOM Element Object](http://www.w3schools.com/jsref/dom_obj_all.asp)
\[5\][DOM元素的特性（Attribute）和属性（Property）](http://www.cnblogs.com/wangfupeng1988/p/3631853.html)

===
\[erq\]