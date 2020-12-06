---
title: javascript使新创建对象继承函数构造器对象的属性
tags:
  - Javascript
id: '4192'
categories:
  - - javascript
date: 2013-11-18 09:26:59
---


<!-- more -->
默认情况下，使用new运算符创建的对象是从函数构造器(constructor)的原型对象(constructor.prototype)继承属性的，新对象不会继承函数构造器(constructor)自身的属性。
\[javascript\]
(function(){
 function Func(){
 this.a="a"
 }

 Func.b="b"
 Func.prototype.c="c";
 
 var obj=new Func();
 console.log(obj.a); //a
 console.log(obj.b); //undefined
 console.log(obj.c); //c

 console.log(obj.__proto__); //F{c: "c"}
 console.log(obj.prototype); //undefined
})();
\[/javascript\]

可以看到obj有本地属性a,没有属性b，还有继承自constructor.prototype的属性c。

那么要让obj继承函数构造器(constructor)的属性也十分简单
\[javascript\]
 function Func(){
 this.a="a"
 }

 Func.b="b"
 Func.prototype.c="c";
 Func.prototype=Func; 

 var obj=new Func();
 console.log(obj.a); //a
 console.log(obj.b); //b
 console.log(obj.c); //undefined

 console.log(obj.__proto__); //function Func(){this.a="a"}
 console.log(obj.prototype); //function Func(){this.a="a"}
})();
\[/javascript\]

只要将函数构造器(constructor)的原型对象(constructor.prototype)指定为其自身即可。

**\===
\[erq\]**