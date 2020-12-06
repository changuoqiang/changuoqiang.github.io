---
title: $().prop和$().attr
tags: []
id: '6415'
categories:
  - - GNU/Linux
date: 2015-05-15 14:10:50
---


<!-- more -->
JQuery早期版本只有.attr方法而没有提供.prop方法,导致一些混乱。1.9之后的版本,设置元素的property要用$().prop('property', val),设置元素的attribute要用$().attr('attribute', val)。

设置表单元素的值,可以$().val(val),也可以使用$().prop('value', val)。

checked/selected之流,虽然attribute和property都有，但二者的类型是不同的。对于property,他们的值是true或者false,是布尔类型,而对于attribute，他们的值是字符类型的，有值"checked"/"selected"表示元素是选中的，而没有值，表示元素没有被选中。property与attribute之间有一个同步的问题。

一般使用$().prop即可，除非真的要更改HTML元素的attribute。

**\===
\[erq\]**