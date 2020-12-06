---
title: javascript this关键字
tags:
  - Javascript
id: '3085'
categories:
  - - javascript
date: 2013-06-10 09:03:15
---

与传统的静态语言不同，javascript的函数和对象是完全动态绑定的，而且全局函数和成员函数的界限十分模糊，或者说二者没有区别，完全依赖于执行上下文(execution context)而定,因此this指针到底指向哪个对象呢？哦，对了，javascript没有指针，this是一个引用。
<!-- more -->
javascript是一种函数式编程语言，函数是第一类的对象。函数本身为一种特殊对象，属于顶层对象，不依赖于任何其他的对象而存在，因此可以将函数作为输入输出参数，可以存储在变量中，以及一切其他对象可以做的事情,因为函数自身就是对象。

**javascript中无论函数是如何定义的，无论通过函数声明还是函数表达式，无论是全局函数，内部函数，匿名函数还是从函数内部返回的函数，除了其作用域链不同之外，其他并无不同，他们在javascript中的地位是相同的。**

this的取值依赖于执行上下文，并且在严格模式(strict mode)和非严格模式下(non-strict mode)也有不同。

**全局上下文**

在任何函数之外，无论处于严格模式还是非严格模式，this都指向全局对象,浏览器环境下，这个全局对象就是window

\[javascript\]
console.log(this === window); // true
\[/javascript\]

**函数上下文**

函数内部的this指针依赖于函数是如何被调用的。

1、作为全局函数调用

\[javascript\]
function f1(){
 return this;
}
console.log(f1() === window); //true
\[/javascript\]

这种情况下，this被初始化为全局window对象，但在严格模式下则有不同

\[javascript\]
function f1(){
 "use strict";
 return this;
}
console.log(f1() === undefined); //true
\[/javascript\]

此时，this是未定义的。

2、作为对象的方法被调用

\[javascript\]
var o = {
 prop: 37,
 f: function() {
 return this.prop;
 }
};

console.log(o.f()); //37
\[/javascript\]

这种情况下，this绑定到对象o。无论对象的方法是如何定义的，是在对象内部定义的，还是在对象外部定义的，这条规则都是适用的。

\[javascript\]
var o = {prop: 37};

function independent() {
 return this.prop;
}

o.f = independent;

console.log(o.f()); //37
\[/javascript\]

但是，如果将对象的方法赋予一个变量，然后使用这边变量调用对象的方法，就会不同了，比如这样：

\[javascript\]
var test = someObject.methodTest;
test();
\[/javascript\]
此时test像一个全局函数一样被调用，而不是作为对象的方法调用，因此this不再指向someObject，而指向全局对象window

3、作为层级对象的方法调用
作为多级对象的方法被调用时，this绑定为距离方法最近的对象，或者说最内层的对象。延续上面的例子。

\[javascript\]
o.b = {g: independent, prop: 42};
console.log(o.b.g()); //42
\[/javascript\]

这里this绑定的是o.b对象而不是o

4、对象原型链上的方法调用

对对象原型链上的方法而不是本地方法调用时，this指针像本地方法调用一样绑定到对象上。

5、作为构造函数调用

this绑定到新建立的对象上

\[javascript\]
function C(){
 this.a = 37;
}

var o = new C();
console.log(o.a); //37
\[/javascript\]

6、内部函数的this
先看代码

\[javascript\]
var o = { a:"1",
 F:function(){
 console.log(this === o); //true
 (function(){
 console.log(this === window); //true
 })();
 }
 };
o.F();
\[/javascript\]

**内部函数的this指向全局对象window**,这多少有点儿令人意外，不是我们想要的结果。如果要在内部函数中存取外部函数的this,可以在外部函数声明一个变量that,内部函数使用这个that变量即可。that是一个随便起的变量名字，不过是个惯用法而已。

\[javascript\]
var o ={a:"1",F:function(){
 console.log(this === o); //true
 var that = this;
 (function(){
 console.log(this === window); //true
 console.log(that === o); //true
 })();
}};
o.F();
\[/javascript\]

**函数作为DOM的事件处理器**

首先声明一个事件处理函数logThis()

\[javascript\]
function logThis() {
 console.log(this);
}
\[/javascript\]

当以不同的方式注册到DOM元素作为其事件处理器时，this指向也有不同。

\[javascript\]
element.onclick = logThis; //使用脚本设置，this指向触发事件的DOM元素
element.addEventListener('click',logThis,false);//使用脚本设置，this指向触发事件的DOM元素
element.onclick = function () {console.log(this);};//使用脚本设置，this指向触发事件的DOM元素
<element onclick="console.log(this);">//内联事件处理器，this指向触发事件的DOM元素
\[/javascript\]

通过以上这几种方式设置事件处理器，事件处理程序内的this指向触发事件的DOM元素，但是下面的却不是这样

\[javascript highlight="1,2,4,5,7"\]
element.onclick = function () {logThis()};//使用脚本设置，this指向全局对象window
element.onclick = function () {(function(){console.log(this)})();};//使用脚本设置，this指向全局对象window
element.attachEvent('onclick',logThis);//使用脚本设置，this指向全局对象window
<element onclick="logThis()"> //内联事件处理器，this指向全局对象window。
 //可以通过传递this来弥补此问题，如onclick="logThis(this)",logThis函数内部就可以正确的
 //访问到触发事件的dom元素了
<element onclick="(function(){console.log(this);})();"> //内联事件处理器，this指向全局对象window
\[/javascript\]

这几种情况下，this皆指向全局对象window。
attachEvent是IE自己的事件注册方法，其他浏览器使用标准的addEventListener来注册事件，从IE9开始也支持addEventListener。
attachEvent一个最大的问题就是绑定到事件处理程序的this指向全局window对象。

使用<element onclick="logThis()">这种方法时，element元素的onclick方法属性只是简单的调用logThis函数，而不是把logThis函数赋予onclick属性,类似如下

\[javascript\]
function onclick(){
 logThis();
}
\[/javascript\]

估计attachEvent也是这样实现的，logThis成了onclick的内部嵌套函数，导致this指向全局对象window，失误。
其实上面高亮的第1,2,4,5,7行的本质都是真正的事件处理函数成了onclick函数的内部嵌套函数，而不是将事件处理函数自身赋予元素的onclick属性，所以内部嵌套函数的this指向全局对象window也就一点儿也不奇怪了。内联事件处理程序是不推荐使用的，破坏了结构和行为的分离原则。

**call,apply和bind**

通过call和apply函数调用，可以为函数绑定一个指定的对象作为其this。call和apply都继承自Function.prototype原型，二者唯一的不同在于传递参数的方式，apply使用数组来包裹参数。
\[javascript\]
function add(c, d){
 return this.a + this.b + c + d;
}

var o = {a:1, b:3};

//将o作为add函数的this
add.call(o, 5, 7); // 1 + 3 + 5 + 7 = 16
 
//将o作为add函数的this
add.apply(o, \[10, 20\]); // 1 + 3 + 10 + 20 = 34
\[/javascript\]

而Function.prototype.bind函数则生成一个新的函数，将一个对象永久的绑定到新函数的this,无论如何调用这个新函数，this都指向绑定的那个对象。

\[javascript\]
function f(){
 return this.a;
}
 
var g = f.bind({a:"azerty"});
console.log(g()); // azerty
 
var o = {a:37, f:f, g:g};
console.log(o.f(), o.g()); // 37, azerty
\[/javascript\]

最后推荐一篇好文[JavaScript 秘密花园](http://bonsaiden.github.io/JavaScript-Garden/zh/)
**\===
\[erq\]**