---
title: HTML自定义标签与标签自定义属性
tags:
  - HTML
id: '3152'
categories:
  - - javascript
date: 2013-06-16 22:25:28
---

大部分浏览器支持自定义HTML标签和为标准标签自定义属性，而且很多浏览器对这两种自定义行为的支持都很直接了当。
<!-- more -->
**自定义HTML标签**

在firefox、chrome这种现代浏览器里，自定义标签很简单，就像标准的标签那样写就可以了，而且CSS和JavaScript存取自定义标签和标准标签并无二致。

\[javascript\]
<foo id="idFoo" style="color:red" data-bar="bar">foo tag!</foo>
<script>
 (function(){
 console.log($("foo").text()); //foo tag!
 console.log($("foo").data("bar")); //bar
 console.log(document.getElementById("idFoo").innerHTML); //foo tag!
 console.log(document.getElementById("idFoo").getAttribute("data-bar")); //bar
 })();
</script>
\[/javascript\]

firefox 21,chrome 27,IE 10表现都十分正常。IE9没有测试，据说[也没问题](http://www.qttc.net/201305333.html)。

不过据说在IE8及之前，自定义标签没那么简单，可以通过添加命名空间或者是document.createElement("自定义标签名称")来进行自定义HTML标签，不过如果你想在自定义的标签上使用CSS选择器，则必须使用document.createElement("自定义标签名称")，不管有没有定义过XML命名空间。参见[这里](http://freewind.me/blog/20130101/1230.html)。

还有人报告一个IE8自定义标签的问题，"[事先已document.createElement('thetag')，但后续通过innerHTML的方式添加的该元素，IE8是不认的,createElement + appendChild 则可以](http://www.cnblogs.com/ecma/archive/2012/02/01/2335047.html)"。

新的项目已经决定只支持Firefox,Chrome,IE9+版本，IE6,7,8之类的随它去吧。

**标签自定义属性**

自定义标签属性经常会用到，但是一直是没有规范来约束如何自定义标签属性，导致一些混乱和移植性问题。现在HTML5增加了一个[自定义data属性](http://www.w3.org/TR/html5/dom.html#custom-data-attribute)的特性。

很简单，只要自定义属性以data-开头，后面至少跟随一个字符即可，但是不能包含字符U+0041到U+005A (LATIN CAPITAL LETTER A to LATIN CAPITAL LETTER Z)。每个元素可包含多个自定义属性。

这些data-属性在页面上是不显示的，不会影响页面布局和风格，但它却是可读可写的。

jQuery已经支持通过data方法来读取自定义的data-属性，而且支持json格式的属性值，很方便。

\[javascript\]
<foo id="idFoo" style="color:red" data-bar="bar" data-obj='{"key1":"value1"}' >foo tag!</foo>
<script>
 (function(){
 console.log($("foo").text()); //foo tag!
 console.log($("foo").data("bar")); //bar
 console.log($("foo").data("obj").key1); //value1
 console.log(document.getElementById("idFoo").innerHTML); //foo tag!
 console.log(document.getElementById("idFoo").innerText); //foo tag!注:firefox 21不支持
 console.log(document.getElementById("idFoo").getAttribute("data-bar")); //bar
 })();
</script>
\[/javascript\]

上面的代码中，在自定义属性中使用json数据需要注意，一定要在外层使用单引号'，内层使用双引号",如果反过来,firefox和chrome都会报undefined。

自定义标签的innerText属性，firefox 21不支持，输出"undefined",chrome 27和IE 10输出正常。

也可以通过data(key,value)方式为自定义data属性赋值。

自定义data属性代码在friefox 21,chrome 27,IE 10测试通过。

UPDATE(05/21/2014):
`The data- attributes are pulled in the first time the data property is accessed and then are no longer accessed or mutated (all data values are then stored internally in jQuery).`

data-特性(attributes)只在第一次读取时获取其值，并且将其缓存到jQuery内部，之后不再读取或改变data-特性。也就是说第一次读取之后，如果通过.attr()方法修改了特性的值，然后再通过data方法读取时仍然是原来的值。

References:
\[1\][HTML 5 的data-× 自定义属性和 jQuery的data（）方法](http://www.ifanybug.com/article/00147.html)

**\===
\[erq\]**