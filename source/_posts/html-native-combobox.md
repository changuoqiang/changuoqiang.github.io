---
title: HTML原生combobox
tags: []
id: '6381'
categories:
  - - GNU/Linux
date: 2015-05-05 13:27:15
---


<!-- more -->
带有datalist的input即是html原生的combobox,再也无需用select+input来模拟combobox了。

而且每个option还可以有label。

就像下面这样：


 
 
 


源代码：
\[html\]
<input type="url" list="url_list" name="link" />
<datalist id="url_list">
 <option label="W3Schools" value="http://www.w3schools.com" />
 <option label="Google" value="http://www.google.com" />
 <option label="Microsoft" value="http://www.microsoft.com" />
</datalist>
\[/html\]

当前主要的浏览器中只有safari还完全不支持datalist,可以使用[webshim](https://github.com/aFarkas/webshim/)HTML5垫片程序提供支持。

检测浏览器是否支持datalist
\[javascript\]
if ('options' in document.createElement('datalist')) {
 // supported!
}
\[/javascript\]

References:
\[1\] [THE ALL-IN-ONE ALMOST-ALPHABETICAL GUIDE TO DETECTING EVERYTHING](http://diveintohtml5.info/everything.html)
**\===
\[erq\]**