---
title: javascript的undefined和null
tags:
  - Javascript
id: '4117'
categories:
  - - javascript
date: 2013-11-16 15:19:41
---


<!-- more -->
**undefiend**

javascript定义了一个全局变量undefined，它的值是undefined，它的值的类型也是undefined。 但是这个undefined全局变量不是一个常量，也不是一个关键字，而且可以被用户定义的名字覆盖。
\[javascript\]
 console.log(undefined); //undefined
 console.log(typeof undefined); //undefined
 var undefined="test";
 console.log(undefined); //test
 console.log(typeof undefined); //string
\[/javascript\]
为了防止undefined全局变量被无意覆盖，一个常用的技巧是使用一个传递到函数的额外形式参数。 在调用时故意不为其提供实际参数,从而这个参数不会获取任何值,成为undefined。比如jquery就是这样玩的：

\[javascript\]
(function( window, undefined ) {
 ...
})( window );
\[/javascript\]
这样，在匿名函数内部，可以保证undefined就是undefined不是任何其他值。
其实质是定义了一个匿名函数局部作用域变量undefined,其值为undefined。

**null**

null不是变量，是一个预定义的对象，其值为null

\[javascript\]
 console.log(null); //null
 console.log(typeof null); //object
 console.log(null == undefined) //true
 console.log(null === undefined) //false

 console.log(null.toString()); //Uncaught TypeError: Cannot call method 'toString' of null 
 var null="test" //Uncaught SyntaxError: Unexpected token null
\[/javascript\]

不能重定义null的名字，null虽然被认为是对象，但其没有任何方法。null对象可以作为原型继承链的终点。

null与undefiend的值相等，但二者的类型不同。
**\===
\[erq\]**