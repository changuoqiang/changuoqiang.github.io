---
title: javascript函数声明、函数表达式和函数构造器
tags:
  - Javascript
id: '4152'
categories:
  - - javascript
date: 2013-11-17 15:47:42
---


<!-- more -->
**函数声明**
_命名函数声明_
\[javascript\]
// 函数声明会被提升，所以可以提前调用
// 这里只是普通的函数调用,此时this指向Window对象,会为Window对象添加属性b
// result的值和类型依赖于Func()函数的返回值,没有return语句默认返回undefined
var result = Func(); //Window{...}
console.log(result); //undefined
console.log(typeof result); //undefined
 
// 函数声明
function Func(){
 //局域临时变量，函数执行完即被丢弃，无论是作为普通函数还是构造器调用
 var a = "a";
 
 // 无论是普通函数调用还是作为函数构造器
 // this指向哪个对象，则为那个对象添加属性b,
 // 如果作为构造器调用，this指向新创建的对象
 this.b = "b";
 
 // 因为没有使用var声明c,所以c属于全局变量，无论什么时候函数被调用，都会为全局对象添加属性c
 c="c";

 console.log(this);
}
 
//用户自定义函数的构造器为Function(),所以Func函数的原型链(__proto__)指向Function.prototype
console.log(Func); //function Func(){//临时变量...}
console.log(typeof Func); //function 
console.log(Func.__proto__); //function Empty(){}
console.log(Func.__proto__===Function.prototype); //true
console.log(Func.prototype); //Func{}
console.log(Func.prototype.constructor); //function Func(){//临时变量...}
console.log(Func.prototype.__proto__===Object.prototype); //true
 
// 当对函数施加new运算符时,函数才叫做构造器,new运算符的结果总是一个对象
// 函数自身返回对象的优先级高，new运算符新构造对象的优先级低。
// new运算符无论如何都会执行构造器函数,如果函数也返回一个对象的话,new运算符新构造的对象会被丢弃。
var obj = new Func(); //Func{b: "b"}
console.log(obj); // Func{b: "b"}
console.log(typeof obj); // object
console.log(obj.__proto__); // Func{}
console.log(obj.__proto__===Func.prototype); // true
console.log(obj.prototype); //undefined
 
// 这里只是为Func换了个别名func而已,func和Func都引用同一个命名函数对象Func()
// 二者是同一个东西，排名不分先后
var func = Func;
console.log(func); //function Func(){//临时变量...}
console.log(typeof func); //function
console.log(func.__proto__); //function Empty(){}
console.log(func.prototype); //Func{}
\[/javascript\]

_匿名函数声明_
匿名函数不立即执行是没有什么用处的，因为声明之后根本无法引用它，但仍然可以这样声明
\[javascript\]
//匿名函数
console.log(function(){var a="a";this.b="b";console.log(this);}) //function (){var a="a"...} 
//直接执行,第一次是console.log(this)输出,为Window{...}
// 第二次输出为函数返回值输出undefined
console.log((function(){var a="a";this.b="b";console.log(this);})()) //Window{...}; undefined
//当作函数构造器执行,第一次是构造函数输出，console.log(this)
//第二次是返回的新对象的输出,都是Onject{b: "b"}
console.log(new function(){var a="a";this.b="b";console.log(this);}) //Object{b: "b"}; Object{b: "b"}
console.log(function(){var a="a";this.b="b";console.log(this);}.__proto__) //function Empty(){}
// 匿名函数的匿名原型对象
console.log(function(){var a="a";this.b="b";console.log(this);}.prototype) //Object{}
console.log(function(){var a="a";this.b="b";console.log(this);}.prototype==Object.prototype) //false
console.log(function(){var a="a";this.b="b";console.log(this);}.prototype.__proto__===Object.prototype) //true
\[/javascript\]
**函数表达式**

_命名函数表达式_

\[javascript\]
// 函数表达式中的Func名字只在函数内部可见，不会进入外部名字空间
//var result1 = Func(); //Func is not defined
 
// 函数表达式不会被提升，所以不能提前调用
//var result2 = func(); //func is not a function
console.log(func); //undefined
 
// 函数表达式,func和Func都指向同一个命名函数对象Func()
// 二者是同一个东西，但是Func名字只在函数内部可见
var func = function Func(){
 //临时变量，函数执行完即被丢弃，无论是作为普通函数还是构造器调用
 var a = "a";
 
 // 无论是普通函数调用还是作为函数构造器
 // this指向哪个对象，则为那个对象添加属性b,
 this.b = "b";
 console.log(this);
}
 
// 函数表达式不会被提升，所以只能在函数定义之后调用
// 普通函数调用,this指向Window对象
var result3 = func(); //Window{...}
 
//用户自定义函数的构造器为Function(),所以func函数的原型链(__proto__)指向Function.prototype
console.log(func); //function Func(){//临时变量...}
console.log(typeof func); //function
console.log(func.__proto__); //function Empty(){}
console.log(func.__proto__===Function.prototype); //true
console.log(func.prototype); //Func{}
console.log(func.prototype.__proto__===Object.prototype); //true
 
// 当对函数施加new运算符时,函数才叫做构造器,new运算符的结果总是一个对象
// 函数自身返回对象的优先级高，new运算符新构造对象的优先级低。
// new运算符无论如何都会执行构造器函数,如果函数也返回一个对象的话,new运算符新构造的对象会被丢弃。
var obj = new func(); //Func{b: "b"}
console.log(obj); // Func{b: "b"}
console.log(typeof obj); // object
console.log(obj.__proto__); // Func{}
console.log(obj.__proto__===func.prototype); // true
console.log(obj.prototype); //undefined
\[/javascript\]

_匿名函数表达式_

匿名函数表达式和命名函数表达式的唯一区别是，其prototype属性对象是个匿名对象，而命名函数表达式的prototype属性对象为一个具名对象，比如上个例子中的Func()

\[javascript\]
// 函数表达式不会被提升，所以不能提前调用
//var result2 = func(); //func is not a function
console.log(func); //undefined
 
// 函数表达式,引擎为其分配了一个不具名的对象作为其原型对象(prototype属性指向的对象)
// 其本质上与上个示例中的具名对象Func()是一样的,原型链的上层都是Object
// func指向一个匿名函数对象function(){//临时变量...}
var func = function(){
 //临时变量，函数执行完即被丢弃，无论是作为普通函数还是构造器调用
 var a = "a";
 
 // 无论是普通函数调用还是作为函数构造器
 // this指向哪个对象，则为那个对象添加属性b,
 this.b = "b";
 console.log(this);
}
 
// 函数表达式不会被提升，所以只能在函数定义之后调用
// 普通函数调用,this指向Window对象
var result3 = func(); //Window{...}

//用户自定义函数的构造器为Function(),所以func函数的原型链(__proto__)指向Function.prototype
console.log(func); //function(){//临时变量...}
console.log(typeof func); //function
console.log(func.__proto__); //function Empty(){}
console.log(func.__proto__===Function.prototype); //true
//func.prototype是一个不具名的对象,其与上个例子中的具名对象Func()是一样的东西
//其原型链的上一个对象都是Object.prototype
console.log(func.prototype.constructor); // function(){//临时变量...}
console.log(func.prototype); // Object{}
console.log(Object.prototype); // Object{}
//不要被输出迷惑了,这个不具名对象与Object.prototype是不同的对象
console.log(func.prototype==Object.prototype); // false
//这个不具名对象原型自Object
console.log(func.prototype.__proto__===Object.prototype); // true
 
// 当对函数施加new运算符时,函数才叫做构造器,new运算符的结果总是一个对象
// 函数自身返回对象的优先级高，new运算符新构造对象的优先级低。
// new运算符无论如何都会执行构造器函数,如果函数也返回一个对象的话,new运算符新构造的对象会被丢弃。
var obj = new func(); //func{b: "b"}
console.log(obj); // func{b: "b"}
console.log(typeof obj); // object
console.log(obj.__proto__); // Object{}
console.log(obj.__proto__===func.prototype); // true
console.log(obj.prototype); //undefined
\[/javascript\]

**函数构造器**

当对函数施加new运算符时，函数才叫做构造器(constrcutor)，否则就是普通的函数调用。普通的函数调用中，函数返回的对象直接返回给调用者。

**但是当使用new操作符作为构造器调用时，new操作符会构造一个函数构造器(constrcutor)原型对象(constructor.prototype)类型的空对象(是object，不是function)，新对象的__proto__属性指向函数构造器的原型(constructor.prototype),从而新对象从函数构造器原型(constructor.prototype)继承属性。
新对象的constructor属性值被赋予原型对象的constructor值(prototype.constructor)，也就是函数构造器(constrcutor)自身。new运算符使用新对象作为this调用函数构造器(constrcutor)。**

返不返回新对象还要视函数的返回值而定。如果函数自身使用return语句明确的返回一个object或function,则直接返回函数的返回值，新
创建的对象被丢弃。否则会返回新创建的对象。

无论返不返回新创建的对象函数构造器(constrcutor)都会被调用。无论如何构造器(使用new操作符)都会返回一个对象，而不是基本类型。

new操作符创建的新对象只可能是object，不会是其他类型，不会是function。

new操作符新创建的对象未添加其他属性之前，所有的本地属性都来自于构造函数中使用this添加的属性。

不同的函数构造器(constrcutor)创建不同的对象。

到底new运算符做了什么事情，参见MDN文章[new](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/new)。

**\===
\[erq\]**