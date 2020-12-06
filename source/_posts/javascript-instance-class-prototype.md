---
title: javascript继承模型
tags:
  - Javascript
id: '3056'
categories:
  - - javascript
date: 2013-06-05 11:07:57
---

javascript中并没有类的概念，这里的类指代用new操作符产生出其他对象的对象。
<!-- more -->
这里说的属性也包括方法，因为方法只不过是值为函数的属性。

javascript是基于原型的，没有类的概念，但是借鉴了new操作符来通过原型对象(constructor.prototype)生成实例对象，new运算符作用于一个函数构造器(constructor)之上。先看一个简单的函数构造器(constructor)
\[javascript\]
function F(){}
\[/javascript\]

F看起来平淡无奇，但其背后隐藏了很多看不到的奥秘。首先F是一个函数F()，其次函数本身还是一个对象F，再次函数F()背后还有一个由javascript引擎安排的一个函数构造器原型(constructor.prototype)对象F{}。这个构造器原型对象F{}是F对象的属性，而不是F()函数的,由F对象的prototype属性引用，也就是F.prototype=F{}

从机器域来说，函数F()就是一段可执行代码，所以底层实现还是需要一个数据区来存储函数对象F的属性。在机器层面上这与C++的类模型并无本质的不同。

这里有必要区分下F()函数和F对象。先来看段C++代码：
\[cpp\]
class F{
public:
 F(){
 this.m_a='a'; 
 }
private:
 char m_a;
}

F* f = new F();
\[/cpp\]
是不是有一个F类还有一个F构造函数。F类的构造函数就是F(),生成f实例对象时new会在内部调用F()构造函数。new先申请一块类对象大小的内存块，然后初始化一些内部的变量如vptr等，最后会以此内存区域的首地址为this指针的值来调用构造函数F(),最后将实例对象的地址赋予实例对象指针f。

javascript的原型继承与其有相似之处，只是实现方式不同。再回到最初的javascript函数构造器，F()就是构造函数，F对象就是类，F.prototype引用的原型对象F{}就是父类，原型对象F{}有一个字段constructor指向构造函数F()。

var f = new F();

构造函数为新创建对象添加用this修饰的属性，因为this此时指向新创建的对象，并返回给f,这是显式的。并且新创建的对象动态的继承原型对象F{}(F.prototype)中的所有属性。但是对象f并不从F对象继承任何属性，这与C++等是不同的。new做的具体操作参考[JavaScript原型链浅析](https://openwares.net/js/javascript_prototype_chain.html)

看一段测试代码
\[javascript\]
function F(){
 var a = "a"; //a不过是函数F()的局部变量，离开F()，变量a就不存在了
 this.b = "b"; //b也是函数F()作用域内部的变量，离开F()就不存在了，
 //但b却添加到新对象上，因为执行构造函数F()之时，this指向新构造的对象
 this.instanceF = function(){ //与b相同，所有this修饰的属性都会添加到新对象之上
 console.log("this="+this);
 console.log("this.a="+this.a);
 console.log("this.b="+this.b);
 console.log("this.c="+this.c);
 };
};

F.c = "c"; //这里c其实是添加到F对象之上
F.staticF = function(){ //与c相同,添加F对象之上
 console.log("this="+this);
 console.log("this.a="+this.a);
 console.log("this.b="+this.b);
 console.log("this.c="+this.c);
};

//static

console.log(F.a); //undefined
console.log(F.b); //undefined
console.log(F.c); //c
//F.instanceF(); //TypeError: F.instanceF is not a function
F.staticF(); //依次输出(可以看出staticF()函数的this就是F对象，也就是function F(){...}):
 //this=function F(){
 // var a = "a"; //a不过是函数F()的局部变量，离开F()，变量a就不存在了
 // this.b = "b"; //b也是函数F()作用域内部的变量，离开F()就不存在了，
 // //但b却添加到新对象上，因为执行构造函数F()之时，this指向新构造的对象
 // this.instanceF = function(){ //与b相同，所有this修饰的属性都会添加到新对象之上
 // console.log("this="+this);
 // console.log("this.a="+this.a);
 // console.log("this.b="+this.b);
 // console.log("this.c="+this.c);
 // };
 //} 
 //this.a=undefined 
 //this.b=undefined
 //this.c=c

//函数对象F是由Function(){}构造的
console.log(F.constructor); //function Function() { \[native code\] } 
console.log(F.constructor===F.__proto__.constructor); //true
//new instance
var f = new F();

console.log(f.a); //undefined
console.log(f.b); //b
console.log(f.c); //undefined
f.instanceF(); //依次输出:
 //this=\[object object\]
 //this.a=undefined
 //this.b=b
 //this.c=undefined
//f.staticF(); //TypeError: f.staticF is not a function
\[/javascript\]

对象实例f，拥有构造函数F()为其添加的属性、自己添加的属性，并可以访问原型链F.prototype上的属性，但不能访问F对象上的属性。从构造函数F()添加的属性每个实例都有一个单独的拷贝，不会相互影响，但F.prototype上的属性则是由所有的实例共享的，修改F.prototype的属性会影响所有的实例。

由此可见，**F.prototype其有属性constructor指向构造函数F(),并且new出来的实例对象从F.prototype继承属性，并可沿原型链上溯。相对而言F对象则看起来可有可无了。因为纯粹的构造函数F()是不能持有属性的，所以就有了F对象来持有F的prototype属性，难道这就是生成F对象的唯一原因吗？**

F对象的方法很像其他语言里的类静态方法，无需实例化对象即可直接访问，其实就是一种全局函数，不过就是加上了类型的名字空间而已。

那么，最终可以与C++,java等语言做一个类比，当然并没有很多的可比性，差别还是很大的：
new生成的f对象是F类的实例，而F类的功能则是由F()和F共同提供，F()提供实例属性，F提供类静态属性，F{}(F.prototype)则是F类的父类，大体是这么个对应关系。但是实例对象f并不能访问F对象的静态属性。

也就是说：**函数构造器是构造函数，其背后隐式的对象为类，构造器的prototype是父类，而通过构造器new出来的则是对象。**
一个字，真绕！

**P.S.** 这篇文章[Javascript – How Prototypal Inheritance really works](http://blog.vjeux.com/2011/javascript/how-prototypal-inheritance-really-works.html)对javascript原型继承讲述的十分清晰。
这里还有一篇大牛Douglas Crockford的文章[Prototypal Inheritance in JavaScript](http://javascript.crockford.com/prototypal.html)

**UPDATE（05/03/2014)：**如果非要与传统的OOP类比的话,应该是**构造函数**和其**原型对象**一起构成了继承链中的**父类**。
**\===
\[erq\]**