---
title: 在Re­quireJS之前加载jQuery
tags:
  - Javascript
id: '5648'
categories:
  - - javascript
date: 2014-07-11 22:17:48
---


<!-- more -->
有时候可能会需要在加载Re­quireJS之前就加载jQuery,因为有些代码并不在Re­quireJS的管理范围之内,比如这样
\[html\]
<script src="jquery.js"></script>
<script src="require.js" data-main="main.js"></script>
\[/html\]
but这时候会出现错误,怎么办呢？
因为jQuery无论如何都是会暴露到全局名字空间的,所以为main.js文件的前部为jQuery定义一个占位模块好了
\[html\]
define('jquery', \[\], function() {
 return jQuery;
});
\[/html\]

其实最新版本的jQuery也是在检测到Re­quireJS之后这样来定义jQuery模块的。

References:
\[1\][Load jQuery be­fore Re­quireJS and still use it as de­pend­ency](http://www.manuel-strehl.de/dev/load_jquery_before_requirejs.en.html)

**\===
\[erq\]**