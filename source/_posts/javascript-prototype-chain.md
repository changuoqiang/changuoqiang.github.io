---
title: JavaScript原型链浅析
tags:
  - Javascript
id: '2986'
categories:
  - - javascript
date: 2013-05-29 22:06:14
---

JavaScript prototype chain 探索
<!-- more -->
先来看图
![javascript object layout](/downloads/js_obj_layout.png)
这图有点儿复杂，不过画的很好。这是[原图](http://www.mollypages.org/misc/js.mp)，我对其做了些微修改，以便看起来更清楚一些。

**1、对象的prototype和__proto__属性**
确切的说，__proto__不是一个标准的属性，是部分浏览器的特定实现。不过除了IE浏览器之外，其他的浏览器都使用这个名字来实现javascript标准文档里所讲的\[\[prototype\]\]隐藏属性。这个属性是隐藏的，只应该有解释器来使用，客户代码不应该依赖于此属性。最新的标准提供了Object.getPrototypeOf函数来获取对象的\[\[prototype\]\]属性。

prototype是一个显式的属性，客户可以存取，prototype属性引用对象“关联”的原型对象，而__proto__属性引用“构造”该对象的原型对象。javascript查找对象的属性时是使用__proto__引用的原型对象链向上查找的。

所有的对象都有__proto__属性，但只有可以作为构造器的函数对象才有prototype属性，当然所有的函数都可以作为构造器，也就是只有函数才有prototype属性。普通的非函数对象实例是没有的，因为这样的对象并不能用来构造新的对象。而这个prototype属性所引用的原型对象正是构造器函数构造对象时使用的原型，一会儿讲new运算符会讲到。

\[javascript\]
function F(){};
var f = new F();
console.log(f.__proto__ == F.prototype); //true
console.log(f.prototype);//undefined
\[/javascript\]

**2、函数对象的prototype从哪里来，由谁负责构造**
内置函数对象的prototype属性及其引用的原型对象由javascript引擎提供。用户在自定义函数时，js引擎会背地里同时为该函数生成一个原型对象，其为一个与用户定义函数同名的对象，看代码

\[javascript\]
function f(){this.test="";}
console.log(f.prototype); //f{}
console.log(typeof f.prototype); //object
\[/javascript\]
请注意，f.prototype的类型为object,而不是Object。Object其实是一个函数对象，而object表明f.prototype是一个地地道道的纯粹对象。
其实构造器函数的prototype就是为其派生对象存储公共属性的一个容器，不然这些派生对象从原型继承来的属性放到哪里呢？当然prototype还有其他用来管理的属性，比如其constructor属性就指回到函数构造器。当一个对象用构造器构造完成后，构造器的使命就完成了，派生对象从此之后只与其prototype有关系，而与构造器彻底无关了。

**再看看内置对象的prototype属性及其类型**
\[javascript\]
console.log(Object.prototype); //Object{}
console.log(typeof Object.prototype); //object
console.log(Function.prototype); //function()
console.log(typeof Function.prototype); //function
console.log(Array.prototype); //\[\]
console.log(typeof Array.prototype); //object
\[/javascript\]
可以看到，除了Function的原型对象为function类型外，其他内置函数对象的原型对象皆为object类型，纯粹的对象，注意不要与Object混淆。

Function比较特殊，其prototype属性和__proto__属性皆引用同一个原型对象，且其原型对象的类型为function(),而不是对象。因为javascript中的所有函数功能皆来自于Function.prototype原型对象,包括Function自身，所以如果Function.prototype也是一个对象而不是函数的话，那函数的功能从哪里来呢？所以其为函数类型，由js引擎来实现。
也就是说，Function对象的原型对象就是其自身Function(),Function对象是由其自身构造的。bootstrap?！但请注意Function.prototype是由Object().prototype构造的。

**前面只是说原型对象(prototype属性所引用的对象)由javascript引擎生成的，但其构造器是什么呢？**

除了Object()之外的所有函数构造器，包括自定义构造器，他们"关联"的原型对象(prototype属性所引用)都是由Object()构造器构造而来，也就是他们“关联”的原型对象(prototype属性所引用)的原型对象(由__proto__属性所引用)是Object.prototype。那么Object()构造器关联的原型对象Object.prototype(prototype属性所引用)是由谁负责构造的呢？答案就是，Object.prototype是原型链的顶端，是有javascript引擎构造出来的，它没有构造器，它的__proto__属性为null。

**3、对象的__proto__属性指向哪里？**
**首先看用户对象**
对于用户自定义的对象，其__proto__属性都指向使用的构造器的prototype对象
\[javascript\]
function f(){this.test="";}
var f1 = new f();
console.log(f.prototype); //f{}
console.log(f1.prototype); //undefined
console.log(f1.__proto__); //f{}
console.log(f1.constructor);//function f(){this.test="";}
\[/javascript\]

对于对象直接量，其实内部是调用Object函数构造器来构造对象的，所以其__proto__指向Object原型对象。Object其实是一个函数，是由Fucntion对象构造的。
\[javascript\]
var o={first:1,last:2};
console.log(o.prototype); //undefined
console.log(o.__proto__); //Object{}
console.log(o.constructor);//Object() 或输出function Object() { \[native code\] }
\[/javascript\]

对于数组对象直接量,则是由内部调用Array函数构造器来构造的。
\[javascript\]
var arr = \[\];
console.log(arr.prototype); //undefined
console.log(arr.__proto__);//\[\]
console.log(o.constructor);//function Array() { \[native code\] }
\[/javascript\]

其他内置对象大抵如是。

**再看用户自定义函数**
用户自定义函数都是由Function()构造器构造的,其__proto__属性都指向Function.prototype
\[javascript\]
function f(){this.test="";}
console.log(f.__proto__); //function() 
console.log(Function.prototype); //function() 
console.log(f.__proto__=== Function.prototype); //true
\[/javascript\]

**最后看内置对象**
内置函数对象其__proto__属性都指向Function.prototype,因为这些对象都是函数原型派生而来，具有函数的公共方法，比如call,apply,bind等。
\[javascript\]
console.log(Object.__proto__); //function()
console.log(Function.__proto__); //function()
console.log(Arrar.__proto__);//function()
\[/javascript\]

**4、函数构造器与变量**
为什么构造器里用var声明的变量，派生对象无法访问，而用this限定的变量派生对象可以访问到呢？这是因为new操作符。

new主要做了三件事，这里大大简化了：
第一，创建一个空object,注意不是Object()
第二，将空对象的constructor属性初始化为基对象prototype对象的constructor属性的值，将空对象的__proto__属性初始化成基对象的prototype属性引用的原型对象
第三，将空对象绑定到构造器上来调用构造器，类似constructor.call(obj,parameters)，也就是构造器里的this即指向新创建的对象。

所以从第三步可以看出，使用this限定的构造器变量，在这一步执行时，实际上就为派生对象添加了对应的属性，所以派生对象可以访问到这个变量，因为这已经成了派生对象的内置属性。而用var修饰的局部变量则与派生对象毫无关系，构造器执行完毕后，这些局部变量就被销毁了。
所以说，**实例对象从其构造器静态获取属性，而从其原型对象(__proto__引用的对象)动态获取属性**。阮一峰在[Javascript继承机制的设计思想](http://www.ruanyifeng.com/blog/2011/06/designing_ideas_of_inheritance_mechanism_in_javascript.html)说,"**实例对象的属性和方法，分成两种，一种是本地的，另一种是引用的**",既是此意。

**5、Object.prototype**

Object.prototype的__proto__属性指向哪里？答：指向null。
这已经是javascript对象原型链的顶点了。

**6、函数构造器“关联”的原型对象有prototype吗？**
没有，但他们有__proto__属性指向其原型对象。因为他们都是普通的对象，Function有点儿例外，但Function的原型对象也只是个普通的函数，而不是函数对象。再次证明，只有函数构造器对象才有prototype属性。

**7、函数构造器从其prototype指向的原型对象继承属性吗？**
答案是：Nope。函数构造器prototype属性“关联”的原型对象是为从这个构造器派生的对象提供原型服务的，构造器自身从其__proto__也就是\[\[prototype\]\]属性指向的原型对象（亦即其自身的构造器）继承属性。

**8、Object()构造器与Function()构造器**
Object()是由Function()构造的(Object.__proto__ = Function.prototype),而Function()是由其自身构造的(Function.__proto__ = Function.prototype)。而Function.prototype是由Object()构造的(Function.prototype.__proto__=Object.prototype)。
有此可知，Object()是Function()的直接实例，而Function()是Object()的间接实例，所以Object()与Function()互为实例
\[javascript\]
console.log(Object instanceof Function); //true
console.log(Function instanceof Object); //true
console.log(Object.__proto__ == Function.prototype); //true
console.log(Function.__proto__.__proto__ == Object.prototype); //true
\[/javascript\]

**9、如果忘了new会怎样?**

如果忘了在构造器上使用new操作符,那么构造器会退化成一个普通的函数调用
\[javascript\]
function F(){this.test="";}
var f = F();
console.log(typeof f); //undefined 
console.log(f); //undefined 
\[/javascript\]

没有new就不会生成一个新的对象，而且函数如果没有return语句，默认返回undefined。如果函数有显式的return语句，则f为return返回结果的引用。

**10、如果构造器返回一个对象**

构造器函数也是函数，它可以返回它想返回的任何类型，虽然通常情况下构造器函数没有return语句，不会显式的返回值，但却会隐式的返回undefined。构造器也可以有显式的return语句，返回简单数据类型或对象。比如：
\[javascript\]
return 0; //number
return ""; //string
return true; //boolean
return; //undefined
return {}; //object
return \[1,2\]; //object
return function(){}; //function
\[/javascript\]

new操作符的行为正与构造器的返回类型有关。上面有一点儿没有提到，new操作符创建了一个新对象，但具体返回什么还要看构造器函数的返回值类型。
如果构造器函数返回undefined,number,string,boolean等简单数据类型,那么new操作符会返回新构造的对象覆盖构造器函数的返回。但是如果构造器函数返回了object或function等对象类型，那么new操作符会抛弃新构造的对象而直接返回构造器函数的返回值。
简单来说，如果构造器返回的是对象new操作符就直接返回这个对象，否则new操作符返回新构造的对象，也就是new操作符总是返回一个对象而不会返回简单数据类型。

如果不在构造器函数上施加new运算符，则构造器函数就是一个普通的函数，直接返回其返回值，隐式的或显式的。

当函数构造器返回一个对象或函数(也是对象)时，用不用new运算符，结果都是一样的。

\[javascript\]
 function Bar() {
 return 0;
 //return "";
 //return true;
 //return;
 //return \[1,2\];
 //return {};
 //return function(){};
 }

 Bar.prototype = {
 foo: function() {}
 };

 var bar1 = new Bar();
 var bar2 = Bar();
 
 console.log(typeof bar1); //object

 //返回的是Bar对象，所以其有foo属性，会从Bar.prototype继承属性
 console.log(bar1.__proto__); //Object {foo: function}

 console.log(typeof bar2); //number
 console.log(bar2.__proto__); //Number {}
\[/javascript\]

**\===
\[erq\]**