---
title: jQuery使用POST方法以JSON字符串方式发送普通对象
tags:
  - Javascript
id: '5617'
categories:
  - - javascript
date: 2014-06-17 21:40:41
---


<!-- more -->
调用$.ajax函数时，即使设置contentType为'application/json; charset=utf-8',如果给data属性传递的是一个的对象，这时候jQuery也不会将其自动转换为JSON字符串。jQuery默认会将给data赋予的对象(除字符串之外的任何东西)处理为适用于"application/x-www-form-urlencoded"的请求字符串。

有一个选项processData来控制默认的自动转换，设置其为false,jQuery就不会自动转换对象。

所以如果要向服务器传送JSON字符串就只能自力更生了。如果自己能完全控制.ajax请求就简单了，只要使用JSON.stringify将对象转换为JSON字符串再传递给data就好了。

如果使用第三方库又不想直接修改源代码，可以通过$.ajaxSetup来动态修改传递的数据，看代码：

\[javascript\]
 $.ajaxSetup({
 processData:false,
 beforeSend: function(jqXHR, settings){
 if((settings.contentType.indexOf('application/json') != -1)
 && (typeof settings.data != 'string')){
 settings.data = JSON.stringify(settings.data);
 }
 }
 });
\[/javascript\]
不过这是修改jQuery ajax请求的全局配置一定要格外小心，比如processData设置为false后，其他ajax请求也不会自动转换请求数据了。

**\===
\[erq\]**