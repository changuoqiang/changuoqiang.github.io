---
title: HTML文档中元素ID重复的问题
tags:
  - HTML
  - Javascript
id: '5557'
categories:
  - - GNU/Linux
date: 2014-05-22 09:31:11
---


<!-- more -->
HTML元素的id属性在一个文档中应该是独一无二的，传统上我们也是这样做的。但是开发SPA单页(Single Page Application)webapp时很容易遇到ID会重复的情况。当SPA多次动态加载同一个模块时，id重复是在所难免了。当前的项目就遇到了这个问题。

ID重复也不是什么大问题，但从语义来讲id(identification)应该是全局唯一的。xml文档严格要求id不能重复,如果html文档中元素有重复的id就无法通过XML校验，不是一个合法的XML文档。id重复虽然现在没有问题，但浏览器并没有保证以后不会出现问题。

当然可以通过动态修改HTML元素的id特性来缓解这个问题。

id重复的元素，通过jQuery或者原生的querySelectorAll方法都可以全部获取到。而且还可以通过指定一个明确的context来选择特定的id。虽然有其他相同id的元素，但只要他们有不同的context,就可以在选择器层面上进行明确的区分。

无论HTML元素的ID如何重复，浏览器生成的DOM对象都是实实在在的不同的。所以ID重复也不是什么大问题，如果实在无法避免重复，那就当class一样来用好了。

但要注意，HTML元素ID重复可能会break一些库或者框架。

References:
\[1\][HTML id Attribute](http://www.w3schools.com/tags/att_global_id.asp)
\[2\][HTML中的重复ID问题](http://www.web-tinker.com/article/20413.html)

**\===
\[erq\]**