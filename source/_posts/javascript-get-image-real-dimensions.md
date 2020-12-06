---
title: Javascript获取图片实际尺寸
tags:
  - Javascript
id: '5866'
categories:
  - - GNU/Linux
date: 2014-09-20 23:07:23
---


<!-- more -->
img元素的width和height属性只会取出图像当前的宽度和高度,这宽度和高度可能不是图像原始的尺寸,因为img元素可以指定width和height属性。

现代浏览器为img元素添加了两个属性naturalWidth和naturalHeight可以获取图像的原始尺寸。这两个属性是只读的。
jquery没有对应的属性或方法，可以通过获取原始的dom对象来读取这两个属性。

对于不支持这个两个属性的浏览器,可以通过生成一个不设定width和height的内存图像来获取原始尺寸。

代码如下：
```js
var image = document.getElementById("img_id");

if(typeof image.naturalWidth == "undefined") {
 // legacy browsers
 var tmp_img = new Image();
 tmp_img.addEventListener('load', function(e){
 var rw = tmp_img.width;
 var rh = tmp_img.height;
 });
 tmp_img.src = image.src;
}else{
 // modern browsers
 var rw = image.naturalWidth;
 var rh = image.naturalHeight;
}
```

**\===
\[erq\]**