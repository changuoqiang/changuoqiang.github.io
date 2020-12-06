---
title: IE版本检测
tags:
  - Javascript
id: '6730'
categories:
  - - javascript
date: 2015-10-11 21:30:42
---


<!-- more -->
IE版本检测有很多方法，特性检测是比较好的一种方式。

非标准的document.all对象只存在于IE10及以下版本。其实，其他浏览器比如chrome也实现了document.all对象，不过在这些浏览器中以布尔方式判断document.all对象都是返回undefined的。

可以这样测试:
\[javascript\]
<script>
if (!document.all) {
 console.log(typeof(document.all));
 console.log(document.all);
}
</script>
\[/javascript\]

再佐以其他IE版本相关的特性,详见参考\[1\],可以有如下的IE版本检测代码:
\[javascript\]
var v;

if (document.all) {
 if (window.atob) {
 v = '10';
 }
 else if (document.addEventListener) {
 v = '9';
 }
 else if (document.querySelector) {
 v = '8';
 }
 else if (window.XMLHttpRequest) {
 v = '7';
 }
 else if (document.compatMode) {
 v = '6';
 }
 else {
 v = '5.5 or older';
 }

 v = 'IE' + v;
}
else {
 v = 'IE11+ or not IE';
}

console.log('Your browser is' + v);

\[/javascript\]

References:
\[1\][Internet Explorer (IE) version detection in JavaScript](http://tanalin.com/en/articles/ie-version-js/)
\[2\][JavaScript判断IE各版本最完美解决方案](https://github.com/nioteam/jquery-plugins/issues/12)

**\===
\[erq\]**