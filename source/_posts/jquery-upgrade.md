---
title: jQuery 1.x 升级
tags:
  - Javascript
id: '5530'
categories:
  - - GNU/Linux
date: 2014-05-20 14:47:16
---


<!-- more -->
jQuery 1.9 删除了一些过时的API,修改了一些API的行为。比如jQuery.browser()已经移除了，推荐使用[Modernizr](http://modernizr.com/)特性检测库，而不是检测特定的浏览器。
从jQuery 2+起,不再支持IE6/7/8。

jQuery提供了迁移插件[jquery-migrate](https://github.com/jquery/jquery-migrate/)来辅助用户平滑升级。
jquery-migrate插件恢复了被删除或变化的API,但会在console给出警告(注意:只有开发版才会给出警告)。
jquery-migrate插件可以用于jQuery 2.x版本，但这只是个过渡，现有产品应该尽快将源代码迁移到jQuery 2.x上来。

这样使用jquery-migrate插件
```js
<script src="js/jquery-2.1.1.js"></script>
<script src="js/jquery-migrate-1.2.1.js"></script>
```

抛弃低版本IE浏览器是大势所趋。IE浏览器从版本11开始才真正算是一个现代浏览器。

也可以使用[条件注释](http://www.quirksmode.org/css/condcom.html)语句为低版本IE使用低版本的jQuery。

References:
\[1\][jQuery Core 1.9 Upgrade Guide](http://jquery.com/upgrade-guide/1.9/)
\[2\][jQuery 1.9升级指南](http://www.css88.com/archives/4564)
\[3\][jQuery 1.9 移除了 $.browser 的替代方法](http://www.fwolf.com/blog/post/35)
\[4\][Conditional comments](http://www.quirksmode.org/css/condcom.html)

**\===
\[erq\]**