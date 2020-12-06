---
title: 检测浏览器对HTML5新input类型的支持
tags:
  - Javascript
id: '5659'
categories:
  - - javascript
date: 2014-07-17 16:43:07
---


<!-- more -->
HTML5新增加了很多input元素类型,比如color,date,datetime,datetime-local,email,month,number,range,search,tel,time,url,week等。

通过以下方法可以检测浏览器是否支持这些新的input类型:

\[html\]
var i = document.createElement('input');
i.setAttribute('type', 'date');
//浏览器不支持date类型
if(i.type == 'text'){
}
\[/html\]
这里为新添加的input元素设置type特性(attribute)为date,如果浏览器支持date类型,则其对应的dom对象的type属性(property)会设置为date,否则会设置为text,这里一定要注意"特性(attribute)"和"属性(property)"的区别。attribute是标签的特性,而property是标签对应的DOM对象的属性。

所以，即使浏览器不支持新的input类型,虽然其DOM对象的type属性被设置为text,但其标签的type特性仍然是原来设置的值，对上面这个栗子来说就是date

\[html\]
i.getAttribute('type') == 'date'; //true
\[/html\]

特性与属性的区别见"[DOM对象属性(property)与HTML标签特性(attribute)](https://openwares.net/linux/dom_property_element_attribute.html)"

**\===
\[erq\]**